import 'dart:math';

import '../models/room.dart';
import '../models/user_preferences.dart';
import '../models/roommate_profile.dart';

/// Servicio de matching para WasiStudent.
///
/// Calcula la compatibilidad (0-100) entre una habitación y las preferencias
/// del usuario usando **6 dimensiones alineadas con la propuesta de valor**:
///
/// 1. **Ubicación** (default 25%): distancia peatonal real al campus + tiempo
///    de caminata + distrito preferido.
/// 2. **Presupuesto** (default 20%): ajuste entre presupuesto máximo del
///    estudiante y precio verificado del cuarto.
/// 3. **Hábitos** (default 20%): compatibilidad de convivencia — horarios,
///    limpieza, fumar, mascotas, visitas + tags de estilo de vida.
/// 4. **Servicios** (default 15%): cobertura de servicios requeridos vs.
///    ofrecidos, ponderando indispensables y complementarios.
/// 5. **Preferencias** (default 10%): tipo de cuarto, género, parejas,
///    extranjeros, accesibilidad, tipo y duración de contrato.
/// 6. **Reputación** (default 10%): calificación promedio del propietario
///    por estudiantes anteriores + nivel de verificación.
///
/// ### Pesos balanceados por defecto
///
/// Los pesos por defecto están pensados para un estudiante promedio de
/// UNSAAC: prioriza ubicación (cercanía al campus es crítico en Cusco por
/// la altitud y la topografía), luego presupuesto, luego hábitos.
///
/// ### Edición por usuario
///
/// El usuario puede ajustar los pesos desde `PreferencesScreen` → pestaña
/// "Prioridades". Allí puede:
/// - Reordenar las 6 dimensiones (drag & drop).
/// - Asignar peso 1-5 a cada dimensión.
/// - El sistema normaliza automáticamente para que sumen 100%.
///
/// Si el usuario no configura nada, se usan los pesos balanceados por
/// defecto. Si configura algunas dimensiones pero no todas, las no
/// configuradas reciben peso mínimo (1.0) para garantizar que todas
/// participen en el cálculo.
class MatchingService {
  // ── Pesos por defecto (alineados con propuesta WasiStudent) ────────
  static const double _defaultLocationWeight = 0.25;
  static const double _defaultBudgetWeight = 0.20;
  static const double _defaultHabitsWeight = 0.20;
  static const double _defaultServicesWeight = 0.15;
  static const double _defaultPreferencesWeight = 0.10;
  static const double _defaultReputationWeight = 0.10;

  /// Pesos por defecto expuestos para UI y debugging.
  static Map<String, double> get defaultWeights => const {
        'location': _defaultLocationWeight,
        'budget': _defaultBudgetWeight,
        'habits': _defaultHabitsWeight,
        'services': _defaultServicesWeight,
        'preferences': _defaultPreferencesWeight,
        'reputation': _defaultReputationWeight,
      };

  // ── Cálculo del puntaje general (0-100) ────────────────────────────

  /// Calcula el puntaje de compatibilidad entre [room] y [prefs].
  double calculateScore(Room room, UserPreferences prefs) {
    final weights = _resolveWeights(prefs);

    final location = _locationScore(room, prefs);
    final budget = _budgetScore(room, prefs);
    final habits = _habitsScore(room, prefs);
    final services = _servicesScore(room, prefs);
    final preferences = _preferencesScore(room, prefs);
    final reputation = _reputationScore(room, prefs);

    final rawScore = (location * weights['location']!) +
        (budget * weights['budget']!) +
        (habits * weights['habits']!) +
        (services * weights['services']!) +
        (preferences * weights['preferences']!) +
        (reputation * weights['reputation']!);

    return rawScore.clamp(0.0, 100.0);
  }

  // ── Puntajes individuales por dimensión ────────────────────────────

  /// **Ubicación** (0-100).
  /// Considera distancia peatonal real, tiempo de caminata y distrito
  /// preferido. En Cusco, la altitud (3,400 msnm) hace que 30 min de
  /// caminata cuesta arriba sean mucho más exigentes que al nivel del mar,
  /// por eso penalizamos fuerte las distancias largas.
  double _locationScore(Room room, UserPreferences prefs) {
    double score = 100.0;

    if (room.distanceKm > 0 && prefs.maxDistance > 0) {
      if (room.distanceKm <= prefs.maxDistance) {
        score = 100 - (room.distanceKm / prefs.maxDistance) * 25;
      } else {
        final overRatio =
            (room.distanceKm - prefs.maxDistance) / prefs.maxDistance;
        score = (75 - 50 * overRatio).clamp(0.0, 75.0);
      }
    }

    if (room.walkingTimeMin > 0 && prefs.maxWalkingTime > 0) {
      if (room.walkingTimeMin > prefs.maxWalkingTime) {
        final overRatio = (room.walkingTimeMin - prefs.maxWalkingTime) /
            prefs.maxWalkingTime;
        score = min(score, (75 - 40 * overRatio).clamp(0.0, 75.0));
      }
    }

    if (prefs.preferredDistricts.isNotEmpty &&
        prefs.preferredDistricts.contains(room.district)) {
      score = min(score + 10, 100.0);
    }

    return score.clamp(0.0, 100.0);
  }

