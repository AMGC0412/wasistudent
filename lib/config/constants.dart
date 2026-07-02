import 'package:flutter/material.dart';

/// Constantes centrales de la aplicación WasiStudent
class AppConstants {
  AppConstants._();

  // ── Identidad ──
  static const String appName = 'WasiStudent';
  static const String appNameLower = 'wasistudent';
  static const String packageName = 'com.wasistudent.app';
  static const String version = '4.0.0';
  static const int buildNumber = 4;
  static const String tagline = 'Tu hogar estudiantil en el Cusco';
  static const String taglineEn = 'Live well, study better';
  static const String taglineQuechua = 'Allin wasistudent, allin yachay';
  static const String description =
      'Vivienda estudiantil verificada en el Cusco. Encuentra tu hogar ideal cerca de tu universidad.';

  // ── Cusco ──
  static const double cuscoLatitude = -13.5319;
  static const double cuscoLongitude = -71.9675;
  static const double cuscoAltitudeMeters = 3399.0;
  static const double cuscoAltitudeFeet = 11151.6;
  static const String cuscoTimezone = 'America/Lima';
  static const String cuscoCountry = 'Perú';
  static const String cuscoRegion = 'Cusco';
  static const String cuscoDistrict = 'Cusco';

  // ── Caminata a altitud ──
  // A 3,400m la capacidad aeróbica se reduce ~25-30%
  // Velocidad promedio en llano a altitud: ~3.2 km/h (vs 5 km/h a nivel del mar)
  // Velocidad en subida: ~2.0 km/h | En bajada: ~3.8 km/h
  static const double walkingSpeedSeaLevelKmh = 5.0;
  static const double walkingSpeedAltitudeKmh = 3.2;
  static const double walkingSpeedUphillKmh = 2.0;
  static const double walkingSpeedDownhillKmh = 3.8;
  static const double altitudePerformanceFactor = 0.70; // 70% del rendimiento a nivel del mar
  static const int recommendedAcclimatizationHours = 24;

  /// Calcula el tiempo estimado de caminata en minutos a altitud cusqueña
  static int estimateWalkingMinutes(double distanceKm, {bool uphill = false, bool downhill = false}) {
    double speed;
    if (uphill) {
      speed = walkingSpeedUphillKmh;
    } else if (downhill) {
      speed = walkingSpeedDownhillKmh;
    } else {
      speed = walkingSpeedAltitudeKmh;
    }
    return ((distanceKm / speed) * 60).round().clamp(1, 999);
  }

  /// Calcula la distancia en km a partir del tiempo de caminata en minutos
  static double estimateDistanceKm(int walkingMinutes, {bool uphill = false, bool downhill = false}) {
    double speed;
    if (uphill) {
      speed = walkingSpeedUphillKmh;
    } else if (downhill) {
      speed = walkingSpeedDownhillKmh;
    } else {
      speed = walkingSpeedAltitudeKmh;
    }
    return (walkingMinutes / 60.0) * speed;
  }

  // ── Presupuesto (en soles peruanos - PEN) ──
  static const double minBudgetMonthly = 250.0;
  static const double maxBudgetMonthly = 3500.0;
  static const double budgetStep = 50.0;
  static const List<double> budgetPresetRanges = [400, 600, 800, 1000, 1200, 1500, 2000];
  static const double currencyExchangeRatePENtoUSD = 0.27; // aprox
  static const String currencyCode = 'PEN';
  static const String currencySymbol = 'S/';
  static const String currencyName = 'Soles';

  /// Formatea un monto en soles
  static String formatPrice(double amount) {
    return '$currencySymbol ${amount.toStringAsFixed(0)}';
  }

  /// Formatea un monto mensual
  static String formatMonthlyPrice(double amount) {
    return '${formatPrice(amount)}/mes';
  }

