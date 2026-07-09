import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Proveedor de tema para la aplicación WasiStudent.
/// Gestiona el modo claro/oscuro y persiste la preferencia en Hive.
class ThemeProvider extends ChangeNotifier {
  // ── Estado ──────────────────────────────────────────────────────

  bool _isDark = false;

  // ── Getters ─────────────────────────────────────────────────────

  /// Indica si el modo oscuro está activado.
  bool get isDark => _isDark;

  // ── Constructor ─────────────────────────────────────────────────

  ThemeProvider() {
    _loadPreference();
  }

  // ── Métodos Públicos ────────────────────────────────────────────

  /// Alterna entre modo claro y oscuro.
  void toggleTheme() {
    _isDark = !_isDark;
    _savePreference();
    notifyListeners();
  }

  /// Establece el tema directamente.
  void setTheme(bool isDark) {
    if (_isDark != isDark) {
      _isDark = isDark;
      _savePreference();
      notifyListeners();
    }
  }

  // ── Métodos Privados ────────────────────────────────────────────

  /// Carga la preferencia de tema desde Hive.
  ///
  /// Si Hive no está inicializado (ej. en tests sin `Hive.initFlutter`),
  /// usa el valor por defecto sin lanzar error.
  Future<void> _loadPreference() async {
    try {
      final box = await Hive.openBox('preferences');
      _isDark = box.get('isDark', defaultValue: false) as bool;
      notifyListeners();
    } catch (e) {
      // Si Hive no está disponible (tests, entorno sin almacenamiento),
      // usar valor por defecto silenciosamente.
      _isDark = false;
    }
  }

  /// Guarda la preferencia de tema en Hive.
  Future<void> _savePreference() async {
    try {
      final box = await Hive.openBox('preferences');
      await box.put('isDark', _isDark);
    } catch (_) {
      // Si Hive no está disponible, ignorar silenciosamente.
      // El estado en memoria se mantiene correcto.
    }
  }
}