  /// **Presupuesto** (0-100).
  /// Mayor puntaje si el cuarto está dentro del rango ideal (mitad baja
  /// del presupuesto del usuario). Penaliza cuartos fuera del rango.
  double _budgetScore(Room room, UserPreferences prefs) {
    if (prefs.maxBudget <= 0) return 80.0;

    if (room.price > prefs.maxBudget) {
      final overRatio = (room.price - prefs.maxBudget) / prefs.maxBudget;
      return (80 * (1 - overRatio.clamp(0.0, 1.0))).clamp(0.0, 80.0);
    }

    if (room.price < prefs.minBudget) {
      final underRatio = (prefs.minBudget - room.price) / prefs.minBudget;
      return (100 - 15 * underRatio).clamp(70.0, 100.0);
    }

    final range = prefs.maxBudget - prefs.minBudget;
    if (range <= 0) return 95.0;
    final position = (room.price - prefs.minBudget) / range;
    return (100 - 10 * position).clamp(85.0, 100.0);
  }

  /// **Hábitos** (0-100).
  /// Compatibilidad de convivencia: horarios, limpieza, fumar, mascotas,
  /// visitas. Incluye los tags de estilo de vida del cuarto vs. los del
  /// usuario (que en la propuesta del documento se llaman "hábitos").
  double _habitsScore(Room room, UserPreferences prefs) {
    double score = 100.0;

    // Quiet hours alignment
    if (prefs.quietHours != null && room.houseRules.isNotEmpty) {
      final hasQuietRule = room.houseRules.any(
        (r) => r.toLowerCase().contains('silencio') ||
            r.toLowerCase().contains('quiet') ||
            r.toLowerCase().contains('descanso'),
      );
      if (hasQuietRule) {
        score = min(score + 5, 100.0);
      }
    }

    // Smoking alignment
    if (prefs.smokingOK && !room.houseRules.any(
      (r) => r.toLowerCase().contains('fumar') &&
          r.toLowerCase().contains('prohibido'),
    )) {
      score = min(score + 5, 100.0);
    } else if (!prefs.smokingOK && room.houseRules.any(
      (r) => r.toLowerCase().contains('fumar'),
    )) {
      score -= 15;
    }

    // Visitors alignment
    if (!prefs.visitorsOK && room.houseRules.any(
      (r) => r.toLowerCase().contains('visitas'),
    )) {
      score -= 10;
    }

    // Lifestyle tags matching
    if (prefs.lifestyleTags.isNotEmpty && room.lifestyleTags.isNotEmpty) {
      int matched = 0;
      for (final tag in prefs.lifestyleTags) {
        if (room.lifestyleTags
            .any((lt) => lt.toLowerCase().contains(tag.toLowerCase()))) {
          matched++;
        }
      }
      final matchRatio = matched / prefs.lifestyleTags.length;
      score = (score * 0.6) + ((30 + matchRatio * 70) * 0.4);
    }

    return score.clamp(0.0, 100.0);
  }

  /// **Servicios** (0-100).
  /// Compara amenidades requeridas vs. ofrecidas. Da bonus por
  /// amenidades extras hasta 100. Las amenidades indispensables (agua,
  /// electricidad, baño) están garantizadas por la verificación en
  /// persona — no se computan aquí, solo las complementarias.
  double _servicesScore(Room room, UserPreferences prefs) {
    if (prefs.requiredAmenities.isEmpty) {
      return (min(room.amenities.length, 10) / 10 * 100).clamp(50.0, 100.0);
    }

    final required = prefs.requiredAmenities;
    final available = room.amenities;

    int matched = 0;
    for (final req in required) {
      if (available.any((a) => a.toLowerCase().contains(req.toLowerCase()))) {
        matched++;
      }
    }

    final matchRatio = matched / required.length;
    final extraBonus = (available.length - matched).clamp(0, 5) * 2.0;

    return (matchRatio * 90 + extraBonus).clamp(0.0, 100.0);
  }

