import 'package:flutter/material.dart';

/// Modelo de puntuación de confianza para propietarios y usuarios.
/// El sistema de confianza es la pieza central de WasiStudent para
/// garantizar la seguridad y transparencia en el alquiler estudiantil.

class TrustBadge {
  final String name;
  final String icon; // Nombre del icono Material
  final bool earned;

  const TrustBadge({
    required this.name,
    required this.icon,
    this.earned = false,
  });

  TrustBadge copyWith({
    String? name,
    String? icon,
    bool? earned,
  }) {
    return TrustBadge(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      earned: earned ?? this.earned,
    );
  }
}

class TrustScoreModel {
  final int overallScore; // 0-100
  final int identityScore; // 0-100
  final int contractsFulfilledScore; // 0-100
  final int ownerReviewsScore; // 0-100
  final int tenureScore; // 0-100
  final int responsivenessScore; // 0-100

  final int verificationLevel; // 0-3
  final int totalContracts;
  final int completedContracts;
  final int reviewsReceived;
  final int reviewsGiven;

  final DateTime memberSince;
  final DateTime lastUpdated;

  final List<TrustBadge> badges;

  const TrustScoreModel({
    this.overallScore = 0,
    this.identityScore = 0,
    this.contractsFulfilledScore = 0,
    this.ownerReviewsScore = 0,
    this.tenureScore = 0,
    this.responsivenessScore = 0,
    this.verificationLevel = 0,
    this.totalContracts = 0,
    this.completedContracts = 0,
    this.reviewsReceived = 0,
    this.reviewsGiven = 0,
    required this.memberSince,
    required this.lastUpdated,
    this.badges = const [],
  });

  // ── Level System ──────────────────────────────────────────────────

  /// Devuelve el nombre del nivel actual según el puntaje global.
  String get levelName {
    if (overallScore >= 90) return 'Excelente';
    if (overallScore >= 70) return 'Bueno';
    if (overallScore >= 50) return 'Intermedio';
    if (overallScore >= 25) return 'Básico';
    return 'Inicial';
  }

  /// Puntaje necesario para alcanzar el siguiente nivel.
  int get nextLevelScore {
    if (overallScore >= 90) return 100;
    if (overallScore >= 70) return 90;
    if (overallScore >= 50) return 70;
    if (overallScore >= 25) return 50;
    return 25;
  }

  /// Progreso porcentual hacia el siguiente nivel (0.0 - 1.0).
  double get progressToNextLevel {
    if (overallScore >= 90) return 1.0; // Ya está en el máximo
    int currentThreshold;
    int nextThreshold = nextLevelScore;
    if (overallScore >= 70) {
      currentThreshold = 70;
    } else if (overallScore >= 50) {
      currentThreshold = 50;
    } else if (overallScore >= 25) {
      currentThreshold = 25;
    } else {
      currentThreshold = 0;
    }
    final range = nextThreshold - currentThreshold;
    if (range == 0) return 1.0;
    return (overallScore - currentThreshold) / range;
  }

  // ── Visual Properties ─────────────────────────────────────────────

  Color get levelColor {
    if (overallScore >= 90) return const Color(0xFFFFB300); // Ámbar/dorado
    if (overallScore >= 70) return const Color(0xFF4CAF50); // Verde
    if (overallScore >= 50) return const Color(0xFF2196F3); // Azul
    if (overallScore >= 25) return const Color(0xFFFF9800); // Naranja
    return const Color(0xFF9E9E9E); // Gris
  }

  IconData get levelIcon {
    if (overallScore >= 90) return Icons.workspace_premium;
    if (overallScore >= 70) return Icons.verified;
    if (overallScore >= 50) return Icons.shield;
    if (overallScore >= 25) return Icons.verified_user_outlined;
    return Icons.person_outline;
  }

  /// Desglose legible de las dimensiones que aportan al puntaje global.
  ///
  /// Solo 4 dimensiones (alineadas con la propuesta WasiStudent):
  /// Identidad, Contratos cumplidos, Reseñas y Antigüedad.
  /// `responsivenessScore` se mantiene en el modelo como métrica
  /// informativa pero NO aporta al puntaje, por eso no aparece aquí.
  Map<String, int> get dimensionBreakdown => {
        'Identidad verificada': identityScore,
        'Contratos cumplidos': contractsFulfilledScore,
        'Reseñas recibidas': ownerReviewsScore,
        'Antigüedad': tenureScore,
      };

  /// Porcentaje de contratos completados exitosamente.
  double get contractCompletionRate =>
      totalContracts > 0 ? completedContracts / totalContracts : 0.0;

  /// Años como miembro.
  int get yearsAsMember =>
      DateTime.now().difference(memberSince).inDays ~/ 365;

  /// Meses como miembro.
  int get monthsAsMember =>
      DateTime.now().difference(memberSince).inDays ~/ 30;

  /// Insignias obtenidas (solo las ganadas).
  List<TrustBadge> get earnedBadges =>
      badges.where((b) => b.earned).toList();

  /// Cantidad de insignias ganadas.
  int get earnedBadgeCount => earnedBadges.length;

  // ── copyWith ──────────────────────────────────────────────────────

