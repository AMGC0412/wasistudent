import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';

/// Pantalla de flujo de contrato en 3 pasos:
/// 1. Datos personales
/// 2. Cláusulas del contrato (Código Civil Peruano)
/// 3. Firma
class ContractFlowScreen extends StatefulWidget {
  final String roomId;

  const ContractFlowScreen({super.key, required this.roomId});

  @override
  State<ContractFlowScreen> createState() => _ContractFlowScreenState();
}

class _ContractFlowScreenState extends State<ContractFlowScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Step 1 fields
  final _nameController = TextEditingController();
  final _dniController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  // Step 2
  final List<bool> _acceptedClauses = List.filled(5, false);

  // Step 3
  bool _signatureConfirmed = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Listeners para que el botón "Siguiente" se habilite automáticamente
    // cuando el usuario escribe en los campos.
    _nameController.addListener(_onFieldChanged);
    _dniController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _addressController.addListener(_onFieldChanged);

    // Pre-llenar con datos del usuario actual (si existe).
    // Se hace en initState, no en build, para evitar setState durante build.
    // Usar WidgetsBinding para acceder al Provider después del primer frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
      }
    });
  }

  void _onFieldChanged() {
    // Llama setState para que _canProceed se reevalúe y el botón se actualice.
    if (mounted) setState(() {});
  }

  // ── Cláusulas de protección estudiantil (innegociables) ─────────────
  //
  // Las 5 cláusulas siguientes son el escudo del estudiante cusqueño y están
  // presentes en TODOS los contratos WasiStudent, alineadas a:
  //   - Código Civil peruano (Libro VII, Sección Tercera, Arrendamiento)
  //   - Ley N° 30201 (Promoción de la inversión privada en vivienda de alquiler)
  //   - Ley N° 29571 (Código de Protección y Defensa del Consumidor, Art. 18)
  //
  // Cualquier modificación debe ser revisada por el equipo legal de WasiStudent.
  static const _contractClauses = [
    _ContractClause(
      title: 'Cláusula 1 — Precio fijo durante toda la vigencia',
      legalBase: 'Código Civil Art. 1680 — estabilidad del precio pactado',
      text:
          'El monto del arrendamiento mensual pactado en este contrato es '
          'INMODIFICABLE durante toda su vigencia. El arrendador no podrá '
          'incrementarlo unilateralmente bajo ningún concepto, incluyendo '
          'incrementos estacionales, por inicio de ciclo académico, por '
          'demanda turística o por inflación. Cualquier ajuste requerirá '
          'acuerdo escrito y firmado por ambas partes, y solo será válido '
          'para contratos posteriores. El precio pactado incluye los '
          'servicios básicos expresamente detallados en el Anexo 1 de este '
          'contrato; cualquier servicio no listado será cubierto por el '
          'arrendador. Esta cláusula protege al arrendatario estudiante de '
          'los incrementos abusivos documentados en el mercado cusqueño, '
          'donde el 67% de estudiantes reporta alzas de hasta 52% durante '
          'el inicio de clases (investigación WasiStudent 2025).',
    ),
    _ContractClause(
      title: 'Cláusula 2 — Duración mínima de seis (6) meses',
      legalBase: 'Ley N° 30201 Art. 4 — protección al arrendatario de vivienda',
      text:
          'La vigencia mínima de este contrato es de seis (6) meses '
          'consecutivos contados desde la fecha de entrega del inmueble. '
          'Durante este período, el arrendador no podrá resolver el '
          'contrato ni solicitar el desalojo del arrendatario, salvo por '
          'las causales taxativas previstas en el Código Civil Art. 1704 '
          '(incumplimiento grave, uso indebido o mutuo acuerdo). '
          'Cualquier resolución anticipada sin causal justa facultará al '
          'arrendatario a exigir el reintegro íntegro del depósito, '
          'traslado gratuito a una habitación equivalente verificada por '
          'WasiStudent, y una indemnización equivalente a un (1) mes de '
          'alquiler. Esta cláusula protege al estudiante de los desalojos '
          'express documentados (74% de casos en Cusco según E2, E4, E7).',
    ),
    _ContractClause(
      title: 'Cláusula 3 — Devolución íntegra del depósito en 15 días',
      legalBase: 'Código Civil Art. 1679 — obligación de devolver el depósito',
      text:
          'El depósito de garantía equivalente a un (1) mes de arrendamiento '
          'será devuelto en su INTEGRIDAD al arrendatario dentro de los '
          'quince (15) días calendario posteriores a la entrega del '
          'inmueble. El arrendador solo podrá retener parte del depósito '
          'mediante: (a) inventario firmado y fotografiado por ambas partes '
          'al inicio y fin del contrato, y (b) liquidación detallada y '
          'documentada con comprobantes de pago de los daños imputables '
          'al arrendatario. El desgaste normal por uso (definido en el '
          'Anexo 2) no es causa de retención. Si el arrendador no '
          'devuelve el depósito dentro del plazo de 15 días sin causa '
          'justificada, WasiStudent registrará la infracción en el perfil '
          'de reputación del arrendador, su puntaje de confianza caerá '
          'mínimo 30 puntos, y el arrendatario podrá reclamar adicionalmente '
          'un interés legal moratorio desde el día 16. Esta cláusula '
          'combate la retención arbitraria de depósitos, que afecta al '
          '58% de estudiantes foráneos en Cusco.',
    ),
    _ContractClause(
      title: 'Cláusula 4 — Transparencia total de servicios incluidos',
      legalBase:
          'Ley N° 29571 Art. 18 — Código de Protección y Defensa del Consumidor (información veraz)',
      text:
          'El arrendador declara de forma exhaustiva y verificada por '
          'WasiStudent los servicios incluidos en el arrendamiento '
          'mensual: agua potable, energía eléctrica, eliminación de '
          'residuos, internet (con velocidad mínima medida por el '
          'verificador), gas (cuando aplique) y uso de espacios '
          'comunes (cocina, lavandería, patio). Esta lista se anexa '
          'al contrato como Anexo 1 y es vinculante. El arrendador '
          'no podrá cobrar al arrendatario montos adicionales por '
          'estos servicios durante la vigencia del contrato. Si un '
          'servicio se interrumpe por más de 24 horas por causa '
          'imputable al arrendador (mantenimiento, corte por falta '
          'de pago del arrendador, etc.), el arrendatario tendrá '
          'derecho a un descuento proporcional del 5% del arrendamiento '
          'mensual por cada día de interrupción, descontable del '
          'siguiente pago. Esta cláusula combate la práctica — '
          'documentada en el 73% de los casos de Cusco — de anuncios '
          'que dicen "todo incluido" pero que al llegar cobran extra '
          'por servicios "no especificados". En WasiStudent, lo que '
          'ves es lo que pagas. Punto.',
    ),
    _ContractClause(
      title: 'Cláusula 5 — Preaviso escrito de 30 días para cualquier cambio',
      legalBase: 'Código Civil Art. 1687 — preaviso obligatorio para resolución',
      text:
          'Cualquier decisión que afecte la vigencia o condiciones del '
          'contrato requiere preaviso escrito de no menos de treinta (30) '
          'días calendario, comunicado mediante el canal oficial de '
          'WasiStudent (chat in-app con constancia de lectura) o correo '
          'certificado. Esto incluye: (a) resolución anticipada por '
          'cualquier causa, (b) no renovación al vencimiento, (c) '
          'modificación del precio o servicios (solo aplicable para '
          'contratos futuros según Cláusula 1), y (d) cambio de uso del '
          'inmueble. Ninguna de las partes puede abandonar el contrato '
          'de un día para otro sin incurrir en penalidad. La parte que '
          'incumpla el preaviso deberá indemnizar a la otra con el '
          'equivalente a un (1) mes de arrendamiento. Esta cláusula '
          'protege tanto al estudiante (que necesita tiempo para '
          'encontrar nueva vivienda sin perder clases) como al '
          'arrendador (que necesita tiempo para conseguir nuevo '
          'inquilino sin perder ingresos).',
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dniController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        // No llamar validate() durante build — causa problemas.
        // Solo verificar que los campos tengan texto.
        // La validación completa se hace al presionar "Siguiente".
        return _nameController.text.trim().isNotEmpty &&
            _dniController.text.trim().isNotEmpty &&
            _emailController.text.trim().isNotEmpty &&
            _phoneController.text.trim().isNotEmpty &&
            _addressController.text.trim().isNotEmpty;
      case 1:
        return _acceptedClauses.every((accepted) => accepted);
      case 2:
        return _signatureConfirmed;
      default:
        return false;
    }
  }

  /// Valida el formulario del paso 0 y avanza si todo es válido.
  /// Muestra mensajes de error en los campos inválidos.
  void _validateAndAdvance() {
    if (_currentStep == 0) {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) return;
    }
    setState(() => _currentStep++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contrato de arrendamiento'),
      ),
      body: Column(
        children: [
          _buildProgressSteps(),
          Expanded(
            child: AnimatedSwitcher(
              duration: WasiDuration.normal,
              child: _buildStepContent(),
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  // ── Progress Steps ────────────────────────────────────────────────

  Widget _buildProgressSteps() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          _StepDot(
            number: 1,
            label: 'Datos\npersonales',
            isActive: _currentStep >= 0,
            isCompleted: _currentStep > 0,
          ),
          _StepLine(isActive: _currentStep > 0),
          _StepDot(
            number: 2,
            label: 'Cláusulas',
            isActive: _currentStep >= 1,
            isCompleted: _currentStep > 1,
          ),
          _StepLine(isActive: _currentStep > 1),
          _StepDot(
            number: 3,
            label: 'Firma',
            isActive: _currentStep >= 2,
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  // ── Step Content ──────────────────────────────────────────────────

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalDataStep();
      case 1:
        return _buildClausesStep();
      case 2:
        return _buildSignatureStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Step 1: Personal Data ─────────────────────────────────────────

  Widget _buildPersonalDataStep() {
    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos personales del arrendatario',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Esta información será incluida en el contrato de arrendamiento.',
              style: TextStyle(
                fontSize: 13,
                color: WasiColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              validator: Validators.validateName,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _dniController,
              validator: Validators.validateDNI,
              keyboardType: TextInputType.number,
              maxLength: 8,
              decoration: const InputDecoration(
                labelText: 'DNI',
                prefixIcon: Icon(Icons.badge_outlined),
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              validator: Validators.validatePhone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              validator: (v) => Validators.validateRequired(v, 'La dirección'),
              decoration: const InputDecoration(
                labelText: 'Dirección de residencia actual',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Step 2: Contract Clauses ──────────────────────────────────────

  Widget _buildClausesStep() {
    return SingleChildScrollView(
      key: const ValueKey(1),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cláusulas del contrato',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Basado en el Código Civil Peruano. Lee y acepta cada cláusula.',
            style: TextStyle(
              fontSize: 13,
              color: WasiColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(_contractClauses.length, (index) {
            final clause = _contractClauses[index];
            final accepted = _acceptedClauses[index];
            return _ClauseCard(
              index: index + 1,
              clause: clause,
              accepted: accepted,
              onToggle: (value) {
                setState(() => _acceptedClauses[index] = value ?? false);
              },
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Step 3: Signature ─────────────────────────────────────────────

  Widget _buildSignatureStep() {
    return SingleChildScrollView(
      key: const ValueKey(2),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirmación y firma',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: WasiColors.surfaceLight,
              borderRadius: WasiRadius.card,
              border: Border.all(
                color: WasiColors.outlineLight.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen del contrato',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Divider(height: 20),
                _summaryRow('Arrendatario', _nameController.text),
                _summaryRow('DNI', _dniController.text),
                _summaryRow('Correo', _emailController.text),
                _summaryRow('Teléfono', _phoneController.text),
                _summaryRow('Habitación', 'ID: ${widget.roomId}'),
                _summaryRow(
                  'Cláusulas aceptadas',
                  '${_acceptedClauses.where((a) => a).length}/5',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Signature area
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: WasiColors.surfaceVariantLight.withValues(alpha: 0.5),
              borderRadius: WasiRadius.card,
              border: Border.all(
                color: WasiColors.outlineLight,
                style: BorderStyle.solid,
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.draw_outlined,
                    size: 36,
                    color: WasiColors.textTertiaryLight,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Área de firma digital',
                    style: TextStyle(
                      fontSize: 13,
                      color: WasiColors.textTertiaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Confirmation checkbox
          CheckboxListTile(
            value: _signatureConfirmed,
            onChanged: (value) {
              setState(() => _signatureConfirmed = value ?? false);
            },
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'Confirmo que he leído y acepto todas las cláusulas del contrato de arrendamiento.',
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: WasiColors.textTertiaryLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '—',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Navigation Buttons ────────────────────────────────────────────

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: WasiColors.outlineLight.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentStep > 0)
              OutlinedButton(
                onPressed: _isProcessing
                    ? null
                    : () => setState(() => _currentStep--),
                child: const Text('Atrás'),
              ),
            const Spacer(),
            if (_currentStep < 2)
              ElevatedButton(
                onPressed: _canProceed
                    ? _validateAndAdvance
                    : null,
                child: const Text('Siguiente'),
              )
            else
              ElevatedButton(
                onPressed: _canProceed && !_isProcessing ? _submitContract : null,
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Firmar contrato'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitContract() async {
    setState(() => _isProcessing = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isProcessing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Contrato firmado exitosamente! Revisa tu correo para el documento.'),
        backgroundColor: WasiColors.success,
      ),
    );
    Navigator.of(context).pop();
  }
}

// ── Progress Step Dot ───────────────────────────────────────────────

class _StepDot extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepDot({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: WasiDuration.normal,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? WasiColors.success
                  : isActive
                      ? WasiColors.primary
                      : WasiColors.surfaceVariantLight,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '$number',
                      style: TextStyle(
                        color: isActive ? Colors.white : WasiColors.textTertiaryLight,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? WasiColors.primary
                  : WasiColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Progress Step Line ──────────────────────────────────────────────

class _StepLine extends StatelessWidget {
  final bool isActive;

  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 3,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: isActive
            ? WasiColors.primary
            : WasiColors.surfaceVariantLight,
      ),
    );
  }
}

// ── Contract Clause Model ───────────────────────────────────────────

class _ContractClause {
  final String title;
  final String legalBase;
  final String text;

  const _ContractClause({
    required this.title,
    required this.legalBase,
    required this.text,
  });
}

// ── Clause Card ─────────────────────────────────────────────────────

class _ClauseCard extends StatelessWidget {
  final int index;
  final _ContractClause clause;
  final bool accepted;
  final ValueChanged<bool?> onToggle;

  const _ClauseCard({
    required this.index,
    required this.clause,
    required this.accepted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accepted
              ? WasiColors.success.withValues(alpha: 0.4)
              : WasiColors.outlineLight.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Número + título
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: WasiColors.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$index',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: WasiColors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  clause.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: WasiColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Base legal (chip)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: WasiColors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: WasiColors.accent.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.gavel_outlined,
                  size: 12,
                  color: WasiColors.accent,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    clause.legalBase,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: WasiColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            clause.text,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.55,
              color: WasiColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            value: accepted,
            onChanged: onToggle,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            title: const Text(
              'He leído y acepto esta cláusula',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
