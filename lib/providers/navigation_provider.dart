import 'package:flutter/material.dart';

/// Proveedor de navegación para la aplicación WasiStudent.
/// Gestiona la pestaña activa en la barra de navegación inferior.
class NavigationProvider extends ChangeNotifier {
  // ── Estado ──────────────────────────────────────────────────────

  int _currentIndex = 0;

  // ── Getter ──────────────────────────────────────────────────────

  /// Índice de la pestaña activa actualmente.
  int get currentIndex => _currentIndex;

  // ── Métodos Públicos ────────────────────────────────────────────

  /// Establece el índice de la pestaña activa.
  void setIndex(int index) {
    if (_currentIndex != index && index >= 0) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// Indica si la pestaña dada es la activa.
  bool isOnTab(int index) => _currentIndex == index;

  /// Resetea la navegación a la pestaña de inicio.
  void reset() {
    _currentIndex = 0;
    notifyListeners();
  }
}