  /// **Preferencias** (0-100).
  /// Tipo de cuarto, género, parejas, extranjeros, accesibilidad, tipo
  /// y duración de contrato. Esta dimensión fusiona lo que el código
  /// anterior llamaba "compatibility" + "contract".
  double _preferencesScore(Room room, UserPreferences prefs) {
    double score = 100.0;

    // Tipo de habitación
    if (prefs.roomType != RoomType.any) {
      if (!_roomTypeMatches(room.roomType, prefs.roomType)) {
        score -= 30;
      }
    }

    // Preferencia de género
    if (room.genderPreference != GenderPreference.any &&
        prefs.genderPreference != GenderPreference.any) {
      if (room.genderPreference != prefs.genderPreference &&
          room.genderPreference != GenderPreference.any) {
        score -= 40;
      }
    }

    // Mascotas
    if (prefs.acceptsPets && !room.acceptsPets) {
      score -= 15;
    }

    // Parejas
    if (prefs.acceptsCouples && !room.acceptsCouples) {
      score -= 15;
    }

    // Extranjeros
    if (prefs.acceptsForeigners && !room.acceptsForeigners) {
      score -= 20;
    }

    // Tipo de contrato
    if (room.contractType == prefs.contractType) {
      score = min(score + 10, 100.0);
    } else if (room.contractType == ContractType.flexible ||
        prefs.contractType == ContractType.flexible) {
      score = min(score + 5, 100.0);
    }

    // Duración mínima
    if (room.minContractMonths > prefs.minContractDuration) {
      final overMonths = room.minContractMonths - prefs.minContractDuration;
      score -= overMonths * 5;
    }

    // Disponibilidad
    if (prefs.moveInDate != null) {
      if (!room.availableFrom.isAfter(prefs.moveInDate!)) {
        score = min(score + 5, 100.0);
      } else {
        final daysLate =
            room.availableFrom.difference(prefs.moveInDate!).inDays;
        if (daysLate > 7) {
          score -= min(daysLate, 15).toDouble();
        }
      }
    }

    return score.clamp(0.0, 100.0);
  }

  /// **Reputación** (0-100).
  /// Combina nivel de verificación del cuarto, trust score del propietario,
  /// rating promedio del propietario y existencia de contrato digital.
  double _reputationScore(Room room, UserPreferences prefs) {
    double score = 0.0;

    // Nivel de verificación (0-3) → 0-35 puntos
    score += (room.verificationLevel / 3) * 35;

    // Trust score del propietario → 0-30 puntos
    score += (room.trustScore / 100) * 30;

    // Rating del propietario (0-5) → 0-20 puntos
    score += (room.ownerRating / 5) * 20;

    // Contrato digital → 0-15 puntos
    if (room.hasDigitalContract) {
      score += 15;
    }

    return score.clamp(0.0, 100.0);
  }

  // ── Compatibilidad entre compañeros de cuarto ──────────────────────

  /// Calcula compatibilidad entre dos perfiles de compañeros (0-100).
  ///
  /// Pesos:
  /// - Limpieza 25%
  /// - Horario de sueño 25%
  /// - Nivel social 20%
  /// - Hábitos de estudio 15%
  /// - Tags de estilo de vida 15%
  double calculateRoommateCompatibility(
      RoommateProfile a, RoommateProfile b) {
    final cleanlinessScore = _cleanlinessCompatibility(a, b);
    final sleepScore = _sleepCompatibility(a, b);
    final socialScore = _socialCompatibility(a, b);
    final studyScore = _studyCompatibility(a, b);
    final lifestyleScore = _lifestyleCompatibility(a, b);

    final total = (cleanlinessScore * 0.25) +
        (sleepScore * 0.25) +
        (socialScore * 0.20) +
        (studyScore * 0.15) +
        (lifestyleScore * 0.15);

    return total.clamp(0.0, 100.0);
  }

  double _cleanlinessCompatibility(RoommateProfile a, RoommateProfile b) {
    final diff = (a.cleanlinessLevel - b.cleanlinessLevel).abs();
    return (100 - diff * 17.5).clamp(30.0, 100.0);
  }

  double _sleepCompatibility(RoommateProfile a, RoommateProfile b) {
    const scheduleOrder = {
      SleepSchedule.early: 0,
      SleepSchedule.normal: 1,
      SleepSchedule.late: 2,
      SleepSchedule.nightOwl: 3,
    };

    final diff =
        (scheduleOrder[a.sleepSchedule]! - scheduleOrder[b.sleepSchedule]!).abs();

    switch (diff) {
      case 0:
        return 100.0;
      case 1:
        return 80.0;
      case 2:
        return 55.0;
      case 3:
        return 30.0;
      default:
        return 30.0;
    }
  }

