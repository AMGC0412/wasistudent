import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/review.dart';
import '../providers/review_provider.dart';
import 'add_review_screen.dart';

/// Pantalla de reseñas de una habitación.
/// Incluye resumen de calificación general, distribución de estrellas,
/// opciones de ordenamiento, tarjetas de reseñas con pros/contras/fotos,
/// botón de "útil" y respuestas del propietario. Botón "cargar más".
class ReviewsScreen extends StatefulWidget {
  final String roomId;
  final String roomTitle;

  const ReviewsScreen({
    super.key,
    required this.roomId,
    required this.roomTitle,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String _sortBy = 'recent'; // recent, highest, lowest, helpful
  int _displayCount = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewProvider>().loadReviewsForRoom(widget.roomId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reseñas'),
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final reviews = _getSortedReviews(provider);
          final avgRating = provider.getAverageRating(widget.roomId);
          final distribution = provider.getStarDistribution(widget.roomId);
          final totalReviews = provider.getReviewCount(widget.roomId);

          return CustomScrollView(
            slivers: [
              // ── Rating Summary ──
              SliverToBoxAdapter(
                child: _RatingSummary(
                  averageRating: avgRating,
                  totalReviews: totalReviews,
                  distribution: distribution,
                ),
              ),

              // ── Sort Options ──
              SliverToBoxAdapter(child: _buildSortBar()),

              // ── Review Cards ──
              if (reviews.isEmpty)
                SliverFillRemaining(child: _buildEmptyState())
              else ...[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ReviewCard(
                      review: reviews[index],
                      onHelpful: () => provider.toggleHelpful(reviews[index].id),
                    ),
                    childCount: reviews.length,
                  ),
                ),

                // ── Load More ──
                if (_displayCount < provider.getReviewsForRoom(widget.roomId).length)
                  SliverToBoxAdapter(
                    child: _buildLoadMore(provider),
                  ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddReview(context),
        icon: const Icon(Icons.rate_review_outlined, color: Colors.white),
        label: const Text(
          'Escribir reseña',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: WasiColors.primary,
      ),
    );
  }

  // ── Sort Bar ───────────────────────────────────────────────────────

  Widget _buildSortBar() {
    final options = [
      ('recent', 'Más recientes'),
      ('highest', 'Mayor calificación'),
      ('lowest', 'Menor calificación'),
      ('helpful', 'Más útiles'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          const Text(
            'Ordenar por:',
            style: TextStyle(
              fontSize: 13,
              color: WasiColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: options.map((opt) {
                  final isSelected = _sortBy == opt.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(opt.$2),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _sortBy = opt.$1);
                      },
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : WasiColors.textSecondaryLight,
                      ),
                      selectedColor: WasiColors.primary,
                      side: BorderSide(
                        color: isSelected
                            ? WasiColors.primary
                            : WasiColors.outlineLight,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Load More ───────────────────────────────────────────────────────

  Widget _buildLoadMore(ReviewProvider provider) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          setState(() => _displayCount += 5);
        },
        icon: const Icon(Icons.expand_more, size: 18),
        label: const Text('Cargar más reseñas'),
      ),
    );
  }

  // ── Empty State ────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_outline,
              size: 56,
              color: WasiColors.accent,
            ),
            const SizedBox(height: 16),
            Text(
              'Sin reseñas aún',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sé el primero en compartir tu experiencia con esta habitación.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: WasiColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────

  List<Review> _getSortedReviews(ReviewProvider provider) {
    var reviews = provider.getReviewsForRoom(widget.roomId).toList();

    switch (_sortBy) {
      case 'recent':
        reviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      case 'highest':
        reviews.sort((a, b) => b.rating.compareTo(a.rating));
      case 'lowest':
        reviews.sort((a, b) => a.rating.compareTo(b.rating));
      case 'helpful':
        reviews.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
    }

    return reviews.take(_displayCount).toList();
  }

  void _navigateToAddReview(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddReviewScreen(
          roomId: widget.roomId,
          roomTitle: widget.roomTitle,
        ),
      ),
    );
  }
}

// ── Rating Summary ───────────────────────────────────────────────────

class _RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> distribution;

  const _RatingSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          // ── Average ──
          Column(
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: WasiColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  return Icon(
                    i < averageRating.round() ? Icons.star : Icons.star_border,
                    size: 18,
                    color: WasiColors.accent,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '$totalReviews reseña${totalReviews != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 12,
                  color: WasiColors.textTertiaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),

          // ── Star Distribution ──
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = distribution[star] ?? 0;
                final pct = totalReviews > 0 ? count / totalReviews : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: WasiColors.textSecondaryLight,
                        ),
                      ),
                      Icon(Icons.star, size: 12, color: WasiColors.accent),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: pct,
                            backgroundColor: WasiColors.outlineLight.withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              WasiColors.accent,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 20,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 11,
                            color: WasiColors.textTertiaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Review Card ──────────────────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onHelpful;

