import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Badge de tiempo a pie: icono + minutos. Verde si es cercano, gris si es lejos.
class WalkingTimeBadge extends StatelessWidget {
  final int minutes;
  final bool compact;

  const WalkingTimeBadge({
    super.key,
    required this.minutes,
    this.compact = false,
  });

  bool get _isClose => minutes <= 15;

  Color _badgeColor() => _isClose ? WasiColors.success : WasiColors.textTertiaryLight;

  Color _backgroundColor(bool isDark) {
    if (_isClose) {
      return WasiColors.successContainer;
    }
    return (isDark ? WasiColors.surfaceVariantDark : WasiColors.surfaceVariantLight)
        .withValues(alpha: 0.7);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _badgeColor();
    final bgColor = _backgroundColor(isDark);

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_walk_rounded,
              size: 10,
              color: color,
            ),
            const SizedBox(width: 2),
            Text(
              '$minutes min',
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_walk_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$minutes min',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
