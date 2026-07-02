import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Banner que informa sobre la Garantía WasiStudent.
///
/// Es un acuerdo OPCIONAL entre propietario e inquilino que ambas partes
/// firman al contratar. No es obligatorio para listar el cuarto, pero
/// cuando está activo:
///
/// - El estudiante recibe: devolución de gastos de visita si el cuarto
///   no coincide con lo verificado, y asistencia legal gratuita si la
///   propietaria incumple el contrato.
/// - La propietaria recibe: badge "Garantía WasiStudent" visible en
///   su perfil y prioridad en los matchs de estudiantes verificados.
///
/// El banner se muestra de tres formas:
/// - [GuaranteeStatus.active]: el cuarto tiene garantía activa (verde).
/// - [GuaranteeStatus.available]: la propietaria ofrece la garantía pero
///   el estudiante aún no la ha aceptado en su contrato (azul).
/// - [GuaranteeStatus.unavailable]: la propietaria no ofrece garantía
///   en este cuarto (gris informativo, no bloquea).
enum GuaranteeStatus { active, available, unavailable }

class GuaranteeBanner extends StatelessWidget {
  final GuaranteeStatus status;

  /// El estudiante puede aceptar la garantía al firmar el contrato.
  /// Si [status] == available, este callback se invoca al tocar el botón.
  /// Si es null, el banner solo informativo.
  final VoidCallback? onAccept;

  const GuaranteeBanner({
    super.key,
    this.status = GuaranteeStatus.active,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case GuaranteeStatus.active:
        return _buildActive(context);
      case GuaranteeStatus.available:
        return _buildAvailable(context);
      case GuaranteeStatus.unavailable:
        return _buildUnavailable(context);
    }
  }

  Widget _buildActive(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WasiColors.successContainer,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.success.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_outlined,
                color: WasiColors.onSuccessContainer,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Garantía WasiStudent activa',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: WasiColors.onSuccessContainer,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: WasiColors.success,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'OPCIONAL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Este cuarto cuenta con la Garantía WasiStudent, un acuerdo '
            'firmado entre la propietaria y tú. Si el cuarto no coincide '
            'con lo verificado, te devolvemos los gastos de visita y te '
            'asignamos un verificador prioritario. Si la propietaria '
            'incumple el contrato, te damos asistencia legal gratuita.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: WasiColors.onSuccessContainer.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _featureChip(Icons.undo, 'Devolución si no coincide'),
              const SizedBox(width: 6),
              _featureChip(Icons.gavel_outlined, 'Asistencia legal'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailable(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WasiColors.primaryContainer,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: WasiColors.onPrimaryContainer,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Garantía WasiStudent disponible',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: WasiColors.onPrimaryContainer,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: WasiColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'OPCIONAL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'La propietaria ofrece esta garantía opcional. Al firmar tu '
            'contrato, puedes aceptarla sin costo adicional. Si el cuarto '
            'no coincide con lo verificado o la propietaria incumple el '
            'contrato, WasiStudent te respalda.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: WasiColors.onPrimaryContainer.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          if (onAccept != null)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onAccept,
                icon: const Icon(Icons.check, size: 16),
                label: const Text(
                  'Aceptar garantía al firmar',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: WasiColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 6),
          Text(
            'Acuerdo voluntario entre propietario e inquilino. No afecta '
            'el precio del alquiler.',
            style: TextStyle(
              fontSize: 10.5,
              fontStyle: FontStyle.italic,
              color: WasiColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnavailable(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WasiColors.surfaceVariantLight.withValues(alpha: 0.5),
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: WasiColors.textTertiaryLight,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Esta propietaria no ofrece la Garantía WasiStudent. El '
              'contrato sigue teniendo las 5 cláusulas de protección '
              'estudiantil, pero sin el respaldo adicional de '
              'WasiStudent.',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.45,
                color: WasiColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: WasiColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: WasiColors.onSuccessContainer),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: WasiColors.onSuccessContainer,
            ),
          ),
        ],
      ),
    );
  }
}