  // ── Universidades del Cusco ──
  static const List<University> universities = [
    University(
      id: 'unsaac',
      name: 'Universidad Nacional de San Antonio Abad del Cusco',
      shortName: 'UNSAAC',
      latitude: -13.5178,
      longitude: -71.9781,
      type: UniversityType.public,
      studentCount: 18000,
    ),
    University(
      id: 'urp',
      name: 'Universidad Ricardo Palma',
      shortName: 'URP Cusco',
      latitude: -13.5250,
      longitude: -71.9600,
      type: UniversityType.private,
      studentCount: 3500,
    ),
    University(
      id: 'andina',
      name: 'Universidad Andina del Cusco',
      shortName: 'UAndina',
      latitude: -13.5310,
      longitude: -71.9520,
      type: UniversityType.private,
      studentCount: 5000,
    ),
    University(
      id: 'tec',
      name: 'Universidad Tecnológica de los Andes',
      shortName: 'UTA',
      latitude: -13.5230,
      longitude: -71.9440,
      type: UniversityType.private,
      studentCount: 4200,
    ),
    University(
      id: 'continental',
      name: 'Universidad Continental',
      shortName: 'Continental',
      latitude: -13.5180,
      longitude: -71.9690,
      type: UniversityType.private,
      studentCount: 6000,
    ),
    University(
      id: 'sanignacio',
      name: 'Universidad San Ignacio de Loyola',
      shortName: 'USIL Cusco',
      latitude: -13.5290,
      longitude: -71.9630,
      type: UniversityType.private,
      studentCount: 2800,
    ),
    University(
      id: 'peruandes',
      name: 'Universidad Peruana de los Andes',
      shortName: 'UPA',
      latitude: -13.5270,
      longitude: -71.9470,
      type: UniversityType.private,
      studentCount: 3100,
    ),
    University(
      id: 'césarvallejo',
      name: 'Universidad César Vallejo - Filial Cusco',
      shortName: 'UCV Cusco',
      latitude: -13.5340,
      longitude: -71.9580,
      type: UniversityType.private,
      studentCount: 4500,
    ),
    University(
      id: 'alasperu',
      name: 'Universidad Alas Peruanas - Filial Cusco',
      shortName: 'UAP Cusco',
      latitude: -13.5200,
      longitude: -71.9550,
      type: UniversityType.private,
      studentCount: 2200,
    ),
    University(
      id: 'senati',
      name: 'SENATI - Centro de Formación Profesional',
      shortName: 'SENATI',
      latitude: -13.5400,
      longitude: -71.9510,
      type: UniversityType.institute,
      studentCount: 3500,
    ),
    University(
      id: 'sencico',
      name: 'SENCO - Servicio Nacional de Capacitación',
      shortName: 'SENCO',
      latitude: -13.5190,
      longitude: -71.9430,
      type: UniversityType.institute,
      studentCount: 1800,
    ),
  ];

