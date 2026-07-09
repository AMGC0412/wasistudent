import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Placeholder de carga con efecto shimmer.
/// Configurable: ancho, alto, radio del borde.
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
    this.baseColor,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = widget.baseColor ??
        (isDark ? WasiColors.surfaceVariantDark : WasiColors.surfaceVariantLight);
    final highlightColor = isDark
        ? WasiColors.outlineDark.withValues(alpha: 0.2)
        : Colors.white.withValues(alpha: 0.7);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Fila de skeleton loaders para simular una tarjeta de habitación
class RoomCardSkeleton extends StatelessWidget {
  const RoomCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen placeholder
        const SkeletonLoader(
          height: 180,
          borderRadius: 16,
        ),
        const SizedBox(height: 12),
        // Título
        Row(
          children: [
            const Expanded(
              child: SkeletonLoader(height: 16, width: double.infinity),
            ),
            const SizedBox(width: 12),
            SkeletonLoader(
              height: 24,
              width: 80,
              borderRadius: 8,
              baseColor: WasiColors.accent.withValues(alpha: 0.15),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Subtítulo
        Row(
          children: [
            SkeletonLoader(
              height: 12,
              width: 12,
              borderRadius: 6,
            ),
            const SizedBox(width: 6),
            const SkeletonLoader(height: 12, width: 80),
            const SizedBox(width: 12),
            SkeletonLoader(
              height: 16,
              width: 60,
              borderRadius: 6,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Tags
        Row(
          children: List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: SkeletonLoader(
                height: 20,
                width: 60 + (i * 10.0),
                borderRadius: 6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
