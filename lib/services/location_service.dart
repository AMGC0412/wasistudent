import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

/// Servicio de ubicación para WasiStudent.
/// Gestiona permisos, obtiene la ubicación actual del usuario,
/// calcula distancias y tiempos de caminata ajustados por altitud
/// (Cusco, 3,400m s.n.m.), y abre coordenadas en Google Maps.
class LocationService {
  Position? _currentPosition;

  /// Última posición conocida del usuario.
  Position? get currentPosition => _currentPosition;

  // ── Velocidad de caminata ajustada por altitud ─────────────────────
  // A 3,400m la capacidad aeróbica se reduce ~25-30%.
  // Velocidad promedio en llano a altitud: ~3 km/h (vs 5 km/h a nivel del mar)
  static const double _walkingSpeedAltitudeKmh = 3.0;
  static const double _walkingSpeedSeaLevelKmh = 5.0;

  // ── Solicitar permisos de ubicación ────────────────────────────────

  /// Solicita permisos de ubicación al usuario.
  /// Retorna `true` si los permisos fueron concedidos, `false` en caso contrario.
  ///
  /// Verifica y solicita permisos de ubicación cuando está en uso.
  /// Si el servicio de ubicación está deshabilitado, intenta solicitar
  /// que el usuario lo active.
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // El servicio de ubicación está deshabilitado.
      // No podemos solicitar que se active programáticamente en todas las
      // plataformas, pero Geolocator.openLocationSettings() puede ayudar.
      await Geolocator.openLocationSettings();
      // Verificar nuevamente después de un momento
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permisos denegados
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permisos denegados permanentemente. Abrir configuración.
      await Geolocator.openAppSettings();
      return false;
    }

    return true;
  }

  // ── Obtener ubicación actual ───────────────────────────────────────

  /// Obtiene la ubicación actual del usuario.
  ///
  /// Si los permisos no han sido concedidos, los solicita primero.
  /// Almacena la posición en [_currentPosition] para uso posterior.
  ///
  /// Retorna la [Position] actual o `null` si no se pudo obtener.
  Future<Position?> getCurrentLocation() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) return null;

    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      return _currentPosition;
    } on LocationServiceDisabledException {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Obtiene la última posición conocida sin solicitar una nueva lectura.
  /// Retorna la posición almacenada o intenta obtener la última conocida
  /// del sistema si no hay ninguna en caché.
  Future<Position?> getLastKnownPosition() async {
    if (_currentPosition != null) return _currentPosition;

    try {
      _currentPosition = await Geolocator.getLastKnownPosition();
      return _currentPosition;
    } catch (_) {
      return null;
    }
  }

  // ── Cálculo de distancia ───────────────────────────────────────────

  /// Calcula la distancia en kilómetros desde la ubicación actual del
  /// usuario hasta las coordenadas dadas.
  ///
  /// Si no hay posición actual, usa las coordenadas del centro de Cusco.
  Future<double> getDistanceTo(double lat, double lng) async {
    final position = _currentPosition ?? await getCurrentLocation();
    if (position == null) {
      // Usar centro de Cusco como fallback
      return _haversineDistance(
        -13.5319, -71.9675, // Cusco centro
        lat,
        lng,
      );
    }

    return _haversineDistance(
      position.latitude,
      position.longitude,
      lat,
      lng,
    );
  }

  /// Calcula la distancia en kilómetros entre dos coordenadas usando
  /// la fórmula de Haversine.
  double _haversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  // ── Tiempo de caminata ─────────────────────────────────────────────

  /// Calcula el tiempo estimado de caminata en minutos, ajustado por
  /// la altitud de Cusco (3,400m s.n.m.).
  ///
  /// A 3,400m la velocidad promedio es ~3 km/h en terreno llano,
  /// comparado con ~5 km/h a nivel del mar.
  int getWalkingTime(double distanceKm) {
    if (distanceKm <= 0) return 0;
    final hours = distanceKm / _walkingSpeedAltitudeKmh;
    return (hours * 60).round().clamp(1, 999);
  }

  /// Calcula el tiempo estimado de caminata a nivel del mar (5 km/h).
  /// Útil para comparación o cuando la altitud no es relevante.
  int getWalkingTimeSeaLevel(double distanceKm) {
    if (distanceKm <= 0) return 0;
    final hours = distanceKm / _walkingSpeedSeaLevelKmh;
    return (hours * 60).round().clamp(1, 999);
  }

  // ── Abrir en Maps ──────────────────────────────────────────────────

  /// Abre las coordenadas dadas en Google Maps (o la app de mapas
  /// predeterminada del dispositivo).
  ///
  /// Retorna `true` si se pudo abrir exitosamente, `false` en caso contrario.
  Future<bool> openInMaps(double lat, double lng) async {
    // Google Maps URL
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    // URL geo: como fallback
    final geoUrl = 'geo:$lat,$lng';

    // Intentar con Google Maps primero
    final googleUri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(googleUri)) {
      return launchUrl(googleUri, mode: LaunchMode.externalApplication);
    }

    // Fallback a geo: URI
    final geoUri = Uri.parse(geoUrl);
    if (await canLaunchUrl(geoUri)) {
      return launchUrl(geoUri, mode: LaunchMode.externalApplication);
    }

    return false;
  }

  /// Abre la ruta desde la ubicación actual hasta las coordenadas dadas.
  Future<bool> openDirectionsInMaps(double destLat, double destLng) async {
    final position = _currentPosition;

    String directionsUrl;
    if (position != null) {
      directionsUrl =
          'https://www.google.com/maps/dir/?api=1&origin='
          '${position.latitude},${position.longitude}'
          '&destination=$destLat,$destLng&travelmode=walking';
    } else {
      directionsUrl =
          'https://www.google.com/maps/dir/?api=1'
          '&destination=$destLat,$destLng&travelmode=walking';
    }

    final uri = Uri.parse(directionsUrl);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return false;
  }

  // ── Formateo de distancia ──────────────────────────────────────────

  /// Formatea una distancia en metros a una cadena legible.
  /// - Menos de 1000m: "X m"
  /// - 1000m o más: "X.X km"
  String formatDistance(double meters) {
    if (meters < 0) return '0 m';
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  /// Formatea un tiempo de caminata en minutos a una cadena legible.
  /// - Menos de 60 min: "X min"
  /// - 60 min o más: "X h Y min"
  String formatWalkingTime(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) return '$hours h';
    return '$hours h $remainingMinutes min';
  }
}
