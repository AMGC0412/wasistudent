import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import 'database.dart';

/// Repositorio de usuarios con persistencia en Hive.
///
/// Maneja registro, login y perfil de usuario.
/// Las contraseñas se guardan en texto plano por simplicidad del MVP
/// (en producción, usar bcrypt o similar).
class UserRepository {
  static const _uuid = Uuid();

  /// Usuario actual autenticado.
  static User? getCurrentUser() {
    final raw = Database.authBox.get('currentUser');
    if (raw == null) return null;
    final map = Map<String, dynamic>.from(jsonDecode(raw as String));
    return User.fromJson(map);
  }

  static Future<void> setCurrentUser(User user) async {
    await Database.authBox.put('currentUser', jsonEncode(user.toJson()));
  }

  static Future<void> logout() async {
    await Database.authBox.delete('currentUser');
  }

  /// Registra un nuevo usuario.
  /// Retorna null si fue exitoso, o un mensaje de error si falló.
  static Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String university = 'UNSAAC',
    String career = '',
    int semester = 1,
  }) async {
    // Verificar si ya existe
    final existing = Database.authBox.get('user_$email');
    if (existing != null) {
      return 'Ya existe una cuenta con este correo electrónico';
    }

    final user = User(
      id: _uuid.v4(),
      name: name,
      email: email,
      phone: phone,
      avatar: name.substring(0, 2).toUpperCase(),
      university: university,
      career: career,
      semester: semester,
      birthDate: DateTime(2005, 1, 1),
      memberSince: DateTime.now(),
      lastActive: DateTime.now(),
      isVerified: false,
      verificationLevel: 0,
      trustScore: 25,
    );

    // Guardar usuario y credenciales
    await Database.authBox.put('user_$email', jsonEncode({
      'user': user.toJson(),
      'password': password,
    }));
    await setCurrentUser(user);
    return null;
  }

  /// Inicia sesión con email y contraseña.
  static Future<String?> login(String email, String password) async {
    final raw = Database.authBox.get('user_$email');
    if (raw == null) {
      return 'No existe una cuenta con este correo electrónico';
    }
    final data = Map<String, dynamic>.from(jsonDecode(raw as String));
    if (data['password'] != password) {
      return 'Contraseña incorrecta';
    }
    final user = User.fromJson(
      Map<String, dynamic>.from(data['user'] as Map),
    );
    await setCurrentUser(user);
    return null;
  }

  /// Actualiza el perfil del usuario actual.
  static Future<void> updateProfile(User user) async {
    await setCurrentUser(user);
    // También actualizar en el registro de usuarios
    final raw = Database.authBox.get('user_${user.email}');
    if (raw != null) {
      final data = Map<String, dynamic>.from(jsonDecode(raw as String));
      data['user'] = user.toJson();
      await Database.authBox.put('user_${user.email}', jsonEncode(data));
    }
  }
}
