
/// Preferencias del usuario para buscar habitaciones en WasiStudent.
/// Define filtros, prioridades y estilo de vida del estudiante.

enum GenderPreference { any, male, female }

enum ContractType { monthly, semester, annual, flexible }

enum RoomType { private, shared, studio, any }

class PriorityItem {
  final String id;
  final String label;
  final String icon;
  final int weight; // 1-5
  final String color; // Hex color string

  const PriorityItem({
    required this.id,
    required this.label,
    required this.icon,
    this.weight = 3,
    this.color = '#2196F3',
  });

  PriorityItem copyWith({
    String? id,
    String? label,
    String? icon,
    int? weight,
    String? color,
  }) {
    return PriorityItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      weight: weight ?? this.weight,
      color: color ?? this.color,
    );
  }

  /// Lista de prioridades disponibles por defecto.
  ///
  /// Estas 6 prioridades corresponden 1:1 con las 6 dimensiones del motor
  /// de matching (ver `matching_service.dart`). El usuario puede reordenar
  /// y ajustar pesos (1-5); el sistema normaliza para que sumen 100%.
  ///
  /// Pesos por defecto = propuesta WasiStudent:
  /// - Ubicación 25% → peso 5
  /// - Presupuesto 20% → peso 4
  /// - Hábitos 20% → peso 4
  /// - Servicios 15% → peso 3
  /// - Preferencias 10% → peso 2
  /// - Reputación 10% → peso 2
  ///
  /// Si el usuario NO define prioridades (lista vacía), el motor usa los
  /// pesos internos por defecto. Si define, sus pesos sobrescriben.
  static List<PriorityItem> get defaultPriorities => const [
        PriorityItem(
          id: 'location',
          label: 'Ubicación',
          icon: 'location_on',
          weight: 5,
          color: '#2196F3',
        ),
        PriorityItem(
          id: 'price',
          label: 'Presupuesto',
          icon: 'attach_money',
          weight: 4,
          color: '#4CAF50',
        ),
        PriorityItem(
          id: 'habits',
          label: 'Hábitos de convivencia',
          icon: 'self_improvement',
          weight: 4,
          color: '#9C27B0',
        ),
        PriorityItem(
          id: 'amenities',
          label: 'Servicios',
          icon: 'room_service',
          weight: 3,
          color: '#E91E63',
        ),
        PriorityItem(
          id: 'comfort',
          label: 'Preferencias (género, tipo, contrato)',
          icon: 'weekend',
          weight: 2,
          color: '#00BCD4',
        ),
        PriorityItem(
          id: 'trust',
          label: 'Reputación del propietario',
          icon: 'verified_user',
          weight: 2,
          color: '#FF9800',
        ),
      ];
}

class UserPreferences {
  final double minBudget;
  final double maxBudget;
  final double maxDistance; // km
  final int maxWalkingTime; // minutos

  final String university;
  final GenderPreference genderPreference;

  final List<String> requiredAmenities;
  final List<String> lifestyleTags;

  final List<PriorityItem> priorities;

  final bool acceptsCouples;
  final bool acceptsPets;
  final bool acceptsForeigners;

  final ContractType contractType;
  final DateTime? moveInDate;
  final int minContractDuration; // meses

  final RoomType roomType;
  final List<String> preferredDistricts;

  final String? quietHours; // ej. "22:00 - 07:00"
  final bool smokingOK;
  final bool visitorsOK;

  const UserPreferences({
    this.minBudget = 300,
    this.maxBudget = 800,
    this.maxDistance = 3.0,
    this.maxWalkingTime = 30,
    this.university = 'UNSAAC',
    this.genderPreference = GenderPreference.any,
    this.requiredAmenities = const [],
    this.lifestyleTags = const [],
    this.priorities = const [],
    this.acceptsCouples = false,
    this.acceptsPets = false,
    this.acceptsForeigners = true,
    this.contractType = ContractType.semester,
    this.moveInDate,
    this.minContractDuration = 3,
    this.roomType = RoomType.any,
    this.preferredDistricts = const [],
    this.quietHours,
    this.smokingOK = false,
    this.visitorsOK = true,
  });

  // ── Computed Getters ──────────────────────────────────────────────

  String get budgetLabel {
    if (maxBudget <= 0) return 'Sin límite';
    return 'S/ ${minBudget.toStringAsFixed(0)} - S/ ${maxBudget.toStringAsFixed(0)}';
  }

  String get distanceLabel {
    if (maxDistance <= 0) return 'Sin límite';
    return 'Hasta ${maxDistance.toStringAsFixed(1)} km';
  }

  String get walkingTimeLabel {
    if (maxWalkingTime <= 0) return 'Sin límite';
    return 'Hasta $maxWalkingTime min';
  }

  String get contractTypeLabel {
    switch (contractType) {
      case ContractType.monthly:
        return 'Mensual';
      case ContractType.semester:
        return 'Semestral';
      case ContractType.annual:
        return 'Anual';
      case ContractType.flexible:
        return 'Flexible';
    }
  }

