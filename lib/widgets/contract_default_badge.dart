import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Badge de propietario incumplidor.
///
/// Se muestra en el perfil del propietario cuando ha incumplido un
/// contrato WasiStudent con un estudiante anterior. Es un indicador
/// negativo de reputación que afecta el ranking en los matchs.
///
/// Causas por las que se muestra:
/// - Subió el precio unilateralmente (violó cláusula 1).
/// - Solicitó desalojo antes de los 6 meses mínimos (violó cláusula 2).
/// - No devolvió el depósito en 15 días (violó cláusula 3).
/// - Cobró servicios adicionales no declarados (violó cláusula 4).
/// - No respetó el preaviso de 30 días (violó cláusula 5).
///
/// El badge es visible para futuros estudiantes en el detalle del cuarto
/// y en el perfil de la propietaria. La propietaria puede limpiarlo
/// después de 12 meses sin nuevas infracciones.
enum ContractDefaultType {
  priceIncrease,
  earlyEviction,
  depositWithheld,
  hiddenServiceFees,
  noNotice,
  other,
}

class ContractDefaultBadge extends StatelessWidget {
  final ContractDefaultType defaultType;
  final DateTime? incidentDate;
  final bool compact;

  const ContractDefaultBadge({
    super.key,
    required this.defaultType,
    this.incidentDate,
    this.compact = false,
  });

  String get _label {
    switch (defaultType) {
      case ContractDefaultType.priceIncrease:
        return 'Subió precio sin aviso';
      case ContractDefaultType.earlyEviction:
        return 'Desalojo anticipado';
      case ContractDefaultType.depositWithheld:
        return 'Retuvo depósito';
      case ContractDefaultType.hiddenServiceFees:
        return 'Cobró servicios extra';
      case ContractDefaultType.noNotice:
        return 'Sin preaviso 30 días';
      case ContractDefaultType.other:
        return 'Incumplió contrato';
    }
  }

  String get _tooltip {
    final base = 'Incumplimiento registrado'
        '${incidentDate != null ? ' el ${_formatDate(incidentDate!)}' : ''}.';
    return '$base ${_label}. Este indicador afecta el ranking de la '
        'propietaria en los matchs. Se elimina después de 12 meses sin '
        'nuevas infracciones.';
  }

  String _formatDate(DateTime date) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _tooltip,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 10,
          vertical: compact ? 3 : 5,
        ),
        decoration: BoxDecoration(
          color: WasiColors.errorContainer,
          borderRadius: BorderRadius.circular(compact ? 6 : 8),
          border: Border.all(
            color: WasiColors.error.withValues(alpha: 0.4),
            width: 0.6,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: compact ? 11 : 14,
              color: WasiColors.onErrorContainer,
            ),
            if (!compact) const SizedBox(width: 5),
            if (!compact)
              Text(
                _label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: WasiColors.onErrorContainer,
                  letterSpacing: 0.2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
