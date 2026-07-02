import 'package:flutter/material.dart';

import 'user_preferences.dart' show RoomType, GenderPreference, ContractType;

/// Modelos de habitaciones disponibles para alquiler estudiantil en Cusco.
/// Incluye datos detallados de propiedad, propietario, ubicación y verificación.
///
/// Nota: `RoomType`, `GenderPreference` y `ContractType` están definidos en
/// `user_preferences.dart` (se importan con `show` para evitar duplicación).
/// Aquí solo definimos `VerificationLevel` que es específico del Room.

enum VerificationLevel { none, basic, verified, premium }

class Room {
  final String id;
  final String title;
  final String description;
  final double price;
  final String district;
  final double lat;
  final double lng;

  final List<String> amenities;
  final List<String> imageUrls;

  final int verificationLevel; // 0-3
  final int trustScore; // 0-100

  final String ownerName;
  final String ownerAvatar;
  final double ownerRating;
  final String ownerId;
  final String ownerPhone;
  final DateTime ownerMemberSince;

  final bool isFurnished;
  final bool acceptsCouples;
  final bool acceptsPets;
  final bool acceptsForeigners;

  final GenderPreference genderPreference;
  final int maxOccupants;
  final double sizeSqm;
  final RoomType roomType;

  final int walkingTimeMin;
  final double distanceKm;
  final double matchingScore;

  final List<String> lifestyleTags;
  final ContractType contractType;
  final bool hasDigitalContract;

  final DateTime availableFrom;
  final int reviewCount;
  final int viewCount;
  final int favoriteCount;

  final bool isActive;
  final bool isFeatured;
  final bool isUrgent;

  final double utilitiesCost;
  final double depositAmount;
  final int minContractMonths;

  /// Fecha de creación (para ordenar por más reciente).
  final DateTime createdAt;

  final List<String> houseRules;
  final List<String> nearbyPlaces;

  const Room({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.district,
    required this.lat,
    required this.lng,
    this.amenities = const [],
    this.imageUrls = const [],
    this.verificationLevel = 0,
    this.trustScore = 0,
    required this.ownerName,
    required this.ownerAvatar,
    this.ownerRating = 0.0,
    required this.ownerId,
    required this.ownerPhone,
    required this.ownerMemberSince,
    this.isFurnished = false,
    this.acceptsCouples = false,
    this.acceptsPets = false,
    this.acceptsForeigners = true,
    this.genderPreference = GenderPreference.any,
    this.maxOccupants = 1,
    this.sizeSqm = 0.0,
    this.roomType = RoomType.private,
    this.walkingTimeMin = 0,
    this.distanceKm = 0.0,
    this.matchingScore = 0.0,
    this.lifestyleTags = const [],
    this.contractType = ContractType.monthly,
    this.hasDigitalContract = false,
    required this.availableFrom,
    this.reviewCount = 0,
    this.viewCount = 0,
    this.favoriteCount = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.isUrgent = false,
    this.utilitiesCost = 0.0,
    this.depositAmount = 0.0,
    this.minContractMonths = 1,
    this.createdAt,
    this.houseRules = const [],
    this.nearbyPlaces = const [],
  });

  // ── Computed Getters ──────────────────────────────────────────────

  String get priceFormatted => 'S/ ${price.toStringAsFixed(0)}/mes';

  String get walkingTimeFormatted => '$walkingTimeMin min caminando';

  String get sizeFormatted => '${sizeSqm.toStringAsFixed(0)} m\u00B2';

  String get verificationLabel {
    switch (verificationLevel) {
      case 0:
        return 'Sin verificar';
      case 1:
        return 'Verificación básica';
      case 2:
        return 'Verificado';
      case 3:
        return 'Premium verificado';
      default:
        return 'Desconocido';
    }
  }

  IconData get verificationIcon {
    switch (verificationLevel) {
      case 0:
        return Icons.info_outline;
      case 1:
        return Icons.verified_user_outlined;
      case 2:
        return Icons.verified_user;
      case 3:
        return Icons.workspace_premium;
      default:
        return Icons.help_outline;
    }
  }