  double _socialCompatibility(RoommateProfile a, RoommateProfile b) {
    final diff = (a.socialLevel - b.socialLevel).abs();
    if (diff <= 1) return 90.0;
    if (diff == 2) return 65.0;
    return (100 - diff * 15).clamp(30.0, 100.0).toDouble();
  }

  double _studyCompatibility(RoommateProfile a, RoommateProfile b) {
    final diff = (a.studyLevel - b.studyLevel).abs();
    if (diff <= 1) return 95.0;
    if (diff == 2) return 70.0;
    return (100 - diff * 12).clamp(30.0, 100.0).toDouble();
  }

  double _lifestyleCompatibility(RoommateProfile a, RoommateProfile b) {
    if (a.lifestyleTags.isEmpty || b.lifestyleTags.isEmpty) return 60.0;

    int matched = 0;
    for (final tag in a.lifestyleTags) {
      if (b.lifestyleTags
          .any((lt) => lt.toLowerCase().contains(tag.toLowerCase()))) {
        matched++;
      }
    }

    final maxTags = max(a.lifestyleTags.length, b.lifestyleTags.length);
    return (30 + (matched / maxTags) * 70).clamp(30.0, 100.0);
  }

  // ── Obtener los mejores matches ────────────────────────────────────

  /// Retorna las [count] habitaciones con mejor puntaje de matching.
  List<Room> getTopMatches(List<Room> rooms, UserPreferences prefs, int count) {
    final scored = rooms.map((room) {
      return MapEntry(room, calculateScore(room, prefs));
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));

    return scored.take(count).map((e) => e.key).toList();
  }

  // ── Explicación del matching ───────────────────────────────────────

  /// Genera explicación detallada en español de por qué una habitación
  /// tiene ese puntaje. Retorna:
  /// - `overallScore`: puntaje total
  /// - `dimensions`: map con cada dimensión y su puntaje
  /// - `highlights`: lista de puntos fuertes
  /// - `warnings`: lista de puntos débiles
  /// - `summary`: resumen ejecutivo en español
  Map<String, dynamic> getExplanation(Room room, UserPreferences prefs) {
    final location = _locationScore(room, prefs);
    final budget = _budgetScore(room, prefs);
    final habits = _habitsScore(room, prefs);
    final services = _servicesScore(room, prefs);
    final preferences = _preferencesScore(room, prefs);
    final reputation = _reputationScore(room, prefs);

    final overall = calculateScore(room, prefs);
    final weights = _resolveWeights(prefs);

    final List<String> highlights = [];
    final List<String> warnings = [];

    // Ubicación
    if (location >= 90) {
      highlights.add(
          'Excelente ubicación: ${room.walkingTimeMin} min caminando en ${room.district}');
    } else if (location >= 70) {
      highlights.add(
          'Buena ubicación en ${room.district}, a ${room.walkingTimeMin} min');
    } else if (location < 50) {
      warnings.add(
          'Está a ${room.distanceKm.toStringAsFixed(1)} km, más lejos de tu preferencia (${prefs.maxDistance.toStringAsFixed(1)} km)');
    }

    // Presupuesto
    if (budget >= 90) {
      highlights.add(
          'El precio S/ ${room.price.toStringAsFixed(0)} está en tu rango ideal');
    } else if (budget < 50) {
      warnings.add(
          'El precio S/ ${room.price.toStringAsFixed(0)} supera tu presupuesto máximo de S/ ${prefs.maxBudget.toStringAsFixed(0)}');
    }

    // Hábitos
    if (habits >= 85) {
      highlights.add('Tus hábitos de convivencia encajan bien con este cuarto');
    } else if (habits < 60) {
      warnings.add('Hay diferencias en hábitos (fumar, visitas, horarios)');
    }

    // Servicios
    if (services >= 85) {
      highlights.add('Cuenta con los servicios que necesitas');
    } else if (services < 60) {
      final missing = prefs.requiredAmenities
          .where((req) => !room.amenities
              .any((a) => a.toLowerCase().contains(req.toLowerCase())))
          .toList();
      if (missing.isNotEmpty) {
        warnings.add('No cuenta con: ${missing.join(', ')}');
      }
    }

    // Preferencias
    if (preferences < 60) {
      if (prefs.roomType != RoomType.any &&
          !_roomTypeMatches(room.roomType, prefs.roomType)) {
        warnings.add('El tipo de habitación no coincide con tu preferencia');
      }
      if (room.genderPreference != GenderPreference.any &&
          room.genderPreference != prefs.genderPreference) {
        warnings.add('La preferencia de género no es compatible');
      }
    } else if (preferences >= 85) {
      highlights.add('El tipo de contrato y preferencias encajan');
    }

    // Reputación
    if (reputation >= 80) {
      highlights.add(
          'Propietario confiable (trust ${room.trustScore}, rating ${room.ownerRating.toStringAsFixed(1)})');
    } else if (reputation < 50) {
      warnings.add(
          'Bajo nivel de verificación o reputación del propietario');
    }

    // Resumen
    String summary;
    if (overall >= 85) {
      summary =
          '¡Excelente coincidencia! Esta habitación cumple con la mayoría de tus criterios importantes.';
    } else if (overall >= 70) {
      summary =
          'Buena opción. Cumple varios de tus requisitos con compromisos menores.';
    } else if (overall >= 55) {
      summary =
          'Opción aceptable. Algunos aspectos no se alinean perfectamente.';
    } else if (overall >= 40) {
      summary =
          'Coincidencia limitada. Varios aspectos no cumplen con lo que buscas.';
    } else {
      summary =
          'Baja compatibilidad. Esta habitación no se ajusta bien a tus necesidades.';
    }

    return {
      'overallScore': overall,
      'weights': weights,
      'dimensions': {
        'ubicacion': location,
        'presupuesto': budget,
        'habitos': habits,
        'servicios': services,
        'preferencias': preferences,
        'reputacion': reputation,
      },
      'highlights': highlights,
      'warnings': warnings,
      'summary': summary,
    };
  }