  // ── Distritos del Cusco ──
  static const List<District> districts = [
    District(
      id: 'cusco',
      name: 'Cusco',
      description: 'Centro histórico y zona universitaria principal',
      latitude: -13.5319,
      longitude: -71.9675,
      type: DistrictType.urban,
      priceLevel: PriceLevel.high,
      avgRent: 900,
      walkingToUnsaac: 15,
    ),
    District(
      id: 'san-sebastian',
      name: 'San Sebastián',
      description: 'Zona residencial cerca a la UNSAAC',
      latitude: -13.5450,
      longitude: -71.9680,
      type: DistrictType.residential,
      priceLevel: PriceLevel.medium,
      avgRent: 650,
      walkingToUnsaac: 25,
    ),
    District(
      id: 'san-jeronimo',
      name: 'San Jerónimo',
      description: 'Zona económica con buena conectividad',
      latitude: -13.5580,
      longitude: -71.9620,
      type: DistrictType.residential,
      priceLevel: PriceLevel.low,
      avgRent: 450,
      walkingToUnsaac: 40,
    ),
    District(
      id: 'wanchaq',
      name: 'Wanchaq',
      description: 'Distrito comercial bien conectado',
      latitude: -13.5220,
      longitude: -71.9710,
      type: DistrictType.urban,
      priceLevel: PriceLevel.high,
      avgRent: 850,
      walkingToUnsaac: 20,
    ),
    District(
      id: 'santiago',
      name: 'Santiago',
      description: 'Zona tradicional con mercados y transporte',
      latitude: -13.5370,
      longitude: -71.9550,
      type: DistrictType.mixed,
      priceLevel: PriceLevel.medium,
      avgRent: 600,
      walkingToUnsaac: 30,
    ),
    District(
      id: 'poroy',
      name: 'Poroy',
      description: 'Zona tranquila en las alturas del Cusco',
      latitude: -13.5050,
      longitude: -72.0050,
      type: DistrictType.suburban,
      priceLevel: PriceLevel.low,
      avgRent: 380,
      walkingToUnsaac: 60,
    ),
    District(
      id: 'saylla',
      name: 'Saylla',
      description: 'Pueblo tradicional con platos típicos',
      latitude: -13.5700,
      longitude: -71.8700,
      type: DistrictType.rural,
      priceLevel: PriceLevel.veryLow,
      avgRent: 280,
      walkingToUnsaac: 90,
    ),
    District(
      id: 'ccorca',
      name: 'Ccorca',
      description: 'Comunidad rural cerca a ruinas arqueológicas',
      latitude: -13.5500,
      longitude: -72.0300,
      type: DistrictType.rural,
      priceLevel: PriceLevel.veryLow,
      avgRent: 250,
      walkingToUnsaac: 120,
    ),
    District(
      id: 'san- Salvador',
      name: 'San Salvador',
      description: 'Zona en crecimiento con nuevas residencias',
      latitude: -13.5900,
      longitude: -71.9200,
      type: DistrictType.suburban,
      priceLevel: PriceLevel.low,
      avgRent: 400,
      walkingToUnsaac: 50,
    ),
  ];

  // ── Amenidades ──
  static const List<Amenity> amenities = [
    Amenity(id: 'wifi', label: 'WiFi', icon: Icons.wifi, category: AmenityCategory.connectivity),
    Amenity(id: 'hot_water', label: 'Agua caliente', icon: Icons.hot_tub, category: AmenityCategory.comfort),
    Amenity(id: 'kitchen', label: 'Cocina', icon: Icons.kitchen, category: AmenityCategory.comfort),
    Amenity(id: 'laundry', label: 'Lavandería', icon: Icons.local_laundry_service, category: AmenityCategory.comfort),
    Amenity(id: 'parking', label: 'Estacionamiento', icon: Icons.local_parking, category: AmenityCategory.services),
    Amenity(id: 'study_room', label: 'Sala de estudio', icon: Icons.menu_book, category: AmenityCategory.academic),
    Amenity(id: 'gym', label: 'Gimnasio', icon: Icons.fitness_center, category: AmenityCategory.wellness),
    Amenity(id: 'cctv', label: 'Seguridad 24h', icon: Icons.videocam, category: AmenityCategory.safety),
    Amenity(id: 'heating', label: 'Calefacción', icon: Icons.thermostat, category: AmenityCategory.comfort),
    Amenity(id: 'garden', label: 'Jardín/Patio', icon: Icons.yard, category: AmenityCategory.outdoor),
    Amenity(id: 'common_room', label: 'Sala común', icon: Icons.weekend, category: AmenityCategory.social),
    Amenity(id: 'private_bath', label: 'Baño privado', icon: Icons.bathtub, category: AmenityCategory.comfort),
    Amenity(id: 'balcony', label: 'Balcón', icon: Icons.balcony, category: AmenityCategory.outdoor),
    Amenity(id: 'elevator', label: 'Ascensor', icon: Icons.elevator, category: AmenityCategory.accessibility),
    Amenity(id: 'pet_friendly', label: 'Acepta mascotas', icon: Icons.pets, category: AmenityCategory.lifestyle),
    Amenity(id: 'meal_included', label: 'Comidas incluidas', icon: Icons.restaurant, category: AmenityCategory.services),
    Amenity(id: 'cleaning', label: 'Limpieza incluida', icon: Icons.cleaning_services, category: AmenityCategory.services),
    Amenity(id: 'printer', label: 'Impresora', icon: Icons.print, category: AmenityCategory.academic),
  ];