  TrustScoreModel copyWith({
    int? overallScore,
    int? identityScore,
    int? contractsFulfilledScore,
    int? ownerReviewsScore,
    int? tenureScore,
    int? responsivenessScore,
    int? verificationLevel,
    int? totalContracts,
    int? completedContracts,
    int? reviewsReceived,
    int? reviewsGiven,
    DateTime? memberSince,
    DateTime? lastUpdated,
    List<TrustBadge>? badges,
  }) {
    return TrustScoreModel(
      overallScore: overallScore ?? this.overallScore,
      identityScore: identityScore ?? this.identityScore,
      contractsFulfilledScore:
          contractsFulfilledScore ?? this.contractsFulfilledScore,
      ownerReviewsScore: ownerReviewsScore ?? this.ownerReviewsScore,
      tenureScore: tenureScore ?? this.tenureScore,
      responsivenessScore: responsivenessScore ?? this.responsivenessScore,
      verificationLevel: verificationLevel ?? this.verificationLevel,
      totalContracts: totalContracts ?? this.totalContracts,
      completedContracts: completedContracts ?? this.completedContracts,
      reviewsReceived: reviewsReceived ?? this.reviewsReceived,
      reviewsGiven: reviewsGiven ?? this.reviewsGiven,
      memberSince: memberSince ?? this.memberSince,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      badges: badges ?? this.badges,
    );
  }

  // ── Mock Data ─────────────────────────────────────────────────────

  factory TrustScoreModel.mock() {
    return TrustScoreModel(
      overallScore: 78,
      identityScore: 95,
      contractsFulfilledScore: 85,
      ownerReviewsScore: 72,
      tenureScore: 60,
      responsivenessScore: 80,
      verificationLevel: 2,
      totalContracts: 8,
      completedContracts: 7,
      reviewsReceived: 12,
      reviewsGiven: 5,
      memberSince: DateTime(2024, 3, 10),
      lastUpdated: DateTime.now(),
      badges: [
        const TrustBadge(
          name: 'Identidad verificada',
          icon: 'verified_user',
          earned: true,
        ),
        const TrustBadge(
          name: 'Primer contrato cumplido',
          icon: 'assignment_turned_in',
          earned: true,
        ),
        const TrustBadge(
          name: '5 reseñas positivas',
          icon: 'star',
          earned: true,
        ),
        const TrustBadge(
          name: 'Miembro por 1 año',
          icon: 'calendar_today',
          earned: true,
        ),
        const TrustBadge(
          name: 'Respuesta rápida',
          icon: 'bolt',
          earned: true,
        ),
        const TrustBadge(
          name: '10 contratos cumplidos',
          icon: 'emoji_events',
          earned: false,
        ),
        const TrustBadge(
          name: 'Puntuación perfecta',
          icon: 'diamond',
          earned: false,
        ),
        const TrustBadge(
          name: 'Referencia de universidad',
          icon: 'school',
          earned: false,
        ),
      ],
    );
  }

  /// Datos mock para un propietario con alta confianza.
  factory TrustScoreModel.mockPremium() {
    return TrustScoreModel(
      overallScore: 96,
      identityScore: 100,
      contractsFulfilledScore: 98,
      ownerReviewsScore: 95,
      tenureScore: 90,
      responsivenessScore: 97,
      verificationLevel: 3,
      totalContracts: 24,
      completedContracts: 24,
      reviewsReceived: 38,
      reviewsGiven: 0,
      memberSince: DateTime(2019, 5, 10),
      lastUpdated: DateTime.now(),
      badges: [
        const TrustBadge(
          name: 'Identidad verificada',
          icon: 'verified_user',
          earned: true,
        ),
        const TrustBadge(
          name: 'Primer contrato cumplido',
          icon: 'assignment_turned_in',
          earned: true,
        ),
        const TrustBadge(
          name: '5 reseñas positivas',
          icon: 'star',
          earned: true,
        ),
        const TrustBadge(
          name: 'Miembro por 1 año',
          icon: 'calendar_today',
          earned: true,
        ),
        const TrustBadge(
          name: 'Respuesta rápida',
          icon: 'bolt',
          earned: true,
        ),
        const TrustBadge(
          name: '10 contratos cumplidos',
          icon: 'emoji_events',
          earned: true,
        ),
        const TrustBadge(
          name: 'Puntuación perfecta',
          icon: 'diamond',
          earned: true,
        ),
        const TrustBadge(
          name: 'Referencia de universidad',
          icon: 'school',
          earned: true,
        ),
      ],
    );
  }

  /// Datos mock para un usuario nuevo.
  factory TrustScoreModel.mockNewUser() {
    return TrustScoreModel(
      overallScore: 15,
      identityScore: 30,
      contractsFulfilledScore: 0,
      ownerReviewsScore: 0,
      tenureScore: 10,
      responsivenessScore: 20,
      verificationLevel: 0,
      totalContracts: 0,
      completedContracts: 0,
      reviewsReceived: 0,
      reviewsGiven: 0,
      memberSince: DateTime(2025, 2, 28),
      lastUpdated: DateTime.now(),
      badges: [
        const TrustBadge(
          name: 'Identidad verificada',
          icon: 'verified_user',
          earned: false,
        ),
        const TrustBadge(
          name: 'Primer contrato cumplido',
          icon: 'assignment_turned_in',
          earned: false,
        ),
        const TrustBadge(
          name: '5 reseñas positivas',
          icon: 'star',
          earned: false,
        ),
        const TrustBadge(
          name: 'Miembro por 1 año',
          icon: 'calendar_today',
          earned: false,
        ),
        const TrustBadge(
          name: 'Respuesta rápida',
          icon: 'bolt',
          earned: false,
        ),
        const TrustBadge(
          name: '10 contratos cumplidos',
          icon: 'emoji_events',
          earned: false,
        ),
        const TrustBadge(
          name: 'Puntuación perfecta',
          icon: 'diamond',
          earned: false,
        ),
        const TrustBadge(
          name: 'Referencia de universidad',
          icon: 'school',
          earned: false,
        ),
      ],
    );
  }
}