  // ── Helpers privados ───────────────────────────────────────────────

  /// Resuelve los pesos finales aplicados al cálculo.
  ///
  /// Prioridad:
  /// 1. Si el usuario no definió prioridades → usa defaults balanceados.
  /// 2. Si definió prioridades → mapea a las 6 dimensiones, asegura peso
  ///    mínimo de 1.0 por dimensión (para que todas participen), y
  ///    normaliza a 1.0.
  Map<String, double> _resolveWeights(UserPreferences prefs) {
    if (prefs.priorities.isEmpty) {
      return {
        'location': _defaultLocationWeight,
        'budget': _defaultBudgetWeight,
        'habits': _defaultHabitsWeight,
        'services': _defaultServicesWeight,
        'preferences': _defaultPreferencesWeight,
        'reputation': _defaultReputationWeight,
      };
    }

    // Mapeo de IDs de prioridad del usuario a las 6 dimensiones internas.
    // Esto permite que el usuario use términos amigables (ej. "Confianza")
    // mientras el motor usa dimensiones técnicas (ej. "reputation").
    final priorityMap = <String, String>{
      'location': 'location',
      'price': 'budget',
      'habits': 'habits',
      'amenities': 'services',
      'comfort': 'preferences',
      'size': 'preferences',
      'trust': 'reputation',
      'quiet': 'habits',
      'social': 'habits',
    };

    double totalWeight = 0.0;
    final dimensionWeights = <String, double>{};

    for (final p in prefs.priorities) {
      final dim = priorityMap[p.id] ?? 'habits';
      final w = p.weight.toDouble();
      dimensionWeights[dim] = (dimensionWeights[dim] ?? 0.0) + w;
      totalWeight += w;
    }

    // Asegurar peso mínimo (1.0) para todas las dimensiones, incluso las
    // que el usuario no tocó. Así ninguna dimensión queda en cero.
    const allDimensions = [
      'location',
      'budget',
      'habits',
      'services',
      'preferences',
      'reputation'
    ];

    for (final dim in allDimensions) {
      dimensionWeights.putIfAbsent(dim, () => 1.0);
      if (dimensionWeights[dim]! < 1.0) {
        dimensionWeights[dim] = 1.0;
      }
    }

    // Recalcular total después de asegurar mínimos
    totalWeight = dimensionWeights.values.fold(0.0, (sum, w) => sum + w);

    // Normalizar a suma 1.0
    return dimensionWeights
        .map((key, value) => MapEntry(key, value / totalWeight));
  }

  /// Verifica si el tipo de habitación coincide con la preferencia.
  bool _roomTypeMatches(RoomType roomType, RoomType preference) {
    if (preference == RoomType.any) return true;
    return roomType == preference;
  }
}
