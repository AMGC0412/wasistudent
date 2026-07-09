import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/navigation_provider.dart';

/// Barra de navegación inferior personalizada.
/// 5 items: Inicio, Explorar, Descubrir, Mensajes, Perfil.
/// Indicador animado, escalado de iconos, badge en Mensajes.
class CustomBottomNav extends StatelessWidget {
  final int unreadMessages;

  const CustomBottomNav({
    super.key,
    this.unreadMessages = 0,
  });

  static const List<_NavItemData> _items = [
    _NavItemData(
      label: 'Inicio',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavItemData(
      label: 'Explorar',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
    ),
    _NavItemData(
      label: 'Descubrir',
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome_rounded,
    ),
    _NavItemData(
      label: 'Mensajes',
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      hasBadge: true,
    ),
    _NavItemData(
      label: 'Perfil',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navProvider = context.watch<NavigationProvider>();
    final currentIndex = navProvider.currentIndex;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark
                ? WasiColors.outlineDark.withValues(alpha: 0.3)
                : WasiColors.outlineLight.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == currentIndex;
              final showBadge = item.hasBadge && unreadMessages > 0;

              return _NavTabButton(
                item: item,
                isSelected: isSelected,
                isDark: isDark,
                showBadge: showBadge,
                badgeCount: unreadMessages,
                onTap: () => navProvider.setIndex(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavTabButton extends StatelessWidget {
  final _NavItemData item;
  final bool isSelected;
  final bool isDark;
  final bool showBadge;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavTabButton({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.showBadge,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: colorScheme.primary.withValues(alpha: 0.08),
          highlightColor: colorScheme.primary.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicador superior animado
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  height: 3,
                  width: isSelected ? 24 : 0,
                  decoration: BoxDecoration(
                    color: isSelected ? colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 4),
                // Icono con badge
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: isSelected ? 1.15 : 1.0,
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: isSelected ? 26 : 24,
                            color: isSelected
                                ? colorScheme.primary
                                : isDark
                                    ? WasiColors.textTertiaryDark
                                    : WasiColors.textTertiaryLight,
                          ),
                        ),
                      ),
                      // Badge de notificación
                      if (showBadge)
                        Positioned(
                          top: -2,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: WasiColors.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              badgeCount > 9 ? '9+' : '$badgeCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                // Etiqueta
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontSize: isSelected ? 11.5 : 10.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.1,
                    color: isSelected
                        ? colorScheme.primary
                        : isDark
                            ? WasiColors.textTertiaryDark
                            : WasiColors.textTertiaryLight,
                  ),
                  child: Text(item.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool hasBadge;

  const _NavItemData({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.hasBadge = false,
  });
}
