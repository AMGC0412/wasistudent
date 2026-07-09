import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Modelo de un punto de verificación en persona.
///
/// Cada punto representa un aspecto físico o de servicio del cuarto que
/// un verificador de WasiStudent confirma IN SITU antes de publicar.
/// El peso del punto en el puntaje de verificación depende de su [level]:
/// - [ChecklistItemLevel.indispensable]: si falla 1+, el cuarto NO se publica.
///   Pesan el doble en la métrica global.
/// - [ChecklistItemLevel.complementary]: si falla 1-2, el cuarto se publica
///   CON ADVERTENCIA visible. Pesan normal.
enum ChecklistItemLevel { indispensable, complementary }

class VerificationItem {
  final String id;
  final String label;
  final String description;
  final IconData icon;
  final ChecklistItemLevel level;

  /// Estado del punto verificado. null = no verificado todavía.
  final bool? passed;

  /// Nota opcional del verificador (ej. "Disponible 6am-9am y 6pm-10pm").
  final String? note;

  const VerificationItem({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.level,
    this.passed,
    this.note,
  });

  VerificationItem copyWith({bool? passed, String? note}) {
    return VerificationItem(
      id: id,
      label: label,
      description: description,
      icon: icon,
      level: level,
      passed: passed ?? this.passed,
      note: note ?? this.note,
    );
  }
}

/// Catálogo de los 12 puntos de verificación en persona de WasiStudent.
///
/// Los primeros 7 son INDISPENSABLES (si fallan, el cuarto no se publica):
/// agua, electricidad, baño, cocina, cerradura, techo/paredes, ventilación.
/// Los siguientes 5 son COMPLEMENTARIOS (información útil, no bloqueante):
/// internet, ducha caliente, baño propio, escritorio, iluminación natural.
class VerificationChecklist {
  static List<VerificationItem> defaultItems() {
    return const [
      // ── INDISPENSABLES (peso 2x en la métrica, bloquean publicación) ──
      VerificationItem(
        id: 'water',
        label: 'Agua potable',
        description: 'Suministro continuo de agua potable en el inmueble.',
        icon: Icons.water_drop_outlined,
        level: ChecklistItemLevel.indispensable,
        passed: true,
      ),
      VerificationItem(
        id: 'electricity',
        label: 'Electricidad segura',
        description: 'Instalación eléctrica sin cables expuestos ni tomas '
            'sobrecargadas. Tablero con disyuntor.',
        icon: Icons.bolt_outlined,
        level: ChecklistItemLevel.indispensable,
        passed: true,
      ),
      VerificationItem(
        id: 'bathroom',
        label: 'Baño funcional',
        description: 'Baño con puerta que cierra, inodoro operativo, lavadero '
            'y ducha. Mínimo 1 baño por cada 4 personas.',
        icon: Icons.bathtub_outlined,
        level: ChecklistItemLevel.indispensable,
        passed: true,
      ),
      VerificationItem(
        id: 'kitchen',
        label: 'Cocina accesible',
        description: 'Espacio de cocina con cocina/estufa operativa y lugar '
            'para almacenar alimentos del inquilino.',
        icon: Icons.kitchen_outlined,
        level: ChecklistItemLevel.indispensable,
        passed: true,
      ),
      VerificationItem(
        id: 'lock',
        label: 'Cerradura en puerta',
        description: 'Puerta del cuarto con cerradura operativa y llave '
            'entregada al inquilino. Puerta principal con chapa.',
        icon: Icons.lock_outline,
        level: ChecklistItemLevel.indispensable,
        passed: true,
      ),
      VerificationItem(
        id: 'structure',
        label: 'Estructura sin daños',
        description: 'Techo sin goteras, paredes sin humedad grave, piso en '
            'buen estado. Sin riesgo de colapso.',
        icon: Icons.home_repair_service_outlined,
        level: ChecklistItemLevel.indispensable,
        passed: true,
      ),
      VerificationItem(
        id: 'ventilation',
        label: 'Ventilación natural',
        description: 'Al menos una ventana que abre al exterior o patio. '
            'Permite renovación de aire.',
        icon: Icons.air_outlined,
        level: ChecklistItemLevel.indispensable,
        passed: true,
      ),

      // ── COMPLEMENTARIOS (peso 1x, no bloquean pero generan advertencias) ──
      VerificationItem(
        id: 'wifi',
        label: 'Internet Wi-Fi',
        description: 'Conexión a internet funcional medida por el verificador. '
            'Velocidad mínima recomendada: 10 Mbps.',
        icon: Icons.wifi_outlined,
        level: ChecklistItemLevel.complementary,
        passed: true,
      ),
      VerificationItem(
        id: 'hot_water',
        label: 'Agua caliente / ducha caliente',
        description: 'Agua caliente disponible para ducha. Puede ser por '
            'calefón, terma o sistema centralizado.',
        icon: Icons.hot_tub_outlined,
        level: ChecklistItemLevel.complementary,
        passed: true,
        note: 'Disponible 6am-9am y 6pm-10pm',
      ),
      VerificationItem(
        id: 'private_bathroom',
        label: 'Baño propio',
        description: 'Baño de uso exclusivo del cuarto. Si es compartido, '
            'se especifica con cuántas personas.',
        icon: Icons.wc_outlined,
        level: ChecklistItemLevel.complementary,
        passed: false,
      ),
      VerificationItem(
        id: 'desk',
        label: 'Escritorio',
        description: 'Superficie plana adecuada para estudiar (mínimo 80x40 cm) '
            'con silla.',
        icon: Icons.desk_outlined,
        level: ChecklistItemLevel.complementary,
        passed: true,
      ),
      VerificationItem(
        id: 'natural_light',
        label: 'Iluminación natural',
        description: 'Ventana que permite entrada de luz solar diurna. '
            'No se considera iluminación si solo hay lucernario.',
        icon: Icons.wb_sunny_outlined,
        level: ChecklistItemLevel.complementary,
        passed: true,
      ),
    ];
  }

