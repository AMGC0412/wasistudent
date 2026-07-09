import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Tarjeta de pago con estado, monto, fecha de vencimiento y acción.
class PaymentCard extends StatelessWidget {
  final double amount;
  final String statusLabel;
  final Color statusColor;
  final IconData statusIcon;
  final String dueDate;
  final String periodLabel;
  final String roomTitle;
  final String? description;
  final bool isDueSoon;
  final VoidCallback? onActionTap;
  final String? actionLabel;

  const PaymentCard({
    super.key,
    required this.amount,
    required this.statusLabel,
    required this.statusColor,
    required this.statusIcon,
    required this.dueDate,
    required this.periodLabel,
    required this.roomTitle,
    this.description,
    this.isDueSoon = false,
    this.onActionTap,
    this.actionLabel,
  });

  factory PaymentCard.fromStatus({
    required double amount,
    required String statusLabel,
    required Color statusColor,
    required IconData statusIcon,
    required String dueDate,
    required String periodLabel,
    required String roomTitle,
    String? description,
    bool isDueSoon = false,
    VoidCallback? onActionTap,
  }) {
    return PaymentCard(
      amount: amount,
      statusLabel: statusLabel,
      statusColor: statusColor,
      statusIcon: statusIcon,
      dueDate: dueDate,
      periodLabel: periodLabel,
      roomTitle: roomTitle,
      description: description,
      isDueSoon: isDueSoon,
      onActionTap: onActionTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDueSoon
              ? WasiColors.accent.withValues(alpha: 0.4)
              : isDark
                  ? WasiColors.outlineDark.withValues(alpha: 0.2)
                  : WasiColors.outlineLight.withValues(alpha: 0.4),
          width: isDueSoon ? 1.2 : 0.5,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: período y estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                periodLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? WasiColors.textSecondaryDark
                      : WasiColors.textSecondaryLight,
                ),
              ),
              _buildStatusBadge(isDark),
            ],
          ),
          const SizedBox(height: 8),
          // Título de la habitación
          Text(
            roomTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? WasiColors.textPrimaryDark
                  : WasiColors.textPrimaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? WasiColors.textTertiaryDark
                    : WasiColors.textTertiaryLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          // Monto y fecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'S/ ${amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? WasiColors.textPrimaryDark
                          : WasiColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Vence: $dueDate',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDueSoon
                          ? WasiColors.accentDark
                          : isDark
                              ? WasiColors.textTertiaryDark
                              : WasiColors.textTertiaryLight,
                      fontWeight: isDueSoon ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
              // Botón de acción
              if (onActionTap != null)
                GestureDetector(
                  onTap: onActionTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      actionLabel ?? 'Pagar',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 12, color: statusColor),
          const SizedBox(width: 4),
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