  String get roomTypeLabel {
    switch (roomType) {
      case RoomType.private:
        return 'Privada';
      case RoomType.shared:
        return 'Compartida';
      case RoomType.studio:
        return 'Estudio';
      case RoomType.any:
        return 'Cualquiera';
    }
  }

  String get genderPreferenceLabel {
    switch (genderPreference) {
      case GenderPreference.any:
        return 'Sin preferencia';
      case GenderPreference.male:
        return 'Solo hombres';
      case GenderPreference.female:
        return 'Solo mujeres';
    }
  }

  /// Cantidad de filtros activos (no vacíos o no por defecto).
  int get activeFilterCount {
    int count = 0;
    if (maxBudget < 2000) count++;
    if (maxDistance < 10) count++;
    if (maxWalkingTime < 60) count++;
    if (requiredAmenities.isNotEmpty) count++;
    if (lifestyleTags.isNotEmpty) count++;
    if (preferredDistricts.isNotEmpty) count++;
    if (roomType != RoomType.any) count++;
    if (genderPreference != GenderPreference.any) count++;
    if (!smokingOK) count++;
    if (!visitorsOK) count++;
    if (minContractDuration > 1) count++;
    return count;
  }

  // ── copyWith ──────────────────────────────────────────────────────

  UserPreferences copyWith({
    double? minBudget,
    double? maxBudget,
    double? maxDistance,
    int? maxWalkingTime,
    String? university,
    GenderPreference? genderPreference,
    List<String>? requiredAmenities,
    List<String>? lifestyleTags,
    List<PriorityItem>? priorities,
    bool? acceptsCouples,
    bool? acceptsPets,
    bool? acceptsForeigners,
    ContractType? contractType,
    DateTime? moveInDate,
    int? minContractDuration,
    RoomType? roomType,
    List<String>? preferredDistricts,
    String? quietHours,
    bool? smokingOK,
    bool? visitorsOK,
  }) {
    return UserPreferences(
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      maxDistance: maxDistance ?? this.maxDistance,
      maxWalkingTime: maxWalkingTime ?? this.maxWalkingTime,
      university: university ?? this.university,
      genderPreference: genderPreference ?? this.genderPreference,
      requiredAmenities: requiredAmenities ?? this.requiredAmenities,
      lifestyleTags: lifestyleTags ?? this.lifestyleTags,
      priorities: priorities ?? this.priorities,
      acceptsCouples: acceptsCouples ?? this.acceptsCouples,
      acceptsPets: acceptsPets ?? this.acceptsPets,
      acceptsForeigners: acceptsForeigners ?? this.acceptsForeigners,
      contractType: contractType ?? this.contractType,
      moveInDate: moveInDate ?? this.moveInDate,
      minContractDuration: minContractDuration ?? this.minContractDuration,
      roomType: roomType ?? this.roomType,
      preferredDistricts: preferredDistricts ?? this.preferredDistricts,
      quietHours: quietHours ?? this.quietHours,
      smokingOK: smokingOK ?? this.smokingOK,
      visitorsOK: visitorsOK ?? this.visitorsOK,
    );
  }

  // ── Reset to defaults ─────────────────────────────────────────────

  UserPreferences resetToDefaults() {
    return const UserPreferences();
  }

  // ── Mock Data ─────────────────────────────────────────────────────

  static UserPreferences getMockPreferences() {
    return UserPreferences(
      minBudget: 200,
      maxBudget: 500,
      maxDistance: 3.0,
      maxWalkingTime: 25,
      university: 'UNSAAC',
      genderPreference: GenderPreference.female,
      requiredAmenities: ['Wi-Fi', 'Agua caliente', 'Cocina'],
      lifestyleTags: ['Tranquila', 'Organizada', 'Estudiosa'],
      priorities: [
        const PriorityItem(
          id: 'location',
          label: 'Ubicación',
          icon: 'location_on',
          weight: 5,
          color: '#2196F3',
        ),
        const PriorityItem(
          id: 'price',
          label: 'Presupuesto',
          icon: 'attach_money',
          weight: 4,
          color: '#4CAF50',
        ),
        const PriorityItem(
          id: 'habits',
          label: 'Hábitos de convivencia',
          icon: 'self_improvement',
          weight: 4,
          color: '#9C27B0',
        ),
        const PriorityItem(
          id: 'amenities',
          label: 'Servicios',
          icon: 'room_service',
          weight: 3,
          color: '#E91E63',
        ),
        const PriorityItem(
          id: 'comfort',
          label: 'Preferencias (género, tipo, contrato)',
          icon: 'weekend',
          weight: 2,
          color: '#00BCD4',
        ),
        const PriorityItem(
          id: 'trust',
          label: 'Reputación del propietario',
          icon: 'verified_user',
          weight: 2,
          color: '#FF9800',
        ),
      ],
      acceptsCouples: false,
      acceptsPets: false,
      acceptsForeigners: true,
      contractType: ContractType.semester,
      moveInDate: DateTime(2025, 4, 1),
      minContractDuration: 5,
      roomType: RoomType.private,
      preferredDistricts: ['San Jerónimo', 'San Sebastián', 'Santiago'],
      quietHours: '22:00 - 07:00',
      smokingOK: false,
      visitorsOK: true,
    );
  }
}