  /// Calcula el puntaje de verificación (0-100) con pesos:
  /// - Indispensables pesan 2x.
  /// - Complementarios pesan 1x.
  /// - Puntos no verificados (passed == null) no cuentan.
  /// - Puntos indispensables fallados bloquean publicación (return 0).
  static double computeScore(List<VerificationItem> items) {
    final indispensable = items
        .where((i) => i.level == ChecklistItemLevel.indispensable)
        .toList();
    final complementary = items
        .where((i) => i.level == ChecklistItemLevel.complementary)
        .toList();

    // Si algún indispensable falla, el cuarto no se publica.
    if (indispensable.any((i) => i.passed == false)) {
      return 0.0;
    }

    // Si todos los indispensables pasan, calcular puntaje ponderado.
    final indispensablePassed =
        indispensable.where((i) => i.passed == true).length;
    final complementaryPassed =
        complementary.where((i) => i.passed == true).length;

    final totalWeight =
        (indispensable.length * 2.0) + (complementary.length * 1.0);
    final obtainedWeight = (indispensablePassed * 2.0) +
        (complementaryPassed * 1.0);

    if (totalWeight <= 0) return 0.0;
    return ((obtainedWeight / totalWeight) * 100).clamp(0.0, 100.0);
  }

  /// ¿El cuarto puede publicarse?
  static bool canPublish(List<VerificationItem> items) {
    final indispensable = items
        .where((i) => i.level == ChecklistItemLevel.indispensable)
        .toList();
    // Todos los indispensables deben estar verificados y aprobados.
    return indispensable.isNotEmpty &&
        indispensable.every((i) => i.passed == true);
  }
}

/// Tarjeta visual que muestra el checklist de 12 puntos verificados.
///
/// Muestra dos secciones claramente separadas:
/// - "Indispensables" (con icono de bloqueo, color rojo si falla)
/// - "Complementarios" (con icono de info, color gris si falla)
///
/// Cada item muestra: icono + label + estado (✓ verde / ✗ rojo / − gris)
/// y nota opcional del verificador en italic.
///
/// Al final, una barra de puntaje global (0-100) con código de color.
class VerificationChecklistCard extends StatelessWidget {
  final List<VerificationItem>? _items;
  final bool initiallyExpanded;

  List<VerificationItem> get items => _items ?? VerificationChecklist.defaultItems();

  const VerificationChecklistCard({
    super.key,
    List<VerificationItem>? items,
    this.initiallyExpanded = false,
  }) : _items = items;

