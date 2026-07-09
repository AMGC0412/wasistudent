import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Tarjeta con efecto glassmorphism: vidrio esmerilado con blur,
/// fondo semi-transparente y borde sutil.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? tintColor;
  final double opacity;
  final double borderWidth;
  final Color? borderColor;
  final double elevation;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blurSigma = 12,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.tintColor,
    this.opacity = 0.15,
    this.borderWidth = 0.5,
    this.borderColor,
    this.elevation = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveTintColor = tintColor ??
        (isDark
            ? WasiColors.surfaceDark.withValues(alpha: opacity + 0.1)
            : WasiColors.surfaceLight.withValues(alpha: opacity + 0.45));

    final effectiveBorderColor = borderColor ??
        (isDark
            ? WasiColors.outlineDark.withValues(alpha: 0.2)
            : WasiColors.outlineLight.withValues(alpha: 0.4));

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: effectiveTintColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: effectiveBorderColor,
              width: borderWidth,
            ),
            boxShadow: elevation > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                      blurRadius: elevation,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
