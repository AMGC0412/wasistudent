import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Badge de verificación: pill con icono y texto.
/// Nivel 0 = oculto, 1 = Verificado (azul), 2 = Visitado (verde), 3 = Premium (dorado).
class VerifiedBadge extends StatelessWidget {
  final int level;
  final bool compact;

  const VerifiedBadge({
    super.key,
    required this.level,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (level == 0) return const SizedBox.shrink();

    final data = _badgeData();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: data.backgroundColor,
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
        border: Border.all(
          color: data.borderColor.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            data.icon,
            size: compact ? 10 : 13,
            color: data.textColor,
          ),
          if (!compact) const SizedBox(width: 3),
          if (!compact)
            Text(
              data.label,
              style: TextStyle(
                color: data.textColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
        ],
      ),
    );
  }

  _BadgeData _badgeData() {
    switch (level) {
      case 1:
        return _BadgeData(
          label: 'Verificado',
          icon: Icons.verified_rounded,
          backgroundColor: const Color(0xFF1976D2).withValues(alpha: 0.12),
          textColor: const Color(0xFF1565C0),
          borderColor: const Color(0xFF1976D2),
        );
      case 2:
        return _BadgeData(
          label: 'Verificado en persona',
          icon: Icons.check_circle_rounded,
          backgroundColor: WasiColors.successContainer,
          textColor: WasiColors.onSuccessContainer,
          borderColor: WasiColors.success,
        );
      case 3:
        return _BadgeData(
          label: 'Premium',
          icon: Icons.workspace_premium_rounded,
          backgroundColor: WasiColors.secondaryContainer,
          textColor: WasiColors.onSecondaryContainer,
          borderColor: WasiColors.accent,
        );
      default:
        return _BadgeData(
          label: '',
          icon: Icons.verified_rounded,
          backgroundColor: Colors.transparent,
          textColor: Colors.transparent,
          borderColor: Colors.transparent,
        );
    }
  }
}

class _BadgeData {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const _BadgeData({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });
}
