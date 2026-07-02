import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Badge "Comprometido con estudiantes".
///
/// Se otorga a propietarias que se comprometen a vivienda estudiantil
/// por al menos 2 ciclos académicos consecutivos (10 meses). Es un
/// indicador visual de que la propietaria prioriza estudiantes estables
/// y mantiene un buen historial de cumplimiento de contratos.
///
/// Las propietarias con este badge aparecen primero en los matchs
/// de los estudiantes. Se pierde si la propietaria:
/// - Incumple cualquiera de las 5 cláusulas del contrato WasiStudent.
/// - Recibe 2+ reseñas negativas consecutivas en menos de 6 meses.
/// - No renueva su verificación en persona anual.
///
/// El badge es voluntario: la propietaria lo solicita después de
/// completar 2 ciclos exitosos, y se otorga automáticamente cuando
/// su Trust Score supera 80 y tiene 0 infracciones.
class CommittedToStudentsBadge extends StatelessWidget {
  /// Número de ciclos consecutivos con vivienda estudiantil.
  /// Si es null, solo muestra el badge sin detalle.
  final int? consecutiveCycles;

  /// Tamaño compacto para tarjetas de lista.
  final bool compact;

  const CommittedToStudentsBadge({
    super.key,
    this.consecutiveCycles,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: WasiColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
        border: Border.all(
          color: WasiColors.primary.withValues(alpha: 0.4),
          width: 0.6,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school_rounded,
            size: compact ? 11 : 14,
            color: WasiColors.primary,
          ),
          if (!compact) const SizedBox(width: 5),
          if (!compact)
            Text(
              consecutiveCycles != null
                  ? 'Comprometido · $consecutiveCycles ciclos'
                  : 'Comprometido con estudiantes',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: WasiColors.primary,
                letterSpacing: 0.2,
              ),
            ),
        ],
      ),
    );
  }
}
