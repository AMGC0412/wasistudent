import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'verified_badge.dart';
import 'matching_badge.dart';
import 'walking_time_badge.dart';

/// Tarjeta de habitación para la aplicación WasiStudent.
/// Soporta layout horizontal (carruseles) y vertical (listas).
class RoomCard extends StatelessWidget {
  final String title;
  final double price;
  final String district;
  final int walkingTimeMin;
  final int verificationLevel;
  final double matchingScore;
  final List<String> lifestyleTags;
  final List<String> imageUrls;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isHorizontal;
  final bool isUrgent;

  const RoomCard({
    super.key,
    required this.title,
    required this.price,
    required this.district,
    required this.walkingTimeMin,
    this.verificationLevel = 0,
    this.matchingScore = 0,
    this.lifestyleTags = const [],
    this.imageUrls = const [],
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
    this.isHorizontal = false,
    this.isUrgent = false,
  });

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? _buildHorizontal(context) : _buildVertical(context);
  }

  // ── Layout Vertical ──────────────────────────────────────────

  Widget _buildVertical(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen con badges
            _buildImageSection(context, height: 180),
            // Información
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila de título y precio
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? WasiColors.textPrimaryDark
                                : WasiColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildPriceBadge(context),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Distrito y tiempo a pie
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: isDark
                            ? WasiColors.textTertiaryDark
                            : WasiColors.textTertiaryLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        district,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? WasiColors.textSecondaryDark
                              : WasiColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(width: 10),
                      WalkingTimeBadge(minutes: walkingTimeMin),
                    ],
                  ),
                  if (verificationLevel > 0 || matchingScore > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          if (verificationLevel > 0)
                            VerifiedBadge(level: verificationLevel, compact: true),
                          if (verificationLevel > 0 && matchingScore > 0)
                            const SizedBox(width: 8),
                          if (matchingScore > 0)
                            MatchingBadge(percentage: matchingScore),
                        ],
                      ),
                    ),
                  if (lifestyleTags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildLifestyleTags(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Layout Horizontal ────────────────────────────────────────

  Widget _buildHorizontal(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context, height: 140),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? WasiColors.textPrimaryDark
                                : WasiColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildPriceBadge(context),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: isDark
                            ? WasiColors.textTertiaryDark
                            : WasiColors.textTertiaryLight,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          district,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? WasiColors.textSecondaryDark
                                : WasiColors.textSecondaryLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      WalkingTimeBadge(minutes: walkingTimeMin, compact: true),
                    ],
                  ),
                  if (verificationLevel > 0 || matchingScore > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          if (verificationLevel > 0)
                            VerifiedBadge(level: verificationLevel, compact: true),
                          if (verificationLevel > 0 && matchingScore > 0)
                            const SizedBox(width: 6),
                          if (matchingScore > 0)
                            MatchingBadge(percentage: matchingScore, compact: true),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sección de imagen con badges superpuestos ────────────────

  Widget _buildImageSection(BuildContext context, {required double height}) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          // Imagen placeholder con gradiente
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    WasiColors.primaryLight.withValues(alpha: 0.3),
                    WasiColors.primaryDark.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: imageUrls.isNotEmpty
                  ? Image.network(
                      imageUrls.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                    )
                  : _buildImagePlaceholder(),
            ),
          ),

          // Gradiente oscuro en la parte inferior
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),

          // Badge urgente
          if (isUrgent)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: WasiColors.error,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Urgente',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

          // Badge de verificación (esquina superior derecha)
          if (verificationLevel > 0)
            Positioned(
              top: 8,
              right: isUrgent ? null : 8,
              left: isUrgent ? null : null,
              child: VerifiedBadge(level: verificationLevel),
            ),

          // Botón de favorito
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: onFavoriteToggle,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: 18,
                  color: isFavorite ? WasiColors.error : Colors.white,
                ),
              ),
            ),
          ),

          // Badge de match (esquina inferior izquierda)
          if (matchingScore > 0)
            Positioned(
              bottom: 8,
              left: 8,
              child: MatchingBadge(percentage: matchingScore),
            ),
        ],
      ),
    );
  }

  // ── Badge de precio ──────────────────────────────────────────

  Widget _buildPriceBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: WasiColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'S/ ${price.toStringAsFixed(0)}/mes',
        style: TextStyle(
          color: WasiColors.accentDark,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ── Tags de estilo de vida ───────────────────────────────────

  Widget _buildLifestyleTags(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayTags = lifestyleTags.take(3).toList();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: displayTags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: (isDark ? WasiColors.primaryDark : WasiColors.primary)
                .withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? WasiColors.primaryLight : WasiColors.primary,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Placeholder de imagen ────────────────────────────────────

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.home_work_outlined,
        size: 40,
        color: Colors.white.withValues(alpha: 0.6),
      ),
    );
  }
}