  @override
  Widget build(BuildContext context) {
    final score = VerificationChecklist.computeScore(items);
    final canPublish = VerificationChecklist.canPublish(items);
    final indispensable = items
        .where((i) => i.level == ChecklistItemLevel.indispensable)
        .toList();
    final complementary = items
        .where((i) => i.level == ChecklistItemLevel.complementary)
        .toList();

    return _ExpandableCard(
      title: 'Verificación en persona',
      subtitle: canPublish
          ? 'Verificado por equipo WasiStudent · ${score.round()}/100'
          : 'Pendiente de verificación',
      icon: Icons.verified_user_outlined,
      accentColor: canPublish ? WasiColors.success : WasiColors.accent,
      initiallyExpanded: initiallyExpanded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de estado
          _StatusBanner(score: score, canPublish: canPublish),
          const SizedBox(height: 14),

          // Sección indispensables
          _SectionHeader(
            title: 'Indispensables',
            subtitle: 'Bloquean la publicación si fallan',
            icon: Icons.priority_high_rounded,
            color: WasiColors.error,
          ),
          const SizedBox(height: 6),
          ...indispensable.map((item) => _ItemTile(item: item)),

          const SizedBox(height: 14),

          // Sección complementarios
          _SectionHeader(
            title: 'Complementarios',
            subtitle: 'Información útil para tu decisión',
            icon: Icons.info_outline_rounded,
            color: WasiColors.accent,
          ),
          const SizedBox(height: 6),
          ...complementary.map((item) => _ItemTile(item: item)),

          const SizedBox(height: 14),

          // Barra de puntaje
          _ScoreBar(score: score),

          const SizedBox(height: 8),
          Text(
            'Verificado el 12 de junio, 2026 · Verificador: Carlos M. (UNSAAC)',
            style: TextStyle(
              fontSize: 10.5,
              color: WasiColors.textTertiaryLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Componentes internos ────────────────────────────────────────────────

class _ExpandableCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool initiallyExpanded;
  final Widget child;

  const _ExpandableCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.initiallyExpanded,
    required this.child,
  });

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: widget.accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header (clicable)
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: WasiRadius.card,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.accentColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: WasiColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: widget.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: WasiColors.textTertiaryLight,
                  ),
                ],
              ),
            ),
          ),
          // Contenido expandible
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final double score;
  final bool canPublish;

  const _StatusBanner({required this.score, required this.canPublish});

  @override
  Widget build(BuildContext context) {
    final color = canPublish ? WasiColors.success : WasiColors.error;
    final bgColor = canPublish
        ? WasiColors.successContainer
        : WasiColors.errorContainer;
    final fgColor = canPublish
        ? WasiColors.onSuccessContainer
        : WasiColors.onErrorContainer;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            canPublish ? Icons.check_circle : Icons.cancel,
            color: fgColor,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  canPublish
                      ? 'Cuarto verificado y apto para publicar'
                      : 'Cuarto rechazado — falla en indispensables',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: fgColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  canPublish
                      ? 'Un verificador de WasiStudent visitó este cuarto en persona.'
                      : 'Este cuarto no cumple los requisitos mínimos y no se ofrece en la plataforma.',
                  style: TextStyle(
                    fontSize: 11,
                    color: fgColor.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          // Color del puntaje como tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${score.round()}/100',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.5,
              color: WasiColors.textTertiaryLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  final VerificationItem item;

  const _ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final status = _ItemStatus.fromItem(item);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono del item
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: status.bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, size: 16, color: status.iconColor),
          ),
          const SizedBox(width: 10),
          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: WasiColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    // Status icon
                    Icon(status.icon, size: 16, color: status.iconColor),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: WasiColors.textTertiaryLight,
                  ),
                ),
                if (item.note != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: WasiColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Nota del verificador: ${item.note}',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontStyle: FontStyle.italic,
                        color: WasiColors.accent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemStatus {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _ItemStatus._({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  factory _ItemStatus.fromItem(VerificationItem item) {
    if (item.passed == true) {
      return const _ItemStatus._(
        icon: Icons.check_circle,
        iconColor: WasiColors.success,
        bgColor: WasiColors.successContainer,
      );
    }
    if (item.passed == false) {
      // Falla: rojo si indispensable, ámbar si complementario.
      if (item.level == ChecklistItemLevel.indispensable) {
        return const _ItemStatus._(
          icon: Icons.cancel,
          iconColor: WasiColors.error,
          bgColor: WasiColors.errorContainer,
        );
      }
      return const _ItemStatus._(
        icon: Icons.warning_amber_rounded,
        iconColor: WasiColors.accent,
        bgColor: WasiColors.secondaryContainer,
      );
    }
    // No verificado
    return _ItemStatus._(
      icon: Icons.remove_circle_outline,
      iconColor: WasiColors.textTertiaryLight,
      bgColor: WasiColors.surfaceVariantLight,
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final double score;

  const _ScoreBar({required this.score});

  Color _scoreColor() {
    if (score >= 85) return WasiColors.success;
    if (score >= 60) return WasiColors.accent;
    return WasiColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Puntaje de verificación',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: WasiColors.textSecondaryLight,
              ),
            ),
            Text(
              '${score.round()} / 100',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (score / 100).clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: WasiColors.surfaceVariantLight,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Ponderación: indispensables ×2, complementarios ×1. '
          'Falla en cualquier indispensable = rechazo automático.',
          style: TextStyle(
            fontSize: 10,
            color: WasiColors.textTertiaryLight,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
