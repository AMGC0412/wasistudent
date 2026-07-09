import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Tarjeta de perfil de compañero de cuarto con avatar, % compatibilidad,
/// barras de estilo de vida y botón de contacto.
class RoommateCard extends StatelessWidget {
  final String name;
  final String avatar;
  final int age;
  final String university;
  final String career;
  final double compatibilityScore;
  final int cleanlinessLevel;
  final int socialLevel;
  final int studyLevel;
  final String sleepScheduleLabel;
  final List<String> lifestyleTags;
  final bool isVerified;
  final VoidCallback? onTap;
  final VoidCallback? onContactTap;

  const RoommateCard({
    super.key,
    required this.name,
    required this.avatar,
    required this.age,
    required this.university,
    required this.career,
    required this.compatibilityScore,
    this.cleanlinessLevel = 3,
    this.socialLevel = 3,
    this.studyLevel = 3,
    this.sleepScheduleLabel = '',
    this.lifestyleTags = const [],
    this.isVerified = false,
    this.onTap,
    this.onContactTap,
  });

  Color _compatibilityColor() {
    if (compatibilityScore >= 80) return WasiColors.success;
    if (compatibilityScore >= 60) return WasiColors.primaryLight;
    if (compatibilityScore >= 40) return WasiColors.accent;
    return WasiColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compatColor = _compatibilityColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? WasiColors.outlineDark.withValues(alpha: 0.2)
                : WasiColors.outlineLight.withValues(alpha: 0.4),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Fila superior: avatar, info y compatibilidad
            Row(
              children: [
                // Avatar con indicador de verificación
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: WasiColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        avatar,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: WasiColors.primary,
                        ),
                      ),
                    ),
                    if (isVerified)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: WasiColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Nombre, universidad, carrera
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? WasiColors.textPrimaryDark
                              : WasiColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$age años • ${_shortUni(university)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? WasiColors.textTertiaryDark
                              : WasiColors.textTertiaryLight,
                        ),
                      ),
                      if (career.isNotEmpty)
                        Text(
                          career,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? WasiColors.textSecondaryDark
                                : WasiColors.textSecondaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                // Porcentaje de compatibilidad
                Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: compatColor,
                          width: 2.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${compatibilityScore.round()}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: compatColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Compat.',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? WasiColors.textTertiaryDark
                            : WasiColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Barras de estilo de vida
            _LifestyleBar(
              label: 'Orden',
              value: cleanlinessLevel,
              icon: Icons.cleaning_services_rounded,
              color: WasiColors.success,
            ),
            const SizedBox(height: 8),
            _LifestyleBar(
              label: 'Social',
              value: socialLevel,
              icon: Icons.groups_rounded,
              color: WasiColors.primaryLight,
            ),
            const SizedBox(height: 8),
            _LifestyleBar(
              label: 'Estudio',
              value: studyLevel,
              icon: Icons.menu_book_rounded,
              color: WasiColors.accent,
            ),
            // Horario de sueño
            if (sleepScheduleLabel.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.bedtime_rounded,
                    size: 14,
                    color: isDark
                        ? WasiColors.textTertiaryDark
                        : WasiColors.textTertiaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    sleepScheduleLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? WasiColors.textSecondaryDark
                          : WasiColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
            // Tags de estilo de vida
            if (lifestyleTags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: lifestyleTags.take(4).map((tag) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: WasiColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? WasiColors.primaryLight
                            : WasiColors.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            // Botón de contacto
            if (onContactTap != null)
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton.icon(
                  onPressed: onContactTap,
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text(
                    'Enviar mensaje',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WasiColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _shortUni(String uni) {
    if (uni.contains('Nacional')) return 'UNSAAC';
    if (uni.contains('Andina')) return 'UANDINA';
    if (uni.contains('Católica')) return 'UCSP';
    if (uni.contains('Tecnológica')) return 'UTP';
    return uni;
  }
}

/// Barra indicadora de estilo de vida
class _LifestyleBar extends StatelessWidget {
  final String label;
  final int value; // 1-5
  final IconData icon;
  final Color color;

  const _LifestyleBar({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 6),
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? WasiColors.textSecondaryDark
                  : WasiColors.textSecondaryLight,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Row(
            children: List.generate(5, (i) {
              final filled = i < value;
              return Expanded(
                child: Container(
                  height: 5,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    color: filled
                        ? color
                        : (isDark
                            ? WasiColors.outlineDark.withValues(alpha: 0.2)
                            : WasiColors.outlineLight.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
