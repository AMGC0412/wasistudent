import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Badge de porcentaje de coincidencia con progreso circular pequeño.
/// Coloreado según el nivel de coincidencia.
class MatchingBadge extends StatelessWidget {
  final double percentage;
  final bool compact;

  const MatchingBadge({
    super.key,
    required this.percentage,
    this.compact = false,
  });

  Color _matchColor() {
    if (percentage >= 80) return WasiColors.success;
    if (percentage >= 60) return WasiColors.primaryLight;
    if (percentage >= 40) return WasiColors.accent;
    return WasiColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final color = _matchColor();
    final size = compact ? 28.0 : 36.0;
    final strokeWidth = compact ? 2.5 : 3.0;

    return Container(
      padding: EdgeInsets.all(compact ? 3 : 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: strokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                CircularProgressIndicator(
                  value: (percentage / 100.0).clamp(0.0, 1.0),
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Text(
                  '${percentage.round()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 7 : 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              'Match',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
