import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Widget de estado vacío reutilizable con icono/emoji, título,
/// subtítulo y botón de acción.
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? emoji;
  final String actionLabel;
  final VoidCallback? onAction;
  final Color? accentColor;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.emoji,
    this.actionLabel = '',
    this.onAction,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = accentColor ?? WasiColors.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono o emoji
            if (emoji != null)
              Text(
                emoji!,
                style: const TextStyle(fontSize: 56),
              )
            else if (icon != null)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.12 : 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: color,
                ),
              ),
            const SizedBox(height: 20),
            // Título
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? WasiColors.textPrimaryDark
                    : WasiColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            // Subtítulo
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark
                    ? WasiColors.textTertiaryDark
                    : WasiColors.textTertiaryLight,
              ),
            ),
            // Botón de acción
            if (onAction != null && actionLabel.isNotEmpty) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
