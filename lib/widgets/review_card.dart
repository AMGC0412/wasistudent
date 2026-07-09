import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Tarjeta de reseña con avatar, estrellas, comentario, pros/contras y botón de útil.
class ReviewCard extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final int rating;
  final String comment;
  final List<String> pros;
  final List<String> cons;
  final String date;
  final bool isVerified;
  final int helpfulCount;
  final bool isHelpful;
  final VoidCallback? onHelpfulTap;

  const ReviewCard({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    this.pros = const [],
    this.cons = const [],
    required this.date,
    this.isVerified = false,
    this.helpfulCount = 0,
    this.isHelpful = false,
    this.onHelpfulTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? WasiColors.outlineDark.withValues(alpha: 0.2)
              : WasiColors.outlineLight.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: avatar, nombre, estrellas
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: WasiColors.primary.withValues(alpha: 0.1),
                child: Text(
                  userAvatar,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: WasiColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Nombre y fecha
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            userName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? WasiColors.textPrimaryDark
                                  : WasiColors.textPrimaryLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: WasiColors.primaryLight,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? WasiColors.textTertiaryDark
                            : WasiColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Estrellas
              _buildStars(context),
            ],
          ),
          // Comentario
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              comment,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark
                    ? WasiColors.textSecondaryDark
                    : WasiColors.textSecondaryLight,
              ),
            ),
          ],
          // Pros
          if (pros.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...pros.map((pro) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.add_circle_rounded,
                        size: 14,
                        color: WasiColors.success,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          pro,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? WasiColors.textSecondaryDark
                                : WasiColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          // Contras
          if (cons.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...cons.map((con) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.remove_circle_rounded,
                        size: 14,
                        color: WasiColors.error,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          con,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? WasiColors.textSecondaryDark
                                : WasiColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          // Botón de útil
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: onHelpfulTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isHelpful
                        ? WasiColors.primary.withValues(alpha: 0.1)
                        : (isDark ? WasiColors.surfaceVariantDark : WasiColors.surfaceVariantLight),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isHelpful
                          ? WasiColors.primary.withValues(alpha: 0.3)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isHelpful ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
                        size: 13,
                        color: isHelpful ? WasiColors.primary : (isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        helpfulCount > 0 ? 'Útil ($helpfulCount)' : 'Útil',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isHelpful
                              ? WasiColors.primary
                              : isDark
                                  ? WasiColors.textTertiaryDark
                                  : WasiColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStars(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 16,
          color: index < rating ? WasiColors.accent : WasiColors.outlineLight,
        );
      }),
    );
  }
}
