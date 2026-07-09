import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../config/routes.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/role_provider.dart';
import '../providers/theme_provider.dart';

/// Pantalla de configuración.
/// Secciones para cuenta (cambiar contraseña, privacidad), notificaciones
/// (toggles), apariencia (modo oscuro), región (moneda, idioma) y
/// acerca de (versión, términos, privacidad, calificar app).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          children: [
            // ── User Role Section ──
            Consumer<RoleProvider>(
              builder: (context, roleProvider, _) {
                return _SettingsSection(
                  title: 'Rol de usuario',
                  children: [
                    if (!roleProvider.isOwnerEnabled) ...[
                      _SettingsTile(
                        icon: Icons.home_work_outlined,
                        title: 'Convertirme en propietaria/o',
                        subtitle:
                            'Publica tus cuartos y recibe solicitudes de '
                            'estudiantes verificados',
                        onTap: () => _showOwnerEnableDialog(context, roleProvider),
                      ),
                    ] else ...[
                      _SettingsTile(
                        icon: Icons.swap_horiz_outlined,
                        title: 'Cambiar rol activo',
                        subtitle: roleProvider.isOwner
                            ? 'Actual: Propietaria'
                            : 'Actual: Estudiante',
                        onTap: () {
                          roleProvider.switchRole(
                            roleProvider.isOwner
                                ? UserRole.student
                                : UserRole.owner,
                          );
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.dashboard_outlined,
                        title: 'Abrir panel de propietaria',
                        onTap: () => context.push(AppRoutes.ownerDashboard),
                      ),
                      _SettingsTile(
                        icon: Icons.home_work_outlined,
                        title: 'Mis cuartos publicados',
                        onTap: () => context.push(AppRoutes.ownerRooms),
                      ),
                      _SettingsTile(
                        icon: Icons.mark_email_unread_outlined,
                        title: 'Solicitudes recibidas',
                        onTap: () => context.push(AppRoutes.ownerRequests),
                      ),
                      _SettingsTile(
                        icon: Icons.do_not_disturb_alt_outlined,
                        title: 'Desactivar cuenta de propietaria',
                        subtitle: 'Vuelve a ser solo estudiante',
                        onTap: () => _showOwnerDisableDialog(context, roleProvider),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 12),

            // ── Account Section ──
            _SettingsSection(
              title: 'Cuenta',
              children: [
                _SettingsTile(
                  icon: Icons.lock_outline,
                  title: 'Cambiar contraseña',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cambio de contraseña próximamente'),
                      ),
                    );
                  },
                ),
                _SettingsTile(
                  icon: Icons.visibility_outlined,
                  title: 'Privacidad',
                  subtitle: 'Controla quién ve tu perfil',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacidad próximamente')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Notifications Section ──
            _SettingsSection(
              title: 'Notificaciones',
              children: [
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    final settings = authProvider.currentUser?.settings ??
                        const NotificationSettings();
                    return Column(
                      children: [
                        _SettingsSwitch(
                          icon: Icons.notifications_outlined,
                          title: 'Notificaciones push',
                          value: settings.pushEnabled,
                          onChanged: (v) {
                            // Placeholder - would update user settings
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  v
                                      ? 'Push activadas'
                                      : 'Push desactivadas',
                                ),
                              ),
                            );
                          },
                        ),
                        _SettingsSwitch(
                          icon: Icons.email_outlined,
                          title: 'Notificaciones por email',
                          value: settings.emailEnabled,
                          onChanged: (v) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  v ? 'Email activado' : 'Email desactivado',
                                ),
                              ),
                            );
                          },
                        ),
                        _SettingsSwitch(
                          icon: Icons.sms_outlined,
                          title: 'Notificaciones por SMS',
                          value: settings.smsEnabled,
                          onChanged: (v) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  v ? 'SMS activado' : 'SMS desactivado',
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 48),
                        _SettingsSwitch(
                          icon: Icons.payments_outlined,
                          title: 'Recordatorios de pago',
                          value: settings.paymentReminders,
                          onChanged: (v) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  v
                                      ? 'Recordatorios activados'
                                      : 'Recordatorios desactivados',
                                ),
                              ),
                            );
                          },
                        ),
                        _SettingsSwitch(
                          icon: Icons.chat_bubble_outline,
                          title: 'Mensajes nuevos',
                          value: settings.messages,
                          onChanged: (v) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  v
                                      ? 'Notif. mensajes activadas'
                                      : 'Notif. mensajes desactivadas',
                                ),
                              ),
                            );
                          },
                        ),
                        _SettingsSwitch(
                          icon: Icons.star_outline,
                          title: 'Nuevas reseñas',
                          value: settings.reviewNotifications,
                          onChanged: (v) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  v
                                      ? 'Notif. reseñas activadas'
                                      : 'Notif. reseñas desactivadas',
                                ),
                              ),
                            );
                          },
                        ),
                        _SettingsSwitch(
                          icon: Icons.local_offer_outlined,
                          title: 'Promociones',
                          value: settings.promotions,
                          onChanged: (v) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  v
                                      ? 'Promociones activadas'
                                      : 'Promociones desactivadas',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Appearance Section ──
            _SettingsSection(
              title: 'Apariencia',
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return _SettingsSwitch(
                      icon: Icons.dark_mode_outlined,
                      title: 'Modo oscuro',
                      subtitle: themeProvider.isDark ? 'Activado' : 'Desactivado',
                      value: themeProvider.isDark,
                      onChanged: (_) => themeProvider.toggleTheme(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Region Section ──
            _SettingsSection(
              title: 'Región',
              children: [
                _SettingsTile(
                  icon: Icons.attach_money,
                  title: 'Moneda',
                  subtitle: 'Soles (S/)',
                  onTap: () {
                    _showCurrencyPicker(context);
                  },
                ),
                _SettingsTile(
                  icon: Icons.language,
                  title: 'Idioma',
                  subtitle: 'Español',
                  onTap: () {
                    _showLanguagePicker(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── About Section ──
            _SettingsSection(
              title: 'Acerca de',
              children: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'Versión de la app',
                  subtitle: '4.0.0 (build 4)',
                  onTap: null,
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Términos y condiciones',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Términos próximamente'),
                      ),
                    );
                  },
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Política de privacidad',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Privacidad próximamente'),
                      ),
                    );
                  },
                ),
                _SettingsTile(
                  icon: Icons.rate_review_outlined,
                  title: 'Calificar la app',
                  subtitle: '¡Tu opinión nos importa!',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Calificación próximamente'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Currency Picker ────────────────────────────────────────────────

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seleccionar moneda',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFD91023),
                  radius: 14,
                  child: Text('S/', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)),
                ),
                title: const Text('Soles peruanos'),
                subtitle: const Text('S/ (PEN)'),
                trailing: const Icon(Icons.check_circle, color: WasiColors.success),
                onTap: () => Navigator.of(ctx).pop(),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF2C3E50),
                  radius: 14,
                  child: Text('\$', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                ),
                title: const Text('Dólares estadounidenses'),
                subtitle: const Text('\$ (USD)'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Moneda cambiada a USD')),
                  );
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF003399),
                  radius: 14,
                  child: Text('€', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                ),
                title: const Text('Euros'),
                subtitle: const Text('€ (EUR)'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Moneda cambiada a EUR')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Language Picker ────────────────────────────────────────────────

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seleccionar idioma',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Español'),
                trailing: const Icon(Icons.check_circle, color: WasiColors.success),
                onTap: () => Navigator.of(ctx).pop(),
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Idioma cambiado a English')),
                  );
                },
              ),
              ListTile(
                title: const Text('Quechua'),
                subtitle: const Text('Próximamente'),
                enabled: false,
                onTap: null,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Diálogo para activar el rol propietaria.
  /// Muestra los requisitos y pide confirmación.
  void _showOwnerEnableDialog(BuildContext context, RoleProvider roleProvider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.home_work_outlined, color: WasiColors.primary),
              SizedBox(width: 8),
              Text('Convertirme en propietaria/o'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Para activar tu cuenta de propietaria, debes cumplir:',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                const SizedBox(height: 12),
                _requirementItem('Verificación de identidad (DNI + selfie)'),
                _requirementItem(
                    'Declaración jurada de propiedad o autorización del propietario'),
                _requirementItem(
                    'Aceptar los términos del servicio para propietarios'),
                _requirementItem(
                    'Trust Score ≥ 50 (sin infracciones activas)'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: WasiColors.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: WasiColors.primary, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tu primer cuarto es gratis. Cuartos adicionales: '
                          'S/15/mes cada uno.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: WasiColors.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                roleProvider.enableOwnerRole();
                roleProvider.switchRole(UserRole.owner);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '¡Cuenta de propietaria activada! Bienvenida.',
                    ),
                    backgroundColor: WasiColors.success,
                  ),
                );
              },
              child: const Text('Activar cuenta'),
            ),
          ],
        );
      },
    );
  }

  void _showOwnerDisableDialog(
      BuildContext context, RoleProvider roleProvider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Desactivar cuenta de propietaria'),
          content: const Text(
            'Tus cuartos publicados pasarán a estado "inactivo" y no '
            'recibirás nuevas solicitudes. Tus contratos activos se '
            'mantienen. Puedes reactivar cuando quieras.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: WasiColors.error,
              ),
              onPressed: () {
                roleProvider.disableOwnerRole();
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cuenta de propietaria desactivada.'),
                  ),
                );
              },
              child: const Text('Desactivar'),
            ),
          ],
        );
      },
    );
  }

  Widget _requirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: WasiColors.success,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Settings Section ─────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: WasiColors.textTertiaryLight,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// ── Settings Tile ────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: WasiColors.primaryLight, size: 22),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: WasiColors.textTertiaryLight,
              ),
            )
          : null,
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, size: 18)
          : null,
      onTap: onTap,
      enabled: onTap != null,
    );
  }
}

// ── Settings Switch ──────────────────────────────────────────────────

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: WasiColors.primaryLight, size: 22),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: WasiColors.textTertiaryLight,
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeColor: WasiColors.primary,
    );
  }
}