  // ── Tags de estilo de vida ──
  static const List<LifestyleTag> lifestyleTags = [
    LifestyleTag(id: 'quiet', label: 'Tranquilo', emoji: '🤫', category: TagCategory.atmosphere),
    LifestyleTag(id: 'social', label: 'Social', emoji: '🎉', category: TagCategory.atmosphere),
    LifestyleTag(id: 'study_focused', label: 'Estudioso', emoji: '📚', category: TagCategory.atmosphere),
    LifestyleTag(id: 'early_bird', label: 'Madrugador', emoji: '🌅', category: TagCategory.habit),
    LifestyleTag(id: 'night_owl', label: 'Noctámbulo', emoji: '🦉', category: TagCategory.habit),
    LifestyleTag(id: 'vegetarian', label: 'Vegetariano', emoji: '🥬', category: TagCategory.diet),
    LifestyleTag(id: 'vegan', label: 'Vegano', emoji: '🌱', category: TagCategory.diet),
    LifestyleTag(id: 'pet_lover', label: 'Amigo de mascotas', emoji: '🐕', category: TagCategory.lifestyle),
    LifestyleTag(id: 'sports', label: 'Deportista', emoji: '⚽', category: TagCategory.lifestyle),
    LifestyleTag(id: 'musician', label: 'Músico', emoji: '🎵', category: TagCategory.lifestyle),
    LifestyleTag(id: 'artist', label: 'Artista', emoji: '🎨', category: TagCategory.lifestyle),
    LifestyleTag(id: 'gamer', label: 'Gamer', emoji: '🎮', category: TagCategory.lifestyle),
    LifestyleTag(id: 'eco_friendly', label: 'Eco-amigable', emoji: '♻️', category: TagCategory.lifestyle),
    LifestyleTag(id: 'international', label: 'Internacional', emoji: '🌍', category: TagCategory.lifestyle),
    LifestyleTag(id: 'catholic', label: 'Creyente', emoji: '⛪', category: TagCategory.lifestyle),
    LifestyleTag(id: 'non_smoker', label: 'No fumador', emoji: '🚭', category: TagCategory.habit),
    LifestyleTag(id: 'tidy', label: 'Ordenado', emoji: '✨', category: TagCategory.habit),
    LifestyleTag(id: 'outgoing', label: 'Extrovertido', emoji: '🤝', category: TagCategory.atmosphere),
  ];

  // ── Tipos de contrato ──
  static const List<ContractType> contractTypes = [
    ContractType(
      id: 'semester',
      label: 'Por semestre',
      description: 'Contrato por semestre académico (5-6 meses)',
      months: 6,
      discountPercent: 10,
    ),
    ContractType(
      id: 'annual',
      label: 'Anual',
      description: 'Contrato por año completo (12 meses)',
      months: 12,
      discountPercent: 15,
    ),
    ContractType(
      id: 'monthly',
      label: 'Mensual',
      description: 'Contrato renovable mes a mes',
      months: 1,
      discountPercent: 0,
    ),
    ContractType(
      id: 'quarterly',
      label: 'Trimestral',
      description: 'Contrato por trimestre (3 meses)',
      months: 3,
      discountPercent: 5,
    ),
    ContractType(
      id: 'short_stay',
      label: 'Estadía corta',
      description: 'Por semanas o días (mínimo 1 semana)',
      months: 0,
      discountPercent: 0,
      isShortStay: true,
    ),
  ];

  // ── Preferencia de género ──
  static const List<GenderPreference> genderPreferences = [
    GenderPreference(id: 'any', label: 'Sin preferencia', icon: Icons.people),
    GenderPreference(id: 'female_only', label: 'Solo mujeres', icon: Icons.female),
    GenderPreference(id: 'male_only', label: 'Solo hombres', icon: Icons.male),
    GenderPreference(id: 'mixed', label: 'Mixto', icon: Icons.groups),
  ];

