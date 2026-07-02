import 'dart:math';

/// Calculadora de distancias y tiempos de caminata para WasiStudent.
///
/// Implementa la fórmula de Haversine para calcular distancias geodésicas
/// y ajusta los tiempos de caminata según la altitud de Cusco (3,400m s.n.m.).
///
/// A 3,400m la capacidad aeróbica se reduce ~25-30%, por lo que la
/// velocidad promedio de caminata es ~3 km/h (vs 5 km/h a nivel del mar).
class DistanceCalculator {
  DistanceCalculator._();

  // ── Constantes ─────────────────────────────────────────────────────
  static const double _earthRadiusKm = 6371.0;
  static const double _walkingSpeedAltitudeKmh = 3.0;
  static const double _walkingSpeedSeaLevelKmh = 5.0;

  // ── Fórmula de Haversine ───────────────────────────────────────────

  /// Calcula la distancia en kilómetros entre dos puntos geográficos
  /// usando la fórmula de Haversine.
  ///
  /// Parámetros:
  /// - [lat1], [lon1]: Coordenadas del punto de origen (grados decimales)
  /// - [lat2], [lon2]: Coordenadas del punto de destino (grados decimales)
  ///
  /// Retorna la distancia en kilómetros.
  static double haversine(
      double lat1, double lon1, double lat2, double lon2) {
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadiusKm * c;
  }

  /// Calcula la distancia en metros entre dos puntos geográficos.
  static double haversineMeters(
      double lat1, double lon1, double lat2, double lon2) {
    return haversine(lat1, lon1, lat2, lon2) * 1000;
  }

  // ── Tiempo de caminata ─────────────────────────────────────────────

  /// Calcula el tiempo de caminata en minutos, ajustado por la altitud
  /// de Cusco (3,400m s.n.m.).
  ///
  /// La velocidad promedio a altitud es ~3 km/h, comparado con
  /// ~5 km/h a nivel del mar.
  ///
  /// Retorna el tiempo en minutos, redondeado al entero más cercano.
  static int walkingTimeMinutes(double distanceKm) {
    if (distanceKm <= 0) return 0;
    final hours = distanceKm / _walkingSpeedAltitudeKmh;
    return (hours * 60).round().clamp(1, 999);
  }

  /// Calcula el tiempo de caminata en minutos a nivel del mar (5 km/h).
  ///
  /// Útil como referencia para comparar el impacto de la altitud.
  static int walkingTimeMinutesSeaLevel(double distanceKm) {
    if (distanceKm <= 0) return 0;
    final hours = distanceKm / _walkingSpeedSeaLevelKmh;
    return (hours * 60).round().clamp(1, 999);
  }

  /// Calcula la diferencia porcentual en tiempo de caminata debido
  /// a la altitud.
  ///
  /// Retorna un valor como 0.67, indicando que a altitud se tarda
  /// ~67% más que a nivel del mar.
  static double altitudeTimePenalty(double distanceKm) {
    if (distanceKm <= 0) return 0.0;
    final atAltitude = walkingTimeMinutes(distanceKm);
    final atSeaLevel = walkingTimeMinutesSeaLevel(distanceKm);
    if (atSeaLevel == 0) return 0.0;
    return (atAltitude - atSeaLevel) / atSeaLevel;
  }

  // ── Formateo de distancia ──────────────────────────────────────────

