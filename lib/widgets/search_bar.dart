import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Barra de búsqueda tappable con icono y texto sugerido.
/// Navega a la pantalla de búsqueda al tocar.
class SearchBarWidget extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isEnabled;

  const SearchBarWidget({
    super.key,
    this.hint = 'Buscar habitaciones, distritos...',
    this.onTap,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.isEnabled = true,
  });

  /// Si se provee onTap, la barra es tappable y navega a búsqueda.
  /// Si no, es una barra de búsqueda funcional con campo de texto.
  bool get _isTappable => onTap != null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: _isTappable && isEnabled ? onTap : null,
      child: AbsorbPointer(
        absorbing: _isTappable,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isDark
                ? WasiColors.surfaceVariantDark
                : WasiColors.surfaceVariantLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? WasiColors.outlineDark.withValues(alpha: 0.3)
                  : WasiColors.outlineLight.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                Icons.search_rounded,
                size: 22,
                color: isDark
                    ? WasiColors.textTertiaryDark
                    : WasiColors.textTertiaryLight,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  enabled: isEnabled && !_isTappable,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? WasiColors.textPrimaryDark
                        : WasiColors.textPrimaryLight,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? WasiColors.textTertiaryDark
                          : WasiColors.textTertiaryLight,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              // Filtros
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: WasiColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 18,
                    color: WasiColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
