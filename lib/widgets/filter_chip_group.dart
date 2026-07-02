import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Grupo horizontal de chips de filtro con estado seleccionado.
class FilterChipGroup extends StatelessWidget {
  final List<String> labels;
  final Set<String> selected;
  final ValueChanged<String>? onSelected;
  final ValueChanged<String>? onDeselected;
  final Color? activeColor;
  final bool allowMultiple;
  final double spacing;

  const FilterChipGroup({
    super.key,
    required this.labels,
    required this.selected,
    this.onSelected,
    this.onDeselected,
    this.activeColor,
    this.allowMultiple = true,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: labels.map((label) {
          final isSelected = selected.contains(label);
          return Padding(
            padding: EdgeInsets.only(right: spacing),
            child: _FilterChip(
              label: label,
              isSelected: isSelected,
              activeColor: activeColor,
              onTap: () {
                if (isSelected) {
                  onDeselected?.call(label);
                } else {
                  onSelected?.call(label);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? activeColor;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = activeColor ?? WasiColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color
              : isDark
                  ? WasiColors.surfaceVariantDark
                  : WasiColors.surfaceVariantLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color
                : isDark
                    ? WasiColors.outlineDark.withValues(alpha: 0.3)
                    : WasiColors.outlineLight.withValues(alpha: 0.5),
            width: isSelected ? 1.2 : 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isDark
                        ? WasiColors.textSecondaryDark
                        : WasiColors.textSecondaryLight,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.check_rounded,
                size: 14,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