  /// Formatea una distancia en metros a una cadena legible.
  ///
  /// - Menos de 1000m: "X m" (ej. "350 m", "800 m")
  /// - 1000m o más: "X.X km" (ej. "1.2 km", "3.5 km")
  static String formatDistance(double meters) {
    if (meters < 0) return '0 m';
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  /// Formatea una distancia en kilómetros a una cadena legible.
  static String formatDistanceKm(double km) {
    return formatDistance(km * 1000);
  }

  // ── Rumbo (bearing) ────────────────────────────────────────────────

  /// Calcula el rumbo (bearing) inicial desde el punto 1 hacia el punto 2.
  ///
  /// Retorna el ángulo en grados (0-360), donde:
  /// - 0° = Norte
  /// - 90° = Este
  /// - 180° = Sur
  /// - 270° = Oeste
  static double bearing(
      double lat1, double lon1, double lat2, double lon2) {
    final dLon = _toRad(lon2 - lon1);

    final y = sin(dLon) * cos(_toRad(lat2));
    final x = cos(_toRad(lat1)) * sin(_toRad(lat2)) -
        sin(_toRad(lat1)) * cos(_toRad(lat2)) * cos(dLon);

    final brng = atan2(y, x);
    return (_toDeg(brng) + 360) % 360;
  }

  /// Convierte un ángulo de rumbo en grados a una dirección cardinal.
  ///
  /// Ejemplos:
  /// - 0° → 'N' (Norte)
  /// - 45° → 'NE' (Noreste)
  /// - 90° → 'E' (Este)
  /// - 180° → 'S' (Sur)
  /// - 270° → 'O' (Oeste)
  static String bearingToCardinal(double bearing) {
    const directions = [
      'N', 'NNE', 'NE', 'ENE',
      'E', 'ESE', 'SE', 'SSE',
      'S', 'SSO', 'SO', 'OSO',
      'O', 'ONO', 'NO', 'NNO',
    ];

    final index = ((bearing + 11.25) % 360 / 22.5).floor();
    return directions[index];
  }

  /// Retorna la dirección cardinal en español con descripción.
  static String bearingToCardinalFull(double bearing) {
    const directions = {
      'N': 'Norte',
      'NNE': 'Nornoreste',
      'NE': 'Noreste',
      'ENE': 'Estenoreste',
      'E': 'Este',
      'ESE': 'Estesureste',
      'SE': 'Sureste',
      'SSE': 'Sursureste',
      'S': 'Sur',
      'SSO': 'Sursuroeste',
      'SO': 'Suroeste',
      'OSO': 'Oestesuroeste',
      'O': 'Oeste',
      'ONO': 'Oestenoroeste',
      'NO': 'Noroeste',
      'NNO': 'Nornoroeste',
    };

    final cardinal = bearingToCardinal(bearing);
    return directions[cardinal] ?? cardinal;
  }

  // ── Punto medio ────────────────────────────────────────────────────

  /// Calcula el punto medio geográfico entre dos coordenadas.
  ///
  /// Retorna una lista [latitud, longitud] del punto medio.
  static List<double> midpoint(
      double lat1, double lon1, double lat2, double lon2) {
    final dLon = _toRad(lon2 - lon1);

    final cosLat2 = cos(_toRad(lat2));
    final sinLat2 = sin(_toRad(lat2));

    final bx = cosLat2 * cos(dLon);
    final by = cosLat2 * sin(dLon);

    final lat3 = atan2(
      sin(_toRad(lat1)) + sinLat2,
      sqrt((cos(_toRad(lat1)) + bx) * (cos(_toRad(lat1)) + bx) + by * by),
    );

    final lon3 = _toRad(lon1) + atan2(by, cos(_toRad(lat1)) + bx);

    return [_toDeg(lat3), _toDeg(lon3)];
  }

  /// Calcula el punto destino dados un origen, rumbo y distancia.
  ///
  /// Parámetros:
  /// - [lat], [lng]: Coordenadas de origen
  /// - [bearingDeg]: Rumbo en grados
  /// - [distanceKm]: Distancia en kilómetros
  ///
  /// Retorna [latitud, longitud] del punto destino.
  static List<double> destinationPoint(
      double lat, double lng, double bearingDeg, double distanceKm) {
    final brng = _toRad(bearingDeg);
    final d = distanceKm / _earthRadiusKm;

    final latRad = _toRad(lat);
    final lonRad = _toRad(lng);

    final lat2 = asin(sin(latRad) * cos(d) +
        cos(latRad) * sin(d) * cos(brng));

    final lon2 = lonRad +
        atan2(sin(brng) * sin(d) * cos(latRad),
            cos(d) - sin(latRad) * sin(lat2));

    return [_toDeg(lat2), _toDeg(lon2)];
  }

  // ── Helpers ────────────────────────────────────────────────────────

  static double _toRad(double degrees) => degrees * pi / 180.0;
  static double _toDeg(double radians) => radians * 180.0 / pi;
}
