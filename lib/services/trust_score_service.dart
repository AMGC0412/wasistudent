import '../models/trust_score.dart';

/// Servicio de puntuación de confianza para WasiStudent.
/// Calcula, evalúa y recomienda acciones para mejorar la confianza
/// de propietarios y estudiantes en la plataforma.
///
/// El puntaje de confianza es la pieza central de la seguridad en WasiStudent.
/// Se compone de **4 dimensiones** alineadas con la propuesta de valor:
///
/// - Identidad verificada (30%)
/// - Contratos cumplidos (30%)
/// - Reseñas recibidas (25%)
/// - Antigüedad en la plataforma (15%)
///
/// Nota: la versión anterior incluía "Capacidad de respuesta" (10%) como
/// quinta dimensión. Se elimina para alinear el motor con la fórmula
/// publicada en el documento de propuesta (junio 2026). La capacidad de
/// respuesta se puede seguir mostrando como métrica informativa en la UI
/// pero no aporta al puntaje.
class TrustScoreService {
  // ── Pesos de cada dimensión (alineados con la propuesta WasiStudent) ──
  static const double _identityWeight = 0.30;
  static const double _contractsWeight = 0.30;
  static const double _reviewsWeight = 0.25;
  static const double _tenureWeight = 0.15;

  // ── Umbrales de nivel ──────────────────────────────────────────────
  static const int _excelenteThreshold = 90;
  static const int _buenoThreshold = 70;
  static const int _intermedioThreshold = 50;
  static const int _basicoThreshold = 25;

  // ── Hitos (milestones) de confianza ────────────────────────────────
  static const List<int> _milestones = [10, 25, 50, 70, 90, 100];

  // ── Cálculo del puntaje ────────────────────────────────────────────

  /// Calcula el puntaje de confianza a partir de los parámetros individuales.
  ///
  /// Parámetros:
  /// - [identityScore] (0-100): Verificación de identidad (DNI, carnet
  ///   universitario, selfie).
  /// - [contractsFulfilledScore] (0-100): Porcentaje de contratos
  ///   completados exitosamente.
  /// - [ownerReviewsScore] (0-100): Promedio normalizado de reseñas
  ///   recibidas de contrapartes.
  /// - [tenureScore] (0-100): Antigüedad en la plataforma (meses activos).
  ///
  /// Retorna el puntaje ponderado entre 0 y 100.
  double calculate({
    required double identityScore,
    required double contractsFulfilledScore,
    required double ownerReviewsScore,
    required double tenureScore,
  }) {
    final raw = (identityScore * _identityWeight) +
        (contractsFulfilledScore * _contractsWeight) +
        (ownerReviewsScore * _reviewsWeight) +
        (tenureScore * _tenureWeight);

    return raw.clamp(0.0, 100.0);
  }

  /// Calcula el puntaje de confianza a partir de un [TrustScoreModel] existente.
  double calculateFromModel(TrustScoreModel model) {
    return calculate(
      identityScore: model.identityScore.toDouble(),
      contractsFulfilledScore: model.contractsFulfilledScore.toDouble(),
      ownerReviewsScore: model.ownerReviewsScore.toDouble(),
      tenureScore: model.tenureScore.toDouble(),
    );
  }

  // ── Nivel de confianza ─────────────────────────────────────────────

  /// Retorna el nombre del nivel de confianza según el puntaje.
  String calculateLevel(double score) {
    if (score >= _excelenteThreshold) return 'Excelente';
    if (score >= _buenoThreshold) return 'Bueno';
    if (score >= _intermedioThreshold) return 'Intermedio';
    if (score >= _basicoThreshold) return 'Básico';
    return 'Inicial';
  }

  /// Retorna la descripción detallada del nivel.
  String getLevelDescription(double score) {
    if (score >= _excelenteThreshold) {
      return 'Usuario altamente confiable con historial excepcional. '
          'Identidad plenamente verificada y contratos cumplidos sin fallas.';
    }
    if (score >= _buenoThreshold) {
      return 'Usuario confiable con buen historial en la plataforma. '
          'Pocas áreas de mejora pendientes.';
    }
    if (score >= _intermedioThreshold) {
      return 'Usuario con historial moderado. Ha completado algunos contratos '
          'pero aún puede mejorar en varias dimensiones.';
    }
    if (score >= _basicoThreshold) {
      return 'Usuario con perfil básico. Ha dado los primeros pasos en la '
          'plataforma pero necesita verificar más información.';
    }
    return 'Usuario nuevo en la plataforma. Aún no tiene suficiente actividad '
        'para evaluar su confianza.';
  }

  // ── Próximo hito ───────────────────────────────────────────────────

  /// Retorna información sobre el próximo hito de confianza.
  ///
  /// Retorna un Map con:
  /// - 'milestone': el puntaje del próximo hito
  /// - 'pointsNeeded': puntos faltantes para alcanzar el hito
  /// - 'whatToImprove': descripción de la dimensión con mayor potencial de mejora
  Map<String, dynamic> getNextMilestone(double score) {
    int? nextMilestone;
    for (final m in _milestones) {
      if (score < m) {
        nextMilestone = m;
        break;
      }
    }

    if (nextMilestone == null) {
      return {
        'milestone': 100,
        'pointsNeeded': 0,
        'whatToImprove': '¡Ya alcanzaste el nivel máximo de confianza! '
            'Sigue manteniendo tu excelente reputación.',
      };
    }

    final pointsNeeded = (nextMilestone - score).ceil();

    return {
      'milestone': nextMilestone,
      'pointsNeeded': pointsNeeded,
      'whatToImprove': _getBiggestImprovementOpportunity(score),
    };
  }

