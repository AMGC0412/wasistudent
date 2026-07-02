import 'dart:math';
import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Gráfico radar de compatibilidad usando CustomPainter.
/// Muestra dimensiones de compatibilidad como un gráfico de araña.
class CompatibilityRadar extends StatelessWidget {
  final Map<String, double> dimensions; // label -> value (0.0 - 1.0)
  final double size;
  final Color? fillColor;
  final Color? strokeColor;

  const CompatibilityRadar({
    super.key,
    required this.dimensions,
    this.size = 200,
    this.fillColor,
    this.strokeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (dimensions.length < 3) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            'Se necesitan al menos 3 dimensiones',
            style: TextStyle(
              fontSize: 12,
              color: WasiColors.textTertiaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = fillColor ??
        WasiColors.primary.withValues(alpha: isDark ? 0.25 : 0.15);
    final stroke = strokeColor ?? WasiColors.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RadarPainter(
          dimensions: dimensions,
          fillColor: fill,
          strokeColor: stroke,
          gridColor: isDark
              ? WasiColors.outlineDark.withValues(alpha: 0.3)
              : WasiColors.outlineLight.withValues(alpha: 0.5),
          labelColor: isDark
              ? WasiColors.textSecondaryDark
              : WasiColors.textSecondaryLight,
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Map<String, double> dimensions;
  final Color fillColor;
  final Color strokeColor;
  final Color gridColor;
  final Color labelColor;

  _RadarPainter({
    required this.dimensions,
    required this.fillColor,
    required this.strokeColor,
    required this.gridColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 36; // espacio para etiquetas
    final labels = dimensions.keys.toList();
    final values = dimensions.values.toList();
    final n = labels.length;
    final angleStep = 2 * pi / n;

    // Dibujar anillos de fondo (3 niveles)
    for (int level = 1; level <= 3; level++) {
      final r = radius * level / 3;
      final path = Path();
      for (int i = 0; i < n; i++) {
        final angle = -pi / 2 + i * angleStep;
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..color = gridColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );
    }

    // Dibujar ejes
    for (int i = 0; i < n; i++) {
      final angle = -pi / 2 + i * angleStep;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(
        center,
        Offset(x, y),
        Paint()
          ..color = gridColor
          ..strokeWidth = 0.5,
      );
    }

    // Dibujar área de datos
    final dataPath = Path();
    final dataPoints = <Offset>[];
    for (int i = 0; i < n; i++) {
      final angle = -pi / 2 + i * angleStep;
      final r = radius * values[i].clamp(0.0, 1.0);
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      dataPoints.add(Offset(x, y));
      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();

    // Relleno
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );

    // Borde
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeJoin = StrokeJoin.round,
    );

    // Puntos de datos
    for (final point in dataPoints) {
      canvas.drawCircle(
        point,
        3.5,
        Paint()..color = strokeColor,
      );
      canvas.drawCircle(
        point,
        2.0,
        Paint()..color = Colors.white,
      );
    }

    // Etiquetas
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < n; i++) {
      final angle = -pi / 2 + i * angleStep;
      final labelR = radius + 20;
      final x = center.dx + labelR * cos(angle);
      final y = center.dy + labelR * sin(angle);

      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: labelColor,
        ),
      );
      textPainter.layout();

      // Ajustar posición según el cuadrante
      double offsetX = -textPainter.width / 2;
      double offsetY = -textPainter.height / 2;
      if (cos(angle) > 0.3) offsetX = -textPainter.width * 0.1;
      if (cos(angle) < -0.3) offsetX = -textPainter.width * 0.9;
      if (sin(angle) > 0.3) offsetY = 0;
      if (sin(angle) < -0.3) offsetY = -textPainter.height;

      textPainter.paint(canvas, Offset(x + offsetX, y + offsetY));
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.dimensions != dimensions;
  }
}
