import 'package:flutter/material.dart';

import '../data/user_repository.dart';
import '../models/user.dart';

/// Proveedor de autenticación que usa UserRepository (Hive) para
/// persistencia real del usuario actual.
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    // Cargar usuario persistido al iniciar
    _currentUser = UserRepository.getCurrentUser();
  }

  /// Establece el usuario actual (usado después de login/registro).
  void setUser(User user) {
    _currentUser = user;
    _error = null;
    notifyListeners();
  }

  /// Cierra sesión y limpia persistencia.
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await UserRepository.logout();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Actualiza el perfil del usuario actual.
  void updateProfile(User updated) {
    _currentUser = updated;
    UserRepository.updateProfile(updated);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
