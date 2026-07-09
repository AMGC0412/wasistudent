import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Badge de "Garantía WasiStudent".
///
/// Indica visualmente si un cuarto tiene la garantía activa. Es la
/// versión compacta del `GuaranteeBanner` para usarse en listas y
/// tarjetas pequeñas.
///
/// Estados:
/// - [GuaranteeBadgeStatus.active]: garantía activa (verde).
/// - [GuaranteeBadgeStatus.available]: disponible, no aceptada (azul).
/// - [GuaranteeBadgeStatus.unavailable]: no ofrecida (no se muestra).
enum GuaranteeBadgeStatus { active, available, unavailable }

class GuaranteeBadge extends StatelessWidget {
  final GuaranteeBadgeStatus status;
  final bool compact;

  const GuaranteeBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (status == GuaranteeBadgeStatus.unavailable) {
      return const SizedBox.shrink();
    }

    final isActive = status == GuaranteeBadgeStatus.active;
    final color = isActive ? WasiColors.success : WasiColors.primary;
    final bgColor = isActive
        ? WasiColors.successContainer
        : WasiColors.primaryContainer;
    final fgColor = isActive
        ? WasiColors.onSuccessContainer
        : WasiColors.onPrimaryContainer;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(compact ? 5 : 7),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 0.6,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.verified_outlined : Icons.shield_outlined,
            size: compact ? 10 : 13,
            color: fgColor,
          ),
          if (!compact) const SizedBox(width: 4),
          if (!compact)
            Text(
              isActive ? 'Garantía WasiStudent' : 'Garantía disponible',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: fgColor,
                letterSpacing: 0.2,
              ),
            ),
        ],
      ),
    );
  }
}