  // ── Tipos de habitación ──
  static const List<RoomType> roomTypes = [
    RoomType(
      id: 'single',
      label: 'Individual',
      description: 'Habitación privada para 1 persona',
      icon: Icons.person,
      maxOccupancy: 1,
      privacy: RoomPrivacy.private,
    ),
    RoomType(
      id: 'double',
      label: 'Doble',
      description: 'Habitación compartida para 2 personas',
      icon: Icons.people_outline,
      maxOccupancy: 2,
      privacy: RoomPrivacy.semiPrivate,
    ),
    RoomType(
      id: 'suite',
      label: 'Suite',
      description: 'Habitación con baño privado y sala pequeña',
      icon: Icons.star,
      maxOccupancy: 1,
      privacy: RoomPrivacy.private,
      isPremium: true,
    ),
    RoomType(
      id: 'shared_3',
      label: 'Triple',
      description: 'Habitación compartida para 3 personas',
      icon: Icons.groups,
      maxOccupancy: 3,
      privacy: RoomPrivacy.shared,
    ),
    RoomType(
      id: 'shared_4',
      label: 'Cuádruple',
      description: 'Habitación compartida para 4 personas',
      icon: Icons.groups_3,
      maxOccupancy: 4,
      privacy: RoomPrivacy.shared,
    ),
    RoomType(
      id: 'studio',
      label: 'Estudio',
      description: 'Mini-departamento independiente con cocina',
      icon: Icons.apartment,
      maxOccupancy: 2,
      privacy: RoomPrivacy.private,
      isPremium: true,
    ),
  ];

  // ── Niveles de verificación ──
  static const List<VerificationLevel> verificationLevels = [
    VerificationLevel(
      id: 'basic',
      label: 'Verificado',
      description: 'Documento de identidad verificado',
      icon: Icons.verified_user,
      color: Color(0xFF4ECDC4),
      scoreRequired: 0,
    ),
    VerificationLevel(
      id: 'trusted',
      label: 'Confiable',
      description: 'Identidad + visitas presenciales verificadas',
      icon: Icons.shield,
      color: Color(0xFF1A535C),
      scoreRequired: 60,
    ),
    VerificationLevel(
      id: 'premium',
      label: 'Premium',
      description: 'Máxima verificación + garantía WasiStudent',
      icon: Icons.workspace_premium,
      color: Color(0xFFF9A826),
      scoreRequired: 85,
    ),
  ];

  // ── Tipos de notificación ──
  static const List<NotificationType> notificationTypes = [
    NotificationType(id: 'message', label: 'Mensaje', icon: Icons.chat_bubble, color: Color(0xFF1A535C)),
    NotificationType(id: 'booking', label: 'Reserva', icon: Icons.event_available, color: Color(0xFF4ECDC4)),
    NotificationType(id: 'payment', label: 'Pago', icon: Icons.payment, color: Color(0xFFF9A826)),
    NotificationType(id: 'review', label: 'Reseña', icon: Icons.star_rate, color: Color(0xFFFF6B6B)),
    NotificationType(id: 'contract', label: 'Contrato', icon: Icons.description, color: Color(0xFF6C5CE7)),
    NotificationType(id: 'promotion', label: 'Promoción', icon: Icons.local_offer, color: Color(0xFFE17055)),
    NotificationType(id: 'system', label: 'Sistema', icon: Icons.info, color: Color(0xFF636E72)),
    NotificationType(id: 'roommate', label: 'Compañero', icon: Icons.person_add, color: Color(0xFF00B894)),
    NotificationType(id: 'maintenance', label: 'Mantenimiento', icon: Icons.build, color: Color(0xFFD63031)),
    NotificationType(id: 'verification', label: 'Verificación', icon: Icons.verified, color: Color(0xFF0984E3)),
  ];

  // ── Estados de pago ──
  static const List<PaymentStatus> paymentStatuses = [
    PaymentStatus(id: 'pending', label: 'Pendiente', icon: Icons.schedule, color: Color(0xFFF9A826)),
    PaymentStatus(id: 'processing', label: 'Procesando', icon: Icons.sync, color: Color(0xFF0984E3)),
    PaymentStatus(id: 'completed', label: 'Completado', icon: Icons.check_circle, color: Color(0xFF4ECDC4)),
    PaymentStatus(id: 'failed', label: 'Fallido', icon: Icons.error, color: Color(0xFFFF6B6B)),
    PaymentStatus(id: 'refunded', label: 'Reembolsado', icon: Icons.money_off, color: Color(0xFF636E72)),
    PaymentStatus(id: 'overdue', label: 'Vencido', icon: Icons.warning, color: Color(0xFFD63031)),
  ];

