import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/trust_score.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'edit_profile_screen.dart';
import 'trust_score_screen.dart';

/// Pantalla de perfil del usuario.
/// Incluye header con avatar+TrustRing, fila de estadísticas,
/// menú agrupado por sección, logros y cierre de sesión.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No hay usuario autenticado')),
      );
    }

    final trustModel = TrustScoreModel.mock(); // Mock for UI

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        actions: [
          IconButton(
            onPressed: () => _navigateToEdit(context, user),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, user, trustModel),
            const SizedBox(height: 16),
            _buildStatsRow(user),
            const SizedBox(height: 20),
            _buildAchievementsRow(context, user),
            const SizedBox(height: 20),
            _buildMenuSections(context, user),
            const SizedBox(height: 16),
            _buildLogoutButton(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Profile Header ────────────────────────────────────────────────

  Widget _buildProfileHeader(
    BuildContext context,
    User user,
    TrustScoreModel trustModel,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Column(
        children: [
          // Avatar + TrustRing
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    startAngle: 0.0,
                    endAngle: 6.28,
                    colors: [
                      trustModel.levelColor,
                      trustModel.levelColor.withValues(alpha: 0.3),
                      trustModel.levelColor,
                      trustModel.levelColor.withValues(alpha: 0.3),
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75],
                  ),
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: WasiColors.primaryContainer,
                  child: Text(
                    user.avatar,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: WasiColors.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              // Trust badge
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: trustModel.levelColor,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: WasiColors.surfaceLight,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Icon(
                    trustModel.levelIcon,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${user.universityShort} • ${user.career}',
            style: const TextStyle(
              fontSize: 14,
              color: WasiColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _navigateToTrustScore(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: trustModel.levelColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 14,
                    color: trustModel.levelColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${user.trustScore}% confianza • ${trustModel.levelName}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: trustModel.levelColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (user.bio.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                user.bio,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: WasiColors.textSecondaryLight,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────────

  Widget _buildStatsRow(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: WasiColors.surfaceLight,
          borderRadius: WasiRadius.card,
          border: Border.all(
            color: WasiColors.outlineLight.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            _StatItem(
              icon: Icons.calendar_today_outlined,
              value: '${user.memberSince.year}',
              label: 'Miembro desde',
            ),
            _StatItem(
              icon: Icons.verified_user_outlined,
              value: '${user.verificationLevel}/3',
              label: 'Verificación',
            ),
            _StatItem(
              icon: Icons.star_outline,
              value: '${user.trustScore}%',
              label: 'Confianza',
            ),
            _StatItem(
              icon: Icons.access_time,
              value: user.lastActiveFormatted,
              label: 'Última vez',
            ),
          ],
        ),
      ),
    );
  }

  // ── Achievements Row ──────────────────────────────────────────────

  Widget _buildAchievementsRow(BuildContext context, User user) {
    final achievements = [
      _Achievement(icon: Icons.school, label: '${user.semester}° ciclo'),
      _Achievement(icon: Icons.place, label: user.preferredDistrict ?? '—'),
      _Achievement(icon: Icons.payments, label: user.budgetFormatted),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Logros',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Row(
            children: achievements.map((ach) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: WasiColors.accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(ach.icon, size: 20, color: WasiColors.accentDark),
                      const SizedBox(height: 4),
                      Text(
                        ach.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: WasiColors.textSecondaryLight,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Menu Sections ─────────────────────────────────────────────────

  Widget _buildMenuSections(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _MenuSection(
            title: 'Cuenta',
            items: [
              _MenuItem(
                icon: Icons.person_outline,
                title: 'Editar perfil',
                onTap: () => _navigateToEdit(context, user),
              ),
              _MenuItem(
                icon: Icons.shield_outlined,
                title: 'Puntuación de confianza',
                subtitle: '${user.trustScore}% • Nivel ${_verLevel(user.verificationLevel)}',
                onTap: () => _navigateToTrustScore(context),
              ),
              _MenuItem(
                icon: Icons.lock_outline,
                title: 'Cambiar contraseña',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad próximamente')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MenuSection(
            title: 'Preferencias',
            items: [
              _MenuItem(
                icon: Icons.tune,
                title: 'Preferencias de búsqueda',
                subtitle: 'Configura tus filtros y prioridades',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navega a Preferencias')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notificaciones',
                subtitle: 'Push, email y SMS',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad próximamente')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.dark_mode_outlined,
                title: 'Tema de la app',
                subtitle: 'Claro / Oscuro / Automático',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad próximamente')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MenuSection(
            title: 'Soporte',
            items: [
              _MenuItem(
                icon: Icons.help_outline,
                title: 'Centro de ayuda',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad próximamente')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.description_outlined,
                title: 'Términos y condiciones',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad próximamente')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Política de privacidad',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad próximamente')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Logout Button ─────────────────────────────────────────────────

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout, size: 18),
          label: const Text('Cerrar sesión'),
          style: OutlinedButton.styleFrom(
            foregroundColor: WasiColors.error,
            side: const BorderSide(color: WasiColors.error),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────

  String _verLevel(int level) {
    switch (level) {
      case 0:
        return 'Inicial';
      case 1:
        return 'Básico';
      case 2:
        return 'Verificado';
      case 3:
        return 'Premium';
      default:
        return 'Desconocido';
    }
  }

  void _navigateToEdit(BuildContext context, User user) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
  }

  void _navigateToTrustScore(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TrustScoreScreen(trustScore: TrustScoreModel.mock()),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text(
          'Se cerrará tu sesión y tendrás que iniciar sesión de nuevo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: WasiColors.error,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
    }
  }
}

// ── Stat Item ───────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: WasiColors.primaryLight),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: WasiColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Achievement ─────────────────────────────────────────────────────

class _Achievement {
  final IconData icon;
  final String label;

  const _Achievement({required this.icon, required this.label});
}

// ── Menu Section ────────────────────────────────────────────────────

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

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
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: WasiColors.textTertiaryLight,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}

// ── Menu Item ───────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
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
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }
}
