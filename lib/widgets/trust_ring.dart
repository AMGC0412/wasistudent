import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Anillo animado de puntuación de confianza.
/// Muestra un CircularProgressIndicator con el puntaje y el texto 'puntos'.
/// Color basado en el nivel: 80+ verde, 60+ teal, 40+ dorado, menor rojo.
class TrustRing extends StatefulWidget {
  final int score;
  final double size;
  final bool animate;

  const TrustRing({
    super.key,
    required this.score,
    this.size = 100,
    this.animate = true,
  });

  @override
  State<TrustRing> createState() => _TrustRingState();
}

class _TrustRingState extends State<TrustRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TrustRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score && widget.animate) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _scoreColor() {
    if (widget.score >= 80) return WasiColors.success;
    if (widget.score >= 60) return WasiColors.primaryLight;
    if (widget.score >= 40) return WasiColors.accent;
    return WasiColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scoreColor = _scoreColor();
    final ringSize = widget.size;
    final strokeWidth = ringSize * 0.08;

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = (widget.score / 100.0) * _controller.value;
          final displayScore = (widget.score * _controller.value).round();

          return Stack(
            alignment: Alignment.center,
            children: [
              // Fondo del anillo
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(
                  scoreColor.withValues(alpha: isDark ? 0.15 : 0.1),
                ),
              ),
              // Progreso del anillo
              SizedBox(
                width: ringSize - strokeWidth,
                height: ringSize - strokeWidth,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
              ),
              // Contenido central
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$displayScore',
                    style: TextStyle(
                      fontSize: ringSize * 0.28,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? WasiColors.textPrimaryDark
                          : WasiColors.textPrimaryLight,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'puntos',
                    style: TextStyle(
                      fontSize: ringSize * 0.1,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? WasiColors.textTertiaryDark
                          : WasiColors.textTertiaryLight,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
