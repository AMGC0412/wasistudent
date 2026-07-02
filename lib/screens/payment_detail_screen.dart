import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/payment.dart';
import '../providers/payment_provider.dart';

/// Pantalla de detalle de un pago individual.
/// Muestra badge de estado, monto, fecha de vencimiento, método de pago,
/// número de recibo, información de la habitación y botones de acción
/// (marcar como pagado, descargar recibo placeholder).
class PaymentDetailScreen extends StatelessWidget {
  final String paymentId;

  const PaymentDetailScreen({super.key, required this.paymentId});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();
    final payment = paymentProvider.payments.firstWhere(
      (p) => p.id == paymentId,
      orElse: () => Payment(
        id: paymentId,
        roomId: '',
        roomTitle: 'Habitación',
        ownerId: '',
        ownerName: 'Propietario',
        amount: 0,
        status: PaymentStatus.pending,
        dueDate: DateTime.now(),
        paymentMethod: '',
        month: DateTime.now().month,
        year: DateTime.now().year,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de pago'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status Card ──
            _buildStatusCard(payment),
            const SizedBox(height: 16),

            // ── Amount ──
            _buildAmountSection(payment),
            const SizedBox(height: 20),

            // ── Details ──
            _buildDetailsSection(payment),
            const SizedBox(height: 20),

            // ── Room Info ──
            _buildRoomInfo(payment),
            const SizedBox(height: 20),

            // ── Receipt Info ──
            _buildReceiptSection(payment),
            const SizedBox(height: 28),

            // ── Action Buttons ──
            _buildActionButtons(context, payment),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Status Card ────────────────────────────────────────────────────

  Widget _buildStatusCard(Payment payment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: payment.status == PaymentStatus.overdue
            ? WasiColors.warmGradient
            : payment.status == PaymentStatus.paid
                ? WasiColors.coolGradient
                : LinearGradient(
                    colors: [WasiColors.accent, WasiColors.accentLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
        borderRadius: WasiRadius.card,
        boxShadow: [
          BoxShadow(
            color: payment.statusColor.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            payment.statusIcon,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              payment.statusLabel.toUpperCase(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Amount Section ─────────────────────────────────────────────────

  Widget _buildAmountSection(Payment payment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'MONTO',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: WasiColors.textTertiaryLight,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            payment.formattedAmount,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: payment.statusColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            payment.typeLabel,
            style: const TextStyle(
              fontSize: 14,
              color: WasiColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Details Section ────────────────────────────────────────────────

  Widget _buildDetailsSection(Payment payment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Fecha de vencimiento',
            value: payment.dueDateFormatted,
            valueColor: payment.status == PaymentStatus.overdue
                ? WasiColors.error
                : null,
          ),
          const Divider(height: 20),
          _DetailRow(
            icon: Icons.check_circle_outline,
            label: 'Fecha de pago',
            value: payment.paidDateFormatted,
          ),
          const Divider(height: 20),
          _DetailRow(
            icon: Icons.payment,
            label: 'Método de pago',
            value: payment.paymentMethodLabel,
          ),
          const Divider(height: 20),
          _DetailRow(
            icon: Icons.person_outline,
            label: 'Propietario/a',
            value: payment.ownerName,
          ),
        ],
      ),
    );
  }

  // ── Room Info ──────────────────────────────────────────────────────

  Widget _buildRoomInfo(Payment payment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: WasiColors.primaryContainer,
              borderRadius: BorderRadius.circular(WasiRadius.md),
            ),
            child: const Icon(
              Icons.home_outlined,
              color: WasiColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Habitación',
                  style: TextStyle(
                    fontSize: 11,
                    color: WasiColors.textTertiaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  payment.roomTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Receipt Section ────────────────────────────────────────────────

  Widget _buildReceiptSection(Payment payment) {
    if (payment.receiptNumber == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: WasiColors.surfaceVariantLight,
          borderRadius: WasiRadius.card,
        ),
        child: const Row(
          children: [
            Icon(Icons.receipt_long_outlined, color: WasiColors.textTertiaryLight),
            SizedBox(width: 10),
            Text(
              'El recibo se generará al registrar el pago',
              style: TextStyle(
                fontSize: 13,
                color: WasiColors.textTertiaryLight,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: WasiColors.successContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long,
              size: 20,
              color: WasiColors.successDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recibo',
                  style: TextStyle(
                    fontSize: 12,
                    color: WasiColors.textTertiaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '#${payment.receiptNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: WasiColors.primary,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              // Placeholder download receipt
            },
            icon: const Icon(Icons.download_outlined, size: 16),
            label: const Text('Descargar'),
          ),
        ],
      ),
    );
  }

  // ── Action Buttons ─────────────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context, Payment payment) {
    final canMarkAsPaid = payment.status == PaymentStatus.pending ||
        payment.status == PaymentStatus.overdue;

    return Column(
      children: [
        if (canMarkAsPaid)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _markAsPaid(context, payment),
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: const Text('Marcar como pagado'),
              style: ElevatedButton.styleFrom(
                backgroundColor: WasiColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: WasiRadius.button,
                ),
              ),
            ),
          ),
        if (payment.receiptNumber != null) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Descarga de recibo próximamente')),
                );
              },
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Descargar recibo'),
              style: OutlinedButton.styleFrom(
                foregroundColor: WasiColors.primary,
                side: const BorderSide(color: WasiColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: WasiRadius.button,
                ),
              ),
            ),
          ),
        ],
        if (canMarkAsPaid) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reportar problema próximamente')),
                );
              },
              icon: const Icon(Icons.report_outlined, size: 18),
              label: const Text('Reportar problema'),
              style: OutlinedButton.styleFrom(
                foregroundColor: WasiColors.error,
                side: const BorderSide(color: WasiColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: WasiRadius.button,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── Mark As Paid ───────────────────────────────────────────────────

  void _markAsPaid(BuildContext context, Payment payment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Confirmar pago?'),
        content: Text(
          '¿Deseas marcar el pago de ${payment.formattedAmount} como pagado?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: WasiColors.success,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<PaymentProvider>().markAsPaid(payment.id);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pago registrado exitosamente'),
          backgroundColor: WasiColors.success,
        ),
      );
    }
  }
}

// ── Detail Row ───────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: WasiColors.textTertiaryLight),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: WasiColors.textSecondaryLight,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? WasiColors.textPrimaryLight,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