  /// Identifica la dimensión con mayor oportunidad de mejora.
  String _getBiggestImprovementOpportunity(double score) {
    if (score < 25) {
      return 'Verifica tu identidad con tu DNI para desbloquear '
          'el primer nivel de confianza.';
    }
    if (score < 50) {
      return 'Completa tu primer contrato exitosamente y pide reseñas '
          'a tu propietario para subir tu puntaje.';
    }
    if (score < 70) {
      return 'Responde los mensajes más rápido y mantén un buen historial '
          'de contratos para alcanzar el nivel Bueno.';
    }
    if (score < 90) {
      return 'Mantén tu récord perfecto de contratos y acumula más reseñas '
          'positivas para alcanzar el nivel Excelente.';
    }
    return 'Sigue manteniendo tu excelente reputación en la plataforma.';
  }

  // ── Recomendaciones ────────────────────────────────────────────────

  /// Genera una lista de recomendaciones accionables en español
  /// para mejorar el puntaje de confianza.
  List<String> getRecommendations(TrustScoreModel score) {
    final recommendations = <String>[];

    // Identidad
    if (score.identityScore < 100) {
      if (score.identityScore < 50) {
        recommendations.add(
          'Verifica tu identidad subiendo una foto de tu DNI y un selfie. '
          'Esto es lo más importante para ganar confianza.',
        );
      } else {
        recommendations.add(
          'Completa la verificación avanzada de identidad para alcanzar '
          'el puntaje máximo en esta dimensión.',
        );
      }
    }

    // Contratos cumplidos
    if (score.contractsFulfilledScore < 100) {
      if (score.totalContracts == 0) {
        recommendations.add(
          'Aún no tienes contratos. Busca una habitación y completa tu '
          'primer alquiler para empezar a construir tu historial.',
        );
      } else if (score.completedContracts < score.totalContracts) {
        recommendations.add(
          'Tienes ${score.totalContracts - score.completedContracts} contrato(s) '
          'sin completar. Cumple tus compromisos para mejorar tu puntaje.',
        );
      } else {
        recommendations.add(
          '¡Bien! Has completado todos tus contratos. Sigue así para '
          'mantener tu puntaje alto.',
        );
      }
    }

    // Reseñas
    if (score.ownerReviewsScore < 80) {
      if (score.reviewsReceived == 0) {
        recommendations.add(
          'No tienes reseñas aún. Pide a tu propietario que te califique '
          'al finalizar tu contrato.',
        );
      } else if (score.reviewsReceived < 5) {
        recommendations.add(
          'Tienes ${score.reviewsReceived} reseña(s). Pide más calificaciones '
          'a propietarios anteriores para fortalecer tu perfil.',
        );
      } else {
        recommendations.add(
          'Tienes buena cantidad de reseñas. Asegúrate de mantener '
          'una comunicación excelente para recibir calificaciones positivas.',
        );
      }
    }

    // Antigüedad
    if (score.tenureScore < 80) {
      final months = score.monthsAsMember;
      if (months < 3) {
        recommendations.add(
          'Eres miembro reciente ($months mes(es)). La antigüedad se gana '
          'con el tiempo; sigue activo en la plataforma.',
        );
      } else if (months < 12) {
        recommendations.add(
          'Llevas $months meses en WasiStudent. En unos meses más alcanzarás '
          'la insignia de miembro por 1 año.',
        );
      } else {
        recommendations.add(
          'Tu antigüedad está bien, pero puedes mejorar participando '
          'más activamente en la comunidad.',
        );
      }
    }

    // Si todo está bien
    if (recommendations.isEmpty) {
      recommendations.add(
        '¡Felicidades! Tu perfil de confianza es excelente. '
        'Sigue manteniendo tu buen historial en la plataforma.',
      );
    }

    // Limitar a 5 recomendaciones
    return recommendations.take(5).toList();
  }

  // ── Análisis de dimensiones ────────────────────────────────────────

  /// Retorna la dimensión más fuerte del perfil de confianza.
  String getStrongestDimension(TrustScoreModel score) {
    final dimensions = {
      'Identidad verificada': score.identityScore,
      'Contratos cumplidos': score.contractsFulfilledScore,
      'Reseñas recibidas': score.ownerReviewsScore,
      'Antigüedad': score.tenureScore,
    };

    var maxEntry = dimensions.entries.first;
    for (final entry in dimensions.entries) {
      if (entry.value > maxEntry.value) {
        maxEntry = entry;
      }
    }

    return maxEntry.key;
  }

  /// Retorna la dimensión más débil del perfil de confianza.
  String getWeakestDimension(TrustScoreModel score) {
    final dimensions = {
      'Identidad verificada': score.identityScore,
      'Contratos cumplidos': score.contractsFulfilledScore,
      'Reseñas recibidas': score.ownerReviewsScore,
      'Antigüedad': score.tenureScore,
    };

    var minEntry = dimensions.entries.first;
    for (final entry in dimensions.entries) {
      if (entry.value < minEntry.value) {
        minEntry = entry;
      }
    }

    return minEntry.key;
  }

  /// Calcula la contribución de cada dimensión al puntaje total.
  Map<String, double> getDimensionContributions(TrustScoreModel score) {
    return {
      'Identidad verificada':
          score.identityScore * _identityWeight,
      'Contratos cumplidos':
          score.contractsFulfilledScore * _contractsWeight,
      'Reseñas recibidas':
          score.ownerReviewsScore * _reviewsWeight,
      'Antigüedad':
          score.tenureScore * _tenureWeight,
    };
  }
}
