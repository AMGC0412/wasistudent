import 'package:flutter/material.dart';

import '../models/review.dart';

/// Proveedor de reseñas para la aplicación WasiStudent.
/// Gestiona la carga, creación y estadísticas de reseñas
/// para las habitaciones y propietarios en Cusco.
class ReviewProvider extends ChangeNotifier {
  // ── Estado ──────────────────────────────────────────────────────

  Map<String, List<Review>> _reviewsByRoom = {};
  bool _isLoading = false;
  String? _error;

  // ── Getters ─────────────────────────────────────────────────────

  /// Indica si hay una operación de carga en curso.
  bool get isLoading => _isLoading;

  /// Mensaje de error de la última operación fallida.
  String? get error => _error;

  // ── Constructor ─────────────────────────────────────────────────

  ReviewProvider() {
    _loadAllMockReviews();
  }

  // ── Carga de Datos ──────────────────────────────────────────────

  /// Carga las reseñas para una habitación específica.
  Future<void> loadReviewsForRoom(String roomId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Si no tenemos reseñas para esta habitación, cargarlas desde mock
      if (!_reviewsByRoom.containsKey(roomId)) {
        final allReviews = Review.mockReviews();
        final roomReviews = allReviews.where((r) => r.roomId == roomId).toList();
        _reviewsByRoom[roomId] = roomReviews;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error al cargar las reseñas. Intenta de nuevo.';
      notifyListeners();
    }
  }

  /// Precarga todas las reseñas mock organizadas por habitación.
  void _loadAllMockReviews() {
    final allReviews = Review.mockReviews();
    for (final review in allReviews) {
      _reviewsByRoom.putIfAbsent(review.roomId, () => []);
      _reviewsByRoom[review.roomId]!.add(review);
    }
  }

  // ── Agregar Reseña ─────────────────────────────────────────────

  /// Agrega una nueva reseña para una habitación.
  void addReview(Review review) {
    _reviewsByRoom.putIfAbsent(review.roomId, () => []);
    _reviewsByRoom[review.roomId]!.add(review);
    notifyListeners();
  }

  // ── Interacciones ───────────────────────────────────────────────

  /// Alterna el conteo de "útil" en una reseña.
  void toggleHelpful(String reviewId) {
    for (final roomId in _reviewsByRoom.keys) {
      final reviews = _reviewsByRoom[roomId]!;
      final index = reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        final review = reviews[index];
        reviews[index] = review.copyWith(
          helpfulCount: review.helpfulCount + 1,
        );
        notifyListeners();
        return;
      }
    }
  }

  // ── Consultas ───────────────────────────────────────────────────

  /// Obtiene las reseñas de una habitación.
  List<Review> getReviewsForRoom(String roomId) {
    return _reviewsByRoom[roomId] ?? [];
  }

  /// Calcula el promedio de calificación general de una habitación.
  double getAverageRating(String roomId) {
    final reviews = _reviewsByRoom[roomId];
    if (reviews == null || reviews.isEmpty) return 0.0;
    final total = reviews.fold(0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  /// Obtiene el desglose de calificaciones por categoría.
  Map<String, double> getRatingBreakdown(String roomId) {
    final reviews = _reviewsByRoom[roomId];
    if (reviews == null || reviews.isEmpty) {
      return {
        'Limpieza': 0.0,
        'Ubicación': 0.0,
        'Calidad/precio': 0.0,
        'Comunicación': 0.0,
        'Precisión': 0.0,
      };
    }

    return {
      'Limpieza': reviews
              .where((r) => r.cleanlinessRating > 0)
              .fold(0.0, (sum, r) => sum + r.cleanlinessRating) /
          reviews.where((r) => r.cleanlinessRating > 0).length,
      'Ubicación': reviews
              .where((r) => r.locationRating > 0)
              .fold(0.0, (sum, r) => sum + r.locationRating) /
          reviews.where((r) => r.locationRating > 0).length,
      'Calidad/precio': reviews
              .where((r) => r.valueRating > 0)
              .fold(0.0, (sum, r) => sum + r.valueRating) /
          reviews.where((r) => r.valueRating > 0).length,
      'Comunicación': reviews
              .where((r) => r.communicationRating > 0)
              .fold(0.0, (sum, r) => sum + r.communicationRating) /
          reviews.where((r) => r.communicationRating > 0).length,
      'Precisión': reviews
              .where((r) => r.accuracyRating > 0)
              .fold(0.0, (sum, r) => sum + r.accuracyRating) /
          reviews.where((r) => r.accuracyRating > 0).length,
    };
  }

  /// Cantidad de reseñas para una habitación.
  int getReviewCount(String roomId) {
    return _reviewsByRoom[roomId]?.length ?? 0;
  }

  /// Distribución de estrellas (1-5) para una habitación.
  Map<int, int> getStarDistribution(String roomId) {
    final reviews = _reviewsByRoom[roomId] ?? [];
    final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
    }
    return distribution;
  }
}