  Color get verificationColor {
    switch (verificationLevel) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Map<String, double> get dimensionScores => {
        'Precio': price <= 500
            ? 95
            : price <= 800
                ? 80
                : price <= 1200
                    ? 60
                    : 40,
        'Ubicación': distanceKm <= 1.0
            ? 95
            : distanceKm <= 2.0
                ? 80
                : distanceKm <= 3.5
                    ? 65
                    : 45,
        'Confianza': trustScore.toDouble(),
        'Comodidad': isFurnished ? 85 : 50,
        'Tamaño': sizeSqm >= 18
            ? 90
            : sizeSqm >= 14
                ? 70
                : 50,
      };

  double get pricePerSqm => sizeSqm > 0 ? price / sizeSqm : 0.0;

  String get depositFormatted => 'S/ ${depositAmount.toStringAsFixed(0)}';

  String get utilitiesFormatted =>
      utilitiesCost > 0 ? 'S/ ${utilitiesCost.toStringAsFixed(0)}/mes' : 'Incluidas';

  // ── copyWith ──────────────────────────────────────────────────────

  Room copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? district,
    double? lat,
    double? lng,
    List<String>? amenities,
    List<String>? imageUrls,
    int? verificationLevel,
    int? trustScore,
    String? ownerName,
    String? ownerAvatar,
    double? ownerRating,
    String? ownerId,
    String? ownerPhone,
    DateTime? ownerMemberSince,
    bool? isFurnished,
    bool? acceptsCouples,
    bool? acceptsPets,
    bool? acceptsForeigners,
    GenderPreference? genderPreference,
    int? maxOccupants,
    double? sizeSqm,
    RoomType? roomType,
    int? walkingTimeMin,
    double? distanceKm,
    double? matchingScore,
    List<String>? lifestyleTags,
    ContractType? contractType,
    bool? hasDigitalContract,
    DateTime? availableFrom,
    int? reviewCount,
    int? viewCount,
    int? favoriteCount,
    bool? isActive,
    bool? isFeatured,
    bool? isUrgent,
    double? utilitiesCost,
    double? depositAmount,
    int? minContractMonths,
    DateTime? createdAt,
    List<String>? houseRules,
    List<String>? nearbyPlaces,
  }) {
    return Room(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      district: district ?? this.district,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      amenities: amenities ?? this.amenities,
      imageUrls: imageUrls ?? this.imageUrls,
      verificationLevel: verificationLevel ?? this.verificationLevel,
      trustScore: trustScore ?? this.trustScore,
      ownerName: ownerName ?? this.ownerName,
      ownerAvatar: ownerAvatar ?? this.ownerAvatar,
      ownerRating: ownerRating ?? this.ownerRating,
      ownerId: ownerId ?? this.ownerId,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerMemberSince: ownerMemberSince ?? this.ownerMemberSince,
      isFurnished: isFurnished ?? this.isFurnished,
      acceptsCouples: acceptsCouples ?? this.acceptsCouples,
      acceptsPets: acceptsPets ?? this.acceptsPets,
      acceptsForeigners: acceptsForeigners ?? this.acceptsForeigners,
      genderPreference: genderPreference ?? this.genderPreference,
      maxOccupants: maxOccupants ?? this.maxOccupants,
      sizeSqm: sizeSqm ?? this.sizeSqm,
      roomType: roomType ?? this.roomType,
      walkingTimeMin: walkingTimeMin ?? this.walkingTimeMin,
      distanceKm: distanceKm ?? this.distanceKm,
      matchingScore: matchingScore ?? this.matchingScore,
      lifestyleTags: lifestyleTags ?? this.lifestyleTags,
      contractType: contractType ?? this.contractType,
      hasDigitalContract: hasDigitalContract ?? this.hasDigitalContract,
      availableFrom: availableFrom ?? this.availableFrom,
      reviewCount: reviewCount ?? this.reviewCount,
      viewCount: viewCount ?? this.viewCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      isUrgent: isUrgent ?? this.isUrgent,
      utilitiesCost: utilitiesCost ?? this.utilitiesCost,
      depositAmount: depositAmount ?? this.depositAmount,
      minContractMonths: minContractMonths ?? this.minContractMonths,
      createdAt: createdAt ?? this.createdAt,
      houseRules: houseRules ?? this.houseRules,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
    );
  }

  // ── Serialización (Hive) ──────────────────────────────────────────

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      district: json['district'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      amenities: List<String>.from(json['amenities'] as List? ?? []),
      imageUrls: List<String>.from(json['imageUrls'] as List? ?? []),
      verificationLevel: json['verificationLevel'] as int? ?? 0,
      trustScore: json['trustScore'] as int? ?? 0,
      ownerName: json['ownerName'] as String? ?? '',
      ownerAvatar: json['ownerAvatar'] as String? ?? '',
      ownerRating: (json['ownerRating'] as num?)?.toDouble() ?? 0.0,
      ownerId: json['ownerId'] as String? ?? '',
      ownerPhone: json['ownerPhone'] as String? ?? '',
      ownerMemberSince: json['ownerMemberSince'] != null
          ? DateTime.parse(json['ownerMemberSince'] as String)
          : DateTime.now(),
      isFurnished: json['isFurnished'] as bool? ?? false,
      acceptsCouples: json['acceptsCouples'] as bool? ?? false,
      acceptsPets: json['acceptsPets'] as bool? ?? false,
      acceptsForeigners: json['acceptsForeigners'] as bool? ?? true,
      genderPreference: GenderPreference.values.firstWhere(
        (e) => e.name == json['genderPreference'],
        orElse: () => GenderPreference.any,
      ),
      maxOccupants: json['maxOccupants'] as int? ?? 1,
      sizeSqm: (json['sizeSqm'] as num?)?.toDouble() ?? 0.0,
      roomType: RoomType.values.firstWhere(
        (e) => e.name == json['roomType'],
        orElse: () => RoomType.private,
      ),
      walkingTimeMin: json['walkingTimeMin'] as int? ?? 0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      matchingScore: (json['matchingScore'] as num?)?.toDouble() ?? 0.0,
      lifestyleTags: List<String>.from(json['lifestyleTags'] as List? ?? []),
      contractType: ContractType.values.firstWhere(
        (e) => e.name == json['contractType'],
        orElse: () => ContractType.monthly,
      ),
      hasDigitalContract: json['hasDigitalContract'] as bool? ?? false,
      availableFrom: json['availableFrom'] != null
          ? DateTime.parse(json['availableFrom'] as String)
          : DateTime.now(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? 0,
      favoriteCount: json['favoriteCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isUrgent: json['isUrgent'] as bool? ?? false,
      utilitiesCost: (json['utilitiesCost'] as num?)?.toDouble() ?? 0.0,
      depositAmount: (json['depositAmount'] as num?)?.toDouble() ?? 0.0,
      minContractMonths: json['minContractMonths'] as int? ?? 6,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      houseRules: List<String>.from(json['houseRules'] as List? ?? []),
      nearbyPlaces: List<String>.from(json['nearbyPlaces'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'district': district,
      'lat': lat,
      'lng': lng,
      'amenities': amenities,
      'imageUrls': imageUrls,
      'verificationLevel': verificationLevel,
      'trustScore': trustScore,
      'ownerName': ownerName,
      'ownerAvatar': ownerAvatar,
      'ownerRating': ownerRating,
      'ownerId': ownerId,
      'ownerPhone': ownerPhone,
      'ownerMemberSince': ownerMemberSince.toIso8601String(),
      'isFurnished': isFurnished,
      'acceptsCouples': acceptsCouples,
      'acceptsPets': acceptsPets,
      'acceptsForeigners': acceptsForeigners,
      'genderPreference': genderPreference.name,
      'maxOccupants': maxOccupants,
      'sizeSqm': sizeSqm,
      'roomType': roomType.name,
      'walkingTimeMin': walkingTimeMin,
      'distanceKm': distanceKm,
      'matchingScore': matchingScore,
      'lifestyleTags': lifestyleTags,
      'contractType': contractType.name,
      'hasDigitalContract': hasDigitalContract,
      'availableFrom': availableFrom.toIso8601String(),
      'reviewCount': reviewCount,
      'viewCount': viewCount,
      'favoriteCount': favoriteCount,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'isUrgent': isUrgent,
      'utilitiesCost': utilitiesCost,
      'depositAmount': depositAmount,
      'minContractMonths': minContractMonths,
      'createdAt': createdAt.toIso8601String(),
      'houseRules': houseRules,
      'nearbyPlaces': nearbyPlaces,
    };
  }

  /// Crea un cuarto vacío para uso de propietarias (formulario).
  factory Room.empty({
    required String ownerId,
    required String ownerName,
    required String ownerPhone,
  }) {
    return Room(
      id: '',
      title: '',
      description: '',
      price: 0,
      district: 'San Jerónimo',
      lat: -13.5319,
      lng: -71.9675,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerAvatar: ownerName.isNotEmpty ? ownerName.substring(0, 2).toUpperCase() : 'PR',
      ownerPhone: ownerPhone,
      ownerMemberSince: DateTime.now(),
      availableFrom: DateTime.now().add(const Duration(days: 7)),
      createdAt: DateTime.now(),
      minContractMonths: 6,
      depositAmount: 0,
      hasDigitalContract: true,
      verificationLevel: 1,
      trustScore: 50,
    );
  }
}
