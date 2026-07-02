import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/user_repository.dart';
import '../providers/auth_provider.dart';
import '../theme/design.dart';
import '../utils/validators.dart';

/// Pantalla de autenticación con login y registro.
///
/// Primera pantalla que ve el usuario. Maneja:
/// - Login con email + contraseña
/// - Registro con nombre, email, teléfono, contraseña, universidad
/// - Validación en tiempo real
/// - Persistencia automática vía UserRepository (Hive)
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _university = 'UNSAAC';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String? error;
    if (_isLogin) {
      error = await UserRepository.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      error = await UserRepository.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        university: _university,
      );
    }

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
      return;
    }

    // Login/registro exitoso — actualizar AuthProvider y navegar
    final user = UserRepository.getCurrentUser();
    if (user != null) {
      context.read<AuthProvider>().setUser(user);
    }
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(WasiDesign.spaceXxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: WasiDesign.spaceXxl),

                // Logo y bienvenida
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: WasiDesign.primary,
                    borderRadius: BorderRadius.circular(WasiDesign.radiusXxl),
                  ),
                  child: const Icon(
                    Icons.home_work_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: WasiDesign.spaceXl),
                Text(
                  _isLogin ? 'Bienvenido de vuelta' : 'Crea tu cuenta',
                  style: WasiDesign.displayLarge,
                ),
                const SizedBox(height: WasiDesign.spaceSm),
                Text(
                  _isLogin
                      ? 'Ingresa para encontrar tu wasi en Cusco'
                      : 'Únete a WasiStudent y encuentra vivienda verificada',
                  style: WasiDesign.bodyMedium,
                ),
                const SizedBox(height: WasiDesign.spaceXxl),

                // Campos
                if (!_isLogin) ...[
                  _buildField(
                    controller: _nameController,
                    label: 'Nombre completo',
                    icon: Icons.person_outline,
                    validator: Validators.validateName,
                  ),
                  const SizedBox(height: WasiDesign.spaceMd),
                ],
                _buildField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: WasiDesign.spaceMd),
                if (!_isLogin) ...[
                  _buildField(
                    controller: _phoneController,
                    label: 'Teléfono',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhone,
                  ),
                  const SizedBox(height: WasiDesign.spaceMd),
                  // Universidad selector
                  DropdownButtonFormField<String>(
                    initialValue: _university,
                    decoration: const InputDecoration(
                      labelText: 'Universidad',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'UNSAAC', child: Text('UNSAAC')),
                      DropdownMenuItem(
                          value: 'UAC', child: Text('Universidad Andina')),
                      DropdownMenuItem(
                          value: 'Continental',
                          child: Text('Universidad Continental')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _university = v);
                    },
                  ),
                  const SizedBox(height: WasiDesign.spaceMd),
                ],
                _buildField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 6)
                      ? 'Mínimo 6 caracteres'
                      : null,
                ),
                const SizedBox(height: WasiDesign.spaceLg),

                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(WasiDesign.spaceMd),
                    decoration: BoxDecoration(
                      color: WasiDesign.errorContainer,
                      borderRadius:
                          BorderRadius.circular(WasiDesign.radiusMd),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: WasiDesign.error, size: 20),
                        const SizedBox(width: WasiDesign.spaceSm),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: WasiDesign.error,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: WasiDesign.spaceLg),
                ],

                // Botón principal
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: WasiDesign.spaceLg),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(_isLogin ? 'Iniciar sesión' : 'Crear cuenta'),
                ),
                const SizedBox(height: WasiDesign.spaceLg),

                // Toggle login/registro
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _errorMessage = null;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? '¿No tienes cuenta? Regístrate'
                        : '¿Ya tienes cuenta? Inicia sesión',
                    style: const TextStyle(
                      color: WasiDesign.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
