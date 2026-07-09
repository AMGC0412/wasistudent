import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../utils/format_helpers.dart';

/// Resumen de ingresos de la propietaria.
///
/// Muestra:
/// - Total recibido este mes.
/// - Próximos cobros (próximos 7 días).
/// - Historial de pagos por mes.
/// - Suscripción WasiStudent (primer cuarto gratis, S/15/mes por adicionales).
class OwnerPaymentsScreen extends StatelessWidget {
  const OwnerPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock de pagos recibidos
    final payments = [
      _MockPayment(
        studentName: 'María Quispe',
        amount: 280,
        date: DateTime(2025, 6, 5),
        method: 'Yape',
        status: _PaymentStatus.paid,
      ),
      _MockPayment(
        studentName: 'Lucía Fernández',
        amount: 220,
        date: DateTime(2025, 6, 10),
        method: 'Plin',
        status: _PaymentStatus.paid,
      ),
      _MockPayment(
        studentName: 'María Quispe (próximo)',
        amount: 280,
        date: DateTime(2025, 7, 5),
        method: 'Pendiente',
        status: _PaymentStatus.pending,
      ),
    ];

    final totalReceived =
        payments.where((p) => p.status == _PaymentStatus.paid).fold<double>(
              0,
              (sum, p) => sum + p.amount,
            );

    return Scaffold(
      appBar: AppBar(title: const Text('Ingresos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card de total recibido
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [WasiColors.success, Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recibido en junio 2025',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'S/ ${totalReceived.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '2 pagos recibidos · 1 pendiente',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Suscripción
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: WasiColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: WasiColors.onPrimaryContainer),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Suscripción WasiStudent',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: WasiColors.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        'Primer cuarto gratis · 1 adicional × S/15 = S/15/mes',
                        style: TextStyle(
                          fontSize: 11,
                          color: WasiColors.onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'S/ 15/mes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: WasiColors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Historial
          Text(
            'Historial de pagos',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: WasiColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 10),
          ...payments.map((p) => _PaymentTile(payment: p)),
        ],
      ),
    );
  }
}

enum _PaymentStatus { paid, pending }

class _MockPayment {
  final String studentName;
  final double amount;
  final DateTime date;
  final String method;
  final _PaymentStatus status;

  const _MockPayment({
    required this.studentName,
    required this.amount,
    required this.date,
    required this.method,
    required this.status,
  });
}

class _PaymentTile extends StatelessWidget {
  final _MockPayment payment;
  const _PaymentTile({required this.payment});

  @override
  Widget build(BuildContext context) {
    final isPaid = payment.status == _PaymentStatus.paid;
    final color = isPaid ? WasiColors.success : WasiColors.accent;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPaid ? Icons.check_circle : Icons.access_time,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.studentName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: WasiColors.textPrimaryLight,
                  ),
                ),
                Text(
                  '${payment.date.day}/${payment.date.month}/2025 · ${payment.method}',
                  style: TextStyle(
                    fontSize: 11,
                    color: WasiColors.textTertiaryLight,
                  ),
                ),
              ],
            ),
          ),
          Text(
            F.price(payment.amount),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
