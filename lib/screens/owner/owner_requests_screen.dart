import 'package:flutter/material.dart';

import '../../config/theme.dart';

/// Solicitudes recibidas por la propietaria.
///
/// Cada solicitud muestra:
/// - Foto/iniciales del estudiante.
/// - Nombre y universidad.
/// - Trust Score del estudiante.
/// - Mensaje breve que envió.
/// - Botones: Aceptar / Rechazar / Ver perfil completo.
///
/// En este mockup, las solicitudes son mock con datos de estudiantes
/// del documento (E7 Enfermería, E2 La Convención, etc.).
class OwnerRequestsScreen extends StatelessWidget {
  const OwnerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data de solicitudes
    final requests = [
      _MockRequest(
        studentName: 'María Quispe Mamani',
        initials: 'MQ',
        university: 'UNSAAC — Enfermería, 3er ciclo',
        trustScore: 78,
        message: 'Hola doña Rosa, vi tu cuarto en Ttiobamba y me '
            'interesa. Vengo de Quillabamba en marzo. ¿Puedo visitarlo '
            'el sábado?',
        date: 'Hace 2 horas',
        roomTitle: 'Cuarto individual en Urb. Ttiobamba',
      ),
      _MockRequest(
        studentName: 'José Luis Cáceres',
        initials: 'JC',
        university: 'UAC — Derecho, 5to ciclo',
        trustScore: 85,
        message: 'Buenas tardes, soy estudiante de la Andina y busco '
            'cuarto cerca al centro. ¿Aún está disponible?',
        date: 'Hace 5 horas',
        roomTitle: 'Cuarto en San Jerónimo',
      ),
      _MockRequest(
        studentName: 'Ana Lucía Romero',
        initials: 'AR',
        university: 'Continental Cusco — Psicología, 2do ciclo',
        trustScore: 65,
        message: 'Hola, me gustaría más info sobre el cuarto. ¿El '
            'precio incluye servicios? ¿Tiene baño propio?',
        date: 'Hace 1 día',
        roomTitle: 'Cuarto compartido (2 personas) en Av. de la Cultura',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes recibidas'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return _RequestCard(request: requests[index]);
        },
      ),
    );
  }
}

class _MockRequest {
  final String studentName;
  final String initials;
  final String university;
  final int trustScore;
  final String message;
  final String date;
  final String roomTitle;

  const _MockRequest({
    required this.studentName,
    required this.initials,
    required this.university,
    required this.trustScore,
    required this.message,
    required this.date,
    required this.roomTitle,
  });
}

class _RequestCard extends StatelessWidget {
  final _MockRequest request;

  const _RequestCard({required this.request});

  Color _trustColor() {
    if (request.trustScore >= 80) return WasiColors.success;
    if (request.trustScore >= 60) return WasiColors.accent;
    return WasiColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final trustColor = _trustColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: estudiante + trust
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: WasiColors.primaryContainer,
                child: Text(
                  request.initials,
                  style: const TextStyle(
                    color: WasiColors.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.studentName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: WasiColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      request.university,
                      style: TextStyle(
                        fontSize: 11,
                        color: WasiColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Trust score badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trustColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: trustColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_outlined, size: 12, color: trustColor),
                    const SizedBox(width: 4),
                    Text(
                      '${request.trustScore}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: trustColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Cuarto solicitado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: WasiColors.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.home_work_outlined,
                  size: 14,
                  color: WasiColors.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    request.roomTitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: WasiColors.primary,
                    ),
                  ),
                ),
                Text(
                  request.date,
                  style: TextStyle(
                    fontSize: 10,
                    color: WasiColors.textTertiaryLight,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Mensaje
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: WasiColors.surfaceVariantLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '"${request.message}"',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: WasiColors.textSecondaryLight,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Acciones
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Solicitud rechazada (mockup)'),
                        backgroundColor: WasiColors.error,
                      ),
                    );
                  },
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Rechazar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: WasiColors.error,
                    side: BorderSide(color: WasiColors.error.withValues(alpha: 0.4)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Solicitud aceptada. Chat iniciado.'),
                        backgroundColor: WasiColors.success,
                      ),
                    );
                  },
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Aceptar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: WasiColors.success,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
