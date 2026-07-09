import 'package:flutter/foundation.dart';

/// Rol del usuario en WasiStudent.
///
/// WasiStudent tiene dos roles principales:
/// - [student]: busca cuarto, firma contratos, deja reseñas.
/// - [owner]: ofrece cuartos, recibe solicitudes, firma contratos.
///
/// Un usuario puede cambiar su rol activo desde Ajustes. El cambio de
/// rol no elimina al otro: el usuario conserva su perfil de estudiante
/// y de propietaria en paralelo. Solo cambia qué pantallas ve.
///
/// Requisitos para activar el rol propietaria (definidos en
/// `SettingsScreen` → "Convertirme en propietario"):
/// 1. Identidad verificada (DNI + selfie).
/// 2. Declaración jurada de propiedad o autorización del propietario.
/// 3. Aceptar términos del servicio para propietarios.
/// 4. Trust Score ≥ 50 (no tener infracciones activas).
enum UserRole { student, owner }

class RoleProvider extends ChangeNotifier {
  UserRole _activeRole = UserRole.student;

  /// Si el usuario tiene el rol propietaria habilitado.
  bool _isOwnerEnabled = false;

  UserRole get activeRole => _activeRole;
  bool get isOwnerEnabled => _isOwnerEnabled;
  bool get isOwner => _activeRole == UserRole.owner;

  /// Cambia el rol activo. Solo permite cambiar a propietaria si
  /// `_isOwnerEnabled` es true.
  void switchRole(UserRole role) {
    if (role == UserRole.owner && !_isOwnerEnabled) {
      return;
    }
    _activeRole = role;
    notifyListeners();
  }

  /// Habilita el rol propietaria después de cumplir requisitos.
  void enableOwnerRole() {
    _isOwnerEnabled = true;
    notifyListeners();
  }

  /// Deshabilita el rol propietaria (vuelve a ser solo estudiante).
  void disableOwnerRole() {
    _isOwnerEnabled = false;
    if (_activeRole == UserRole.owner) {
      _activeRole = UserRole.student;
    }
    notifyListeners();
  }
}
