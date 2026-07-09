import 'package:flutter/material.dart';

import '../models/user_preferences.dart';

/// Proveedor de preferencias del usuario para la aplicación WasiStudent.
/// Gestiona todos los filtros, prioridades y configuraciones de estilo
/// de vida que el estudiante define para buscar alojamiento en Cusco.
class PreferenceProvider extends ChangeNotifier {
  // ── Estado ──────────────────────────────────────────────────────

  UserPreferences _prefs = UserPreferences.getMockPreferences();

  // ── Getter ──────────────────────────────────────────────────────

  /// Preferencias actuales del usuario.
  UserPreferences get prefs => _prefs;

  // ── Actualizaciones de Presupuesto ──────────────────────────────

  /// Actualiza el presupuesto mínimo.
  void updateMinBudget(double min) {
    _prefs = _prefs.copyWith(minBudget: min);
    notifyListeners();
  }

  /// Actualiza el presupuesto máximo.
  void updateMaxBudget(double max) {
    _prefs = _prefs.copyWith(maxBudget: max);
    notifyListeners();
  }

  /// Actualiza el rango completo de presupuesto.
  void updateBudget(double min, double max) {
    _prefs = _prefs.copyWith(minBudget: min, maxBudget: max);
    notifyListeners();
  }

  // ── Actualizaciones de Ubicación ────────────────────────────────

  /// Actualiza la distancia máxima aceptable (en km).
  void updateMaxDistance(double distance) {
    _prefs = _prefs.copyWith(maxDistance: distance);
    notifyListeners();
  }

  /// Actualiza el tiempo máximo caminando (en minutos).
  void updateMaxWalkingTime(int minutes) {
    _prefs = _prefs.copyWith(maxWalkingTime: minutes);
    notifyListeners();
  }

  /// Actualiza la universidad de referencia.
  void updateUniversity(String university) {
    _prefs = _prefs.copyWith(university: university);
    notifyListeners();
  }

  // ── Actualizaciones de Preferencias Personales ──────────────────

  /// Actualiza la preferencia de género.
  void updateGenderPreference(GenderPreference preference) {
    _prefs = _prefs.copyWith(genderPreference: preference);
    notifyListeners();
  }

  /// Alterna un servicio/amenidad en la lista de requeridos.
  void toggleAmenity(String amenity) {
    final current = List<String>.from(_prefs.requiredAmenities);
    if (current.contains(amenity)) {
      current.remove(amenity);
    } else {
      current.add(amenity);
    }
    _prefs = _prefs.copyWith(requiredAmenities: current);
    notifyListeners();
  }

  /// Alterna un tag de estilo de vida.
  void toggleLifestyleTag(String tag) {
    final current = List<String>.from(_prefs.lifestyleTags);
    if (current.contains(tag)) {
      current.remove(tag);
    } else {
      current.add(tag);
    }
    _prefs = _prefs.copyWith(lifestyleTags: current);
    notifyListeners();
  }

  // ── Actualizaciones de Prioridades ──────────────────────────────

  /// Reordena las prioridades del usuario.
  void reorderPriorities(List<PriorityItem> newPriorities) {
    _prefs = _prefs.copyWith(priorities: newPriorities);
    notifyListeners();
  }

  /// Actualiza el peso de una prioridad específica.
  void updatePriorityWeight(String priorityId, int weight) {
    final updated = _prefs.priorities.map((p) {
      if (p.id == priorityId) {
        return p.copyWith(weight: weight.clamp(1, 5));
      }
      return p;
    }).toList();
    _prefs = _prefs.copyWith(priorities: updated);
    notifyListeners();
  }

  // ── Actualizaciones de Contrato ─────────────────────────────────

  /// Actualiza el tipo de contrato preferido.
  void updateContractType(ContractType type) {
    _prefs = _prefs.copyWith(contractType: type);
    notifyListeners();
  }

  /// Actualiza la fecha de mudanza deseada.
  void updateMoveInDate(DateTime? date) {
    _prefs = _prefs.copyWith(moveInDate: date);
    notifyListeners();
  }

  /// Actualiza la duración mínima del contrato (en meses).
  void updateMinContractDuration(int months) {
    _prefs = _prefs.copyWith(minContractDuration: months);
    notifyListeners();
  }

  // ── Actualizaciones de Tipo de Habitación ───────────────────────

  /// Actualiza el tipo de habitación preferido.
  void updateRoomType(RoomType type) {
    _prefs = _prefs.copyWith(roomType: type);
    notifyListeners();
  }

  // ── Actualizaciones de Distritos ────────────────────────────────

  /// Agrega un distrito a los preferidos.
  void addPreferredDistrict(String district) {
    final current = List<String>.from(_prefs.preferredDistricts);
    if (!current.contains(district)) {
      current.add(district);
      _prefs = _prefs.copyWith(preferredDistricts: current);
      notifyListeners();
    }
  }

  /// Remueve un distrito de los preferidos.
  void removePreferredDistrict(String district) {
    final current = List<String>.from(_prefs.preferredDistricts);
    if (current.contains(district)) {
      current.remove(district);
      _prefs = _prefs.copyWith(preferredDistricts: current);
      notifyListeners();
    }
  }

  // ── Actualizaciones de Estilo de Vida ───────────────────────────

  /// Actualiza las horas de silencio (ej. "22:00 - 07:00").
  void updateQuietHours(String? hours) {
    _prefs = _prefs.copyWith(quietHours: hours);
    notifyListeners();
  }

  /// Actualiza si se acepta fumar.
  void updateSmokingOK(bool value) {
    _prefs = _prefs.copyWith(smokingOK: value);
    notifyListeners();
  }

  /// Actualiza si se permiten visitas.
  void updateVisitorsOK(bool value) {
    _prefs = _prefs.copyWith(visitorsOK: value);
    notifyListeners();
  }

  // ── Restablecer ─────────────────────────────────────────────────

  /// Restablece todas las preferencias a sus valores por defecto.
  void resetToDefaults() {
    _prefs = _prefs.resetToDefaults();
    notifyListeners();
  }

  // ── Utilidades ──────────────────────────────────────────────────

  /// Indica si una amenidad está seleccionada.
  bool hasAmenity(String amenity) =>
      _prefs.requiredAmenities.contains(amenity);

  /// Indica si un tag de estilo de vida está seleccionado.
  bool hasLifestyleTag(String tag) =>
      _prefs.lifestyleTags.contains(tag);

  /// Indica si un distrito está en los preferidos.
  bool hasPreferredDistrict(String district) =>
      _prefs.preferredDistricts.contains(district);
}
