import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../utils/format_helpers.dart';

/// Lista de contratos activos e históricos de la propietaria.
///
/// Cascarón mockup con contratos mock.
class OwnerContractsScreen extends StatelessWidget {
  const OwnerContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contracts = [
      _MockContract(
        studentName: 'María Quispe Mamani',
        roomTitle: 'Cuarto individual en Urb. Ttiobamba',
        monthlyRent: 280,
        startDate: DateTime(2025, 4, 1),
        endDate: DateTime(2025, 10, 1),
        status: _ContractStatus.active,
      ),
      _MockContract(
        studentName: 'Carlos Espinoza',
        roomTitle: 'Cuarto en San Jerónimo',
        monthlyRent: 250,
        startDate: DateTime(2024, 9, 1),
        endDate: DateTime(2025, 3, 1),
        status: _ContractStatus.completed,
      ),
      _MockContract(
        studentName: 'Lucía Fernández',
        roomTitle: 'Cuarto compartido (2 personas) en Av. de la Cultura',
        monthlyRent: 220,
        startDate: DateTime(2025, 3, 15),
        endDate: DateTime(2025, 9, 15),
        status: _ContractStatus.active,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Contratos')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contracts.length,
        itemBuilder: (context, index) =>
            _ContractCard(contract: contracts[index]),
      ),
    );
  }
}

enum _ContractStatus { active, completed, pending }

class _MockContract {
  final String studentName;
  final String roomTitle;
  final double monthlyRent;
  final DateTime startDate;
  final DateTime endDate;
  final _ContractStatus status;

  const _MockContract({
    required this.studentName,
    required this.roomTitle,
    required this.monthlyRent,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}

class _ContractCard extends StatelessWidget {
  final _MockContract contract;
  const _ContractCard({required this.contract});

  Color _statusColor() {
    switch (contract.status) {
      case _ContractStatus.active:
        return WasiColors.success;
      case _ContractStatus.completed:
        return WasiColors.textTertiaryLight;
      case _ContractStatus.pending:
        return WasiColors.accent;
    }
  }

  String _statusLabel() {
    switch (contract.status) {
      case _ContractStatus.active:
        return 'Activo';
      case _ContractStatus.completed:
        return 'Completado';
      case _ContractStatus.pending:
        return 'Pendiente firma';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  contract.studentName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: WasiColors.textPrimaryLight,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statusLabel(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            contract.roomTitle,
            style: TextStyle(
              fontSize: 11.5,
              color: WasiColors.textTertiaryLight,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoChip(
                Icons.calendar_today_outlined,
                '${contract.startDate.day}/${contract.startDate.month} → ${contract.endDate.day}/${contract.endDate.month}',
              ),
              _infoChip(
                Icons.payments_outlined,
                F.pricePerMonth(contract.monthlyRent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: WasiColors.textSecondaryLight),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: WasiColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
