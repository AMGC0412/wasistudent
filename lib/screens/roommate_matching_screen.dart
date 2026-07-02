import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/roommate_profile.dart';

/// Pantalla de compatibilidad de compañeros de cuarto.
/// Muestra tarjetas de perfil con porcentaje de compatibilidad,
/// comparación de estilo de vida (limpieza, socialidad, estudio, sueño),
/// botón de contacto. Filtro por universidad. Estado vacío.
class RoommateMatchingScreen extends StatefulWidget {
  const RoommateMatchingScreen({super.key});

  @override
  State<RoommateMatchingScreen> createState() => _RoommateMatchingScreenState();
}

class _RoommateMatchingScreenState extends State<RoommateMatchingScreen> {
  String _universityFilter = '';
  List<RoommateProfile> _profiles = [];

  @override
  void initState() {
    super.initState();
    _profiles = RoommateProfile.mockProfiles();
  }

  List<RoommateProfile> get _filteredProfiles {
    if (_universityFilter.isEmpty) return _profiles;
    return _profiles
        .where((p) =>
            p.university.toLowerCase().contains(_universityFilter.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final profiles = _filteredProfiles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compañeros'),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: Icon(
              Icons.filter_list,
              color: _universityFilter.isNotEmpty ? WasiColors.accent : null,
            ),
          ),
        ],
      ),
      body: profiles.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                return _RoommateCard(
                  profile: profiles[index],
                  onContact: () => _contactProfile(profiles[index]),
                );
              },
            ),
    );
  }

  // ── Filter Dialog ──────────────────────────────────────────────────

  void _showFilterDialog() {
    final universities = <String>{};
    for (final p in _profiles) {
      universities.add(p.universityShort);
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtrar por universidad',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Todas'),
                        selected: _universityFilter.isEmpty,
                        onSelected: (_) {
                          setState(() => _universityFilter = '');
                          Navigator.of(ctx).pop();
                        },
                      ),
                      ...universities.map((uni) {
                        final isSelected = _universityFilter.toLowerCase() ==
                            uni.toLowerCase();
                        return ChoiceChip(
                          label: Text(uni),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _universityFilter = isSelected ? '' : uni;
                            });
                            Navigator.of(ctx).pop();
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Empty State ────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: WasiColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline,
                size: 48,
                color: WasiColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sin coincidencias',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No encontramos compañeros para este filtro. Prueba con otra universidad.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: WasiColors.textSecondaryLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() => _universityFilter = '');
              },
              child: const Text('Limpiar filtro'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Contact ────────────────────────────────────────────────────────

  void _contactProfile(RoommateProfile profile) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contactar a ${profile.name} próximamente'),
      ),
    );
  }
}

// ── Roommate Card ────────────────────────────────────────────────────

class _RoommateCard extends StatelessWidget {
  final RoommateProfile profile;
  final VoidCallback onContact;

  const _RoommateCard({
    required this.profile,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row ──
          _buildHeader(),
          const SizedBox(height: 12),

          // ── Bio ──
          if (profile.bio.isNotEmpty) ...[
            Text(
              profile.bio,
              style: const TextStyle(
                fontSize: 13,
                color: WasiColors.textSecondaryLight,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
          ],

          // ── Lifestyle Comparison ──
          _buildLifestyleComparison(),
          const SizedBox(height: 12),

          // ── Tags ──
          if (profile.lifestyleTags.isNotEmpty) ...[
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: profile.lifestyleTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: WasiColors.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: WasiColors.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // ── Bottom Info & Contact ──
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 28,
          backgroundColor: WasiColors.primaryContainer,
          child: Text(
            profile.avatar,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: WasiColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (profile.isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: WasiColors.success,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${profile.universityShort} • ${profile.career}',
                style: const TextStyle(
                  fontSize: 12,
                  color: WasiColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${profile.age} años • ${profile.budgetRange} • ${profile.primaryDistrict}',
                style: const TextStyle(
                  fontSize: 11,
                  color: WasiColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ),

        // ── Compatibility Badge ──
        _CompatibilityBadge(score: profile.compatibilityScore),
      ],
    );
  }

  Widget _buildLifestyleComparison() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WasiColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(WasiRadius.md),
      ),
      child: Column(
        children: [
          _LifestyleBar(
            label: 'Limpieza',
            icon: Icons.cleaning_services_outlined,
            value: profile.cleanlinessLevel,
            valueLabel: profile.cleanlinessLabel,
          ),
          const SizedBox(height: 8),
          _LifestyleBar(
            label: 'Social',
            icon: Icons.groups_outlined,
            value: profile.socialLevel,
            valueLabel: profile.socialLabel,
          ),
          const SizedBox(height: 8),
          _LifestyleBar(
            label: 'Estudio',
            icon: Icons.menu_book_outlined,
            value: profile.studyLevel,
            valueLabel: profile.studyLabel,
          ),
          const SizedBox(height: 8),
          _LifestyleBar(
            label: 'Sueño',
            icon: Icons.bedtime_outlined,
            value: _sleepToLevel(profile.sleepSchedule),
            valueLabel: profile.sleepScheduleShort,
          ),
        ],
      ),
    );
  }

  int _sleepToLevel(SleepSchedule schedule) {
    switch (schedule) {
      case SleepSchedule.early:
        return 5;
      case SleepSchedule.normal:
        return 4;
      case SleepSchedule.late:
        return 2;
      case SleepSchedule.nightOwl:
        return 1;
    }
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            profile.compatibilityLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _compatibilityColor(profile.compatibilityScore),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: onContact,
          icon: const Icon(Icons.chat_bubble_outline, size: 16),
          label: const Text('Contactar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: WasiColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: WasiRadius.button,
            ),
          ),
        ),
      ],
    );
  }

  Color _compatibilityColor(double score) {
    if (score >= 85) return WasiColors.success;
    if (score >= 70) return WasiColors.primary;
    if (score >= 50) return WasiColors.accent;
    return WasiColors.error;
  }
}

// ── Compatibility Badge ──────────────────────────────────────────────

class _CompatibilityBadge extends StatelessWidget {
  final double score;

  const _CompatibilityBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            '${score.round()}%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const Text(
            'Match',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: WasiColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Color get _color {
    if (score >= 85) return WasiColors.success;
    if (score >= 70) return WasiColors.primary;
    if (score >= 50) return WasiColors.accent;
    return WasiColors.error;
  }
}

// ── Lifestyle Bar ────────────────────────────────────────────────────

class _LifestyleBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final String valueLabel;

  const _LifestyleBar({
    required this.label,
    required this.icon,
    required this.value,
    required this.valueLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: WasiColors.textTertiaryLight),
        const SizedBox(width: 4),
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: WasiColors.textSecondaryLight,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value / 5,
              backgroundColor: WasiColors.outlineLight.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                value >= 4 ? WasiColors.success
                    : value >= 3 ? WasiColors.accent
                    : WasiColors.error,
              ),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 60,
          child: Text(
            valueLabel,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 10,
              color: WasiColors.textTertiaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
