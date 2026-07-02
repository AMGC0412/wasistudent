import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Indicador de pasos: círculos conectados por líneas.
/// Pasos activos rellenos, paso actual con borde accent.
/// Etiquetas debajo de cada paso.
class ProgressSteps extends StatelessWidget {
  final int currentStep;
  final List<String> labels;
  final Color? activeColor;

  const ProgressSteps({
    super.key,
    required this.currentStep,
    required this.labels,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = activeColor ?? WasiColors.primary;
    final inactiveColor = isDark
        ? WasiColors.outlineDark
        : WasiColors.outlineLight;
    final totalSteps = labels.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Fila de círculos y líneas
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isOdd) {
              // Línea conectora
              final lineIndex = index ~/ 2;
              final isLineActive = lineIndex < currentStep;
              return Expanded(
                child: Container(
                  height: 2.5,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isLineActive ? accent : inactiveColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            } else {
              // Círculo del paso
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;
              final isCurrent = stepIndex == currentStep;

              return _StepCircle(
                stepIndex: stepIndex,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                accentColor: accent,
                inactiveColor: inactiveColor,
              );
            }
          }),
        ),
        const SizedBox(height: 8),
        // Etiquetas
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: Text(
                labels[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isCurrent || isCompleted ? FontWeight.w700 : FontWeight.w500,
                  color: isCurrent
                      ? accent
                      : isCompleted
                          ? accent
                          : isDark
                              ? WasiColors.textTertiaryDark
                              : WasiColors.textTertiaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int stepIndex;
  final bool isCompleted;
  final bool isCurrent;
  final Color accentColor;
  final Color inactiveColor;

  const _StepCircle({
    required this.stepIndex,
    required this.isCompleted,
    required this.isCurrent,
    required this.accentColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isCompleted) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: accentColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 16,
          color: Colors.white,
        ),
      );
    }

    if (isCurrent) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDark ? WasiColors.surfaceVariantDark : WasiColors.surfaceLight,
          shape: BoxShape.circle,
          border: Border.all(color: accentColor, width: 2.5),
        ),
        child: Center(
          child: Text(
            '${stepIndex + 1}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: accentColor,
            ),
          ),
        ),
      );
    }

    // Paso inactivo
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: inactiveColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: inactiveColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          '${stepIndex + 1}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark
                ? WasiColors.textTertiaryDark
                : WasiColors.textTertiaryLight,
          ),
        ),
      ),
    );
  }
}