  // ── Métodos de pago ──
  static const List<PaymentMethod> paymentMethods = [
    PaymentMethod(id: 'yape', label: 'Yape', icon: Icons.phone_android, isDigital: true),
    PaymentMethod(id: 'plin', label: 'Plin', icon: Icons.phone_android, isDigital: true),
    PaymentMethod(id: 'transfer', label: 'Transferencia bancaria', icon: Icons.account_balance, isDigital: true),
    PaymentMethod(id: 'cash', label: 'Efectivo', icon: Icons.money, isDigital: false),
    PaymentMethod(id: 'card', label: 'Tarjeta', icon: Icons.credit_card, isDigital: true),
  ];

  // ── Paginación ──
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  static const int searchDebounceMs = 300;

  // ── Trust Score ──
  static const int trustScoreMin = 0;
  static const int trustScoreMax = 100;
  static const int trustScoreVerified = 60;
  static const int trustScorePremium = 85;

  // ── Review ──
  static const int reviewMinLength = 20;
  static const int reviewMaxLength = 500;
  static const int reviewMaxPhotos = 5;

  // ── Profile ──
  static const int bioMinLength = 10;
  static const int bioMaxLength = 300;
  static const int maxProfilePhotos = 6;
  static const int usernameMinLength = 3;
  static const int usernameMaxLength = 20;

  // ── Maps ──
  static const double defaultMapZoom = 14.0;
  static const double defaultMapRadiusKm = 3.0;
  static const double minMapZoom = 10.0;
  static const double maxMapZoom = 18.0;
  static const String mapStyleLight = '[]';
  static const String mapStyleDark = '[]';

  // ── Chat ──
  static const int maxMessageLength = 1000;
  static const int chatPageSize = 30;
  static const int maxAttachmentsPerMessage = 3;
  static const int maxAttachmentSizeMB = 10;

  // ── Onboarding ──
  static const int onboardingPages = 4;

  // ── Cache ──
  static const int cacheExpiryHours = 24;
  static const int imageCacheMaxEntries = 200;
  static const int imageCacheMaxSizeMB = 100;

  // ── Animación ──
  static const int shimmerDurationMs = 1500;
  static const int pageTransitionDurationMs = 350;
  static const int splashDurationMs = 2000;
}

// ════════════════════════════════════════════
//  MODELOS DE DATOS PARA CONSTANTES
// ════════════════════════════════════════════

enum UniversityType { public, private, institute }

class University {
  final String id;
  final String name;
  final String shortName;
  final double latitude;
  final double longitude;
  final UniversityType type;
  final int studentCount;

  const University({
    required this.id,
    required this.name,
    required this.shortName,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.studentCount,
  });

  String get typeLabel {
    switch (type) {
      case UniversityType.public:
        return 'Pública';
      case UniversityType.private:
        return 'Privada';
      case UniversityType.institute:
        return 'Instituto';
    }
  }

  String get displayStudentCount {
    if (studentCount >= 1000) {
      return '${(studentCount / 1000).toStringAsFixed(1)}k estudiantes';
    }
    return '$studentCount estudiantes';
  }
}

enum DistrictType { urban, residential, mixed, suburban, rural }
enum PriceLevel { veryLow, low, medium, high, veryHigh }

class District {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final DistrictType type;
  final PriceLevel priceLevel;
  final double avgRent;
  final int walkingToUnsaac;

  const District({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.priceLevel,
    required this.avgRent,
    required this.walkingToUnsaac,
  });

  String get typeLabel {
    switch (type) {
      case DistrictType.urban:
        return 'Urbano';
      case DistrictType.residential:
        return 'Residencial';
      case DistrictType.mixed:
        return 'Mixto';
      case DistrictType.suburban:
        return 'Suburbano';
      case DistrictType.rural:
        return 'Rural';
    }
  }

