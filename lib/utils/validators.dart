/// Validadores de formularios para WasiStudent.
///
/// Provee métodos estáticos para validar campos de formulario comunes
/// en la aplicación. Todos los mensajes de error están en español.
///
/// Uso con TextFormField:
/// ```dart
/// TextFormField(
///   validator: Validators.validateEmail,
/// )
/// ```
class Validators {
  Validators._();

  // ── Email ──────────────────────────────────────────────────────────

  /// Valida una dirección de correo electrónico.
  ///
  /// Retorna un mensaje de error en español, o `null` si es válido.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo electrónico es obligatorio';
    }

    final email = value.trim();

    // Patrón básico de validación de email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Ingresa un correo electrónico válido';
    }

    // Verificar que no tenga espacios
    if (email.contains(' ')) {
      return 'El correo electrónico no debe contener espacios';
    }

    return null;
  }

  // ── Contraseña ─────────────────────────────────────────────────────

  /// Valida una contraseña con los siguientes requisitos:
  /// - Mínimo 8 caracteres
  /// - Al menos una letra mayúscula
  /// - Al menos una letra minúscula
  /// - Al menos un número
  ///
  /// Retorna un mensaje de error en español, o `null` si es válida.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe incluir al menos una letra mayúscula';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'La contraseña debe incluir al menos una letra minúscula';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe incluir al menos un número';
    }

    return null;
  }

  /// Valida una contraseña con requisitos básicos (solo longitud mínima).
  /// Útil para formularios de login donde no se requiere validación estricta.
  static String? validatePasswordBasic(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }

    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    return null;
  }

  // ── Nombre ─────────────────────────────────────────────────────────

  /// Valida un nombre de persona.
  ///
  /// Requisitos:
  /// - No vacío
  /// - Mínimo 2 caracteres
  /// - Solo letras, espacios, acentos y apóstrofes
  /// - Máximo 100 caracteres
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }

    final name = value.trim();

    if (name.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    if (name.length > 100) {
      return 'El nombre no debe exceder 100 caracteres';
    }

    // Permitir letras (incluyendo acentos), espacios y apóstrofes
    final nameRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ'\s]+$");
    if (!nameRegex.hasMatch(name)) {
      return 'El nombre solo debe contener letras y espacios';
    }

    // No permitir múltiples espacios consecutivos
    if (name.contains(RegExp(r'\s{2,}'))) {
      return 'El nombre no debe contener espacios consecutivos';
    }

    return null;
  }

  // ── Teléfono ───────────────────────────────────────────────────────

  /// Valida un número de teléfono peruano.
  ///
  /// Acepta los siguientes formatos:
  /// - 9 dígitos empezando con 9 (celular)
  /// - +51 seguido de 9 dígitos
  /// - 7 dígitos (fijo)
  ///
  /// Retorna un mensaje de error en español, o `null` si es válido.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El número de teléfono es obligatorio';
    }

    // Limpiar el número: eliminar espacios, guiones, paréntesis
    final clean = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Verificar que solo queden dígitos y opcionalmente +
    if (!RegExp(r'^\+?\d+$').hasMatch(clean)) {
      return 'Ingresa un número de teléfono válido';
    }

    // Celular peruano: 9XXXXXXXX (9 dígitos empezando con 9)
    if (clean.startsWith('+51')) {
      final number = clean.substring(3);
      if (number.length != 9 || !number.startsWith('9')) {
        return 'El número celular peruano debe tener 9 dígitos y empezar con 9';
      }
      return null;
    }

    if (clean.startsWith('51') && clean.length == 11) {
      final number = clean.substring(2);
      if (!number.startsWith('9')) {
        return 'El número celular peruano debe empezar con 9';
      }
      return null;
    }

    // Número local de 9 dígitos
    if (clean.length == 9 && clean.startsWith('9')) {
      return null;
    }

    // Número fijo de 7 dígitos (Cusco: 22XXXX, 23XXXX)
    if (clean.length == 7) {
      return null;
    }

    // Número internacional
    if (clean.startsWith('+') && clean.length >= 10) {
      return null;
    }

    return 'Ingresa un número de teléfono válido (9 dígitos para celular)';
  }

  // ── DNI peruano ────────────────────────────────────────────────────

  /// Valida un DNI peruano (Documento Nacional de Identidad).
  ///
  /// El DNI peruano tiene exactamente 8 dígitos numéricos.
  ///
  /// Retorna un mensaje de error en español, o `null` si es válido.
  static String? validateDNI(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El DNI es obligatorio';
    }

    final dni = value.trim();

    // Verificar que solo contenga dígitos
    if (!RegExp(r'^\d+$').hasMatch(dni)) {
      return 'El DNI solo debe contener números';
    }

    // Verificar longitud exacta de 8 dígitos
    if (dni.length != 8) {
      return 'El DNI debe tener exactamente 8 dígitos';
    }

    return null;
  }

  // ── Campo requerido genérico ───────────────────────────────────────

  /// Valida que un campo requerido no esté vacío.
  ///
  /// Parámetros:
  /// - [value]: El valor a validar
  /// - [fieldName]: El nombre del campo para el mensaje de error
  ///
  /// Ejemplo:
  /// ```dart
  /// validator: (v) => Validators.validateRequired(v, 'La dirección'),
  /// ```
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    return null;
  }

  // ── Otros validadores ──────────────────────────────────────────────

  /// Valida que un valor numérico esté dentro de un rango.
  static String? validateRange(
    String? value, {
    required String fieldName,
    required double min,
    required double max,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }

    final num = double.tryParse(value.trim());
    if (num == null) {
      return '$fieldName debe ser un número válido';
    }

    if (num < min || num > max) {
      return '$fieldName debe estar entre $min y $max';
    }

    return null;
  }

  /// Valida que un texto tenga una longitud mínima.
  static String? validateMinLength(
    String? value, {
    required String fieldName,
    required int minLength,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }

    if (value.trim().length < minLength) {
      return '$fieldName debe tener al menos $minLength caracteres';
    }

    return null;
  }

  /// Valida que un texto tenga una longitud máxima.
  static String? validateMaxLength(
    String? value, {
    required String fieldName,
    required int maxLength,
  }) {
    if (value == null) return null; // Opcional

    if (value.length > maxLength) {
      return '$fieldName no debe exceder $maxLength caracteres';
    }

    return null;
  }

  /// Valida una URL.
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La URL es obligatoria';
    }

    final url = value.trim();
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(url)) {
      return 'Ingresa una URL válida';
    }

    return null;
  }

  /// Valida la confirmación de contraseña.
  static String? validatePasswordConfirmation(
    String? value, {
    required String originalPassword,
  }) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (value != originalPassword) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  // ── Validadores compuestos ─────────────────────────────────────────

  /// Combina múltiples validadores para un campo.
  /// Retorna el primer error encontrado, o `null` si todos pasan.
  ///
  /// Ejemplo:
  /// ```dart
  /// validator: (v) => Validators.compose([
  ///   () => Validators.validateRequired(v, 'Nombre'),
  ///   () => Validators.validateMinLength(v, fieldName: 'Nombre', minLength: 2),
  /// ]),
  /// ```
  static String? compose(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) return error;
    }
    return null;
  }
}