  const _ReviewCard({
    required this.review,
    required this.onHelpful,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          _buildHeader(),
          const SizedBox(height: 10),

          // ── Stars ──
          _buildStars(),
          const SizedBox(height: 10),

          // ── Comment ──
          if (review.comment.isNotEmpty) ...[
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 14,
                color: WasiColors.textPrimaryLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
          ],

          // ── Pros ──
          if (review.pros.isNotEmpty) ...[
            _buildTagList(
              label: 'Pros',
              tags: review.pros,
              color: WasiColors.success,
              bgColor: WasiColors.successContainer,
            ),
            const SizedBox(height: 6),
          ],

          // ── Cons ──
          if (review.cons.isNotEmpty) ...[
            _buildTagList(
              label: 'Contras',
              tags: review.cons,
              color: WasiColors.error,
              bgColor: WasiColors.errorContainer,
            ),
            const SizedBox(height: 6),
          ],

          // ── Photos ──
          if (review.photos.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildPhotos(),
          ],

          // ── Owner Reply ──
          if (review.ownerReply != null) ...[
            const SizedBox(height: 12),
            _buildOwnerReply(),
          ],

          // ── Footer ──
          const SizedBox(height: 8),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: WasiColors.primaryContainer,
          child: Text(
            review.userAvatar,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: WasiColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.userName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (review.isVerified) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.verified,
                      size: 14,
                      color: WasiColors.success,
                    ),
                  ],
                ],
              ),
              Text(
                review.relativeTime,
                style: const TextStyle(
                  fontSize: 11,
                  color: WasiColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStars() {
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < review.rating ? Icons.star : Icons.star_border,
          size: 16,
          color: WasiColors.accent,
        );
      }),
    );
  }

  Widget _buildTagList({
    required String label,
    required List<String> tags,
    required Color color,
    required Color bgColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPhotos() {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: review.photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: WasiRadius.thumbnail,
            child: Container(
              width: 72,
              height: 72,
              color: WasiColors.surfaceVariantLight,
              child: const Icon(
                Icons.image_outlined,
                color: WasiColors.textTertiaryLight,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOwnerReply() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WasiColors.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(WasiRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.reply,
                size: 14,
                color: WasiColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'Respuesta del propietario',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: WasiColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            review.ownerReply!.content,
            style: TextStyle(
              fontSize: 13,
              color: WasiColors.textSecondaryLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Text(
          review.dateFormatted,
          style: const TextStyle(
            fontSize: 11,
            color: WasiColors.textTertiaryLight,
          ),
        ),
        const Spacer(),
        _HelpfulButton(count: review.helpfulCount, onTap: onHelpful),
      ],
    );
  }
}

// ── Helpful Button ───────────────────────────────────────────────────

class _HelpfulButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _HelpfulButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.thumb_up_outlined,
              size: 14,
              color: WasiColors.textTertiaryLight,
            ),
            const SizedBox(width: 4),
            Text(
              count > 0 ? '$count útil${count != 1 ? 'es' : ''}' : 'Útil',
              style: const TextStyle(
                fontSize: 12,
                color: WasiColors.textTertiaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