  String get priceLevelLabel {
    switch (priceLevel) {
      case PriceLevel.veryLow:
        return 'Muy económico';
      case PriceLevel.low:
        return 'Económico';
      case PriceLevel.medium:
        return 'Moderado';
      case PriceLevel.high:
        return 'Alto';
      case PriceLevel.veryHigh:
        return 'Muy alto';
    }
  }

  String get priceEmoji {
    switch (priceLevel) {
      case PriceLevel.veryLow:
        return '💰';
      case PriceLevel.low:
        return '🪙';
      case PriceLevel.medium:
        return '💸';
      case PriceLevel.high:
        return '💎';
      case PriceLevel.veryHigh:
        return '👑';
    }
  }
}

enum AmenityCategory { connectivity, comfort, services, academic, wellness, safety, outdoor, social, accessibility, lifestyle }

class Amenity {
  final String id;
  final String label;
  final IconData icon;
  final AmenityCategory category;

  const Amenity({
    required this.id,
    required this.label,
    required this.icon,
    required this.category,
  });

  String get categoryLabel {
    switch (category) {
      case AmenityCategory.connectivity:
        return 'Conectividad';
      case AmenityCategory.comfort:
        return 'Comodidad';
      case AmenityCategory.services:
        return 'Servicios';
      case AmenityCategory.academic:
        return 'Académico';
      case AmenityCategory.wellness:
        return 'Bienestar';
      case AmenityCategory.safety:
        return 'Seguridad';
      case AmenityCategory.outdoor:
        return 'Exterior';
      case AmenityCategory.social:
        return 'Social';
      case AmenityCategory.accessibility:
        return 'Accesibilidad';
      case AmenityCategory.lifestyle:
        return 'Estilo de vida';
    }
  }
}

enum TagCategory { atmosphere, habit, diet, lifestyle }

class LifestyleTag {
  final String id;
  final String label;
  final String emoji;
  final TagCategory category;

  const LifestyleTag({
    required this.id,
    required this.label,
    required this.emoji,
    required this.category,
  });

  String get categoryLabel {
    switch (category) {
      case TagCategory.atmosphere:
        return 'Atmósfera';
      case TagCategory.habit:
        return 'Hábitos';
      case TagCategory.diet:
        return 'Dieta';
      case TagCategory.lifestyle:
        return 'Estilo de vida';
    }
  }

  String get displayLabel => '$emoji $label';
}

class ContractType {
  final String id;
  final String label;
  final String description;
  final int months;
  final double discountPercent;
  final bool isShortStay;

  const ContractType({
    required this.id,
    required this.label,
    required this.description,
    required this.months,
    required this.discountPercent,
    this.isShortStay = false,
  });

  String get discountLabel => discountPercent > 0 ? '-${discountPercent.toInt()}%' : '';
}

class GenderPreference {
  final String id;
  final String label;
  final IconData icon;

  const GenderPreference({
    required this.id,
    required this.label,
    required this.icon,
  });
}

enum RoomPrivacy { private, semiPrivate, shared }

class RoomType {
  final String id;
  final String label;
  final String description;
  final IconData icon;
  final int maxOccupancy;
  final RoomPrivacy privacy;
  final bool isPremium;

  const RoomType({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.maxOccupancy,
    required this.privacy,
    this.isPremium = false,
  });

  String get privacyLabel {
    switch (privacy) {
      case RoomPrivacy.private:
        return 'Privada';
      case RoomPrivacy.semiPrivate:
        return 'Semi-privada';
      case RoomPrivacy.shared:
        return 'Compartida';
    }
  }
}

class VerificationLevel {
  final String id;
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final int scoreRequired;

  const VerificationLevel({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.scoreRequired,
  });
}

class NotificationType {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const NotificationType({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class PaymentStatus {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const PaymentStatus({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class PaymentMethod {
  final String id;
  final String label;
  final IconData icon;
  final bool isDigital;

  const PaymentMethod({
    required this.id,
    required this.label,
    required this.icon,
    required this.isDigital,
  });
}
