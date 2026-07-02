import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/room.dart';
import '../providers/room_provider.dart';
import '../utils/format_helpers.dart';

/// Pantalla de comparación lado a lado de dos habitaciones.
/// Incluye headers, filas de categorías con barras de progreso,
/// ganador destacado, puntuaciones globales, precio y servicios.
class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roomProvider = context.watch<RoomProvider>();
    final compared = roomProvider.getComparedRooms();

    if (compared.length < 2) {
      return Scaffold(
        appBar: AppBar(title: const Text('Comparar')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.compare_arrows,
                size: 64,
                color: WasiColors.textTertiaryLight,
              ),
              const SizedBox(height: 16),
              const Text(
                'Selecciona 2 habitaciones para comparar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: WasiColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Usa el botón "Comparar" en el detalle de cada habitación',
                style: TextStyle(
                  fontSize: 13,
                  color: WasiColors.textTertiaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final roomA = compared[0];
    final roomB = compared[1];

    return Scaffold(
      appBar: AppBar(title: const Text('Comparar habitaciones')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            _buildRoomHeaders(context, roomA, roomB),
            const SizedBox(height: 16),
            _buildCategoryRows(roomA, roomB),
            const SizedBox(height: 16),
            _buildOverallScores(roomA, roomB),
            const SizedBox(height: 16),
            _buildPriceComparison(roomA, roomB),
            const SizedBox(height: 16),
            _buildAmenitiesComparison(roomA, roomB),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Room Headers ──────────────────────────────────────────────────

  Widget _buildRoomHeaders(BuildContext context, Room a, Room b) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(child: _RoomHeaderCard(room: a)),
          const SizedBox(width: 8),
          const Icon(Icons.compare_arrows, color: WasiColors.accent, size: 28),
          const SizedBox(width: 8),
          Expanded(child: _RoomHeaderCard(room: b)),
        ],
      ),
    );
  }

  // ── Category Rows ─────────────────────────────────────────────────

  Widget _buildCategoryRows(Room a, Room b) {
    final scoresA = a.dimensionScores;
    final scoresB = b.dimensionScores;
    final categories = scoresA.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: WasiColors.surfaceLight,
          borderRadius: WasiRadius.card,
          border: Border.all(
            color: WasiColors.outlineLight.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          children: categories.map((category) {
            final valA = scoresA[category] ?? 0;
            final valB = scoresB[category] ?? 0;
            final winnerA = valA > valB;
            final winnerB = valB > valA;

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: WasiColors.outlineLight.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: WasiColors.textPrimaryLight,
                        ),
                      ),
                      if (winnerA || winnerB)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: WasiColors.successContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            winnerA ? '← Ganador' : 'Ganador →',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: WasiColors.onSuccessContainer,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Bar A
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: valA / 100,
                                backgroundColor:
                                    WasiColors.surfaceVariantLight,
                                color: winnerA
                                    ? WasiColors.success
                                    : WasiColors.primaryLight,
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${valA.round()}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: winnerA
                                    ? WasiColors.success
                                    : WasiColors.textTertiaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Bar B
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: valB / 100,
                                backgroundColor:
                                    WasiColors.surfaceVariantLight,
                                color: winnerB
                                    ? WasiColors.success
                                    : WasiColors.primaryLight,
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${valB.round()}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: winnerB
                                    ? WasiColors.success
                                    : WasiColors.textTertiaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Overall Scores ────────────────────────────────────────────────

  Widget _buildOverallScores(Room a, Room b) {
    final scoreA = a.matchingScore;
    final scoreB = b.matchingScore;
    final overallWinnerA = scoreA > scoreB;
    final overallWinnerB = scoreB > scoreA;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: _ScoreCard(
              label: a.title,
              score: scoreA,
              isWinner: overallWinnerA,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              const Text(
                'VS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: WasiColors.accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                overallWinnerA || overallWinnerB
                    ? overallWinnerA
                        ? '← Mejor match'
                        : 'Mejor match →'
                    : 'Empate',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: WasiColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ScoreCard(
              label: b.title,
              score: scoreB,
              isWinner: overallWinnerB,
            ),
          ),
        ],
      ),
    );
  }

  // ── Price Comparison ──────────────────────────────────────────────

  Widget _buildPriceComparison(Room a, Room b) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: WasiColors.secondaryContainer,
          borderRadius: WasiRadius.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💰 Comparación de precios',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: WasiColors.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PriceItem(
                    label: _shortTitle(a.title),
                    price: a.price,
                    deposit: a.depositAmount,
                    utilities: a.utilitiesCost,
                    isCheaper: a.price <= b.price,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PriceItem(
                    label: _shortTitle(b.title),
                    price: b.price,
                    deposit: b.depositAmount,
                    utilities: b.utilitiesCost,
                    isCheaper: b.price <= a.price,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Amenities Comparison ──────────────────────────────────────────

  Widget _buildAmenitiesComparison(Room a, Room b) {
    final allAmenities = <String>{...a.amenities, ...b.amenities}.toList()
      ..sort();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
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
            const Text(
              'Servicios',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            // Column headers
            Row(
              children: [
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    _shortTitle(a.title),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: WasiColors.textTertiaryLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    _shortTitle(b.title),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: WasiColors.textTertiaryLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            ...allAmenities.map((amenity) {
              final hasA = a.amenities.contains(amenity);
              final hasB = b.amenities.contains(amenity);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        amenity,
                        style: TextStyle(
                          fontSize: 12,
                          color: (hasA && hasB)
                              ? WasiColors.textPrimaryLight
                              : WasiColors.textSecondaryLight,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        hasA ? Icons.check_circle : Icons.cancel_outlined,
                        size: 16,
                        color: hasA
                            ? WasiColors.success
                            : WasiColors.textTertiaryLight,
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        hasB ? Icons.check_circle : Icons.cancel_outlined,
                        size: 16,
                        color: hasB
                            ? WasiColors.success
                            : WasiColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _shortTitle(String title) {
    if (title.length > 20) return '${title.substring(0, 20)}...';
    return title;
  }
}

// ── Header Card ─────────────────────────────────────────────────────

class _RoomHeaderCard extends StatelessWidget {
  final Room room;

  const _RoomHeaderCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: WasiColors.primaryContainer,
            child: Text(
              room.ownerAvatar,
              style: const TextStyle(
                color: WasiColors.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            room.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            room.district,
            style: const TextStyle(
              fontSize: 12,
              color: WasiColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Score Card ──────────────────────────────────────────────────────

class _ScoreCard extends StatelessWidget {
  final String label;
  final double score;
  final bool isWinner;

  const _ScoreCard({
    required this.label,
    required this.score,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWinner
            ? WasiColors.successContainer
            : WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: isWinner
              ? WasiColors.success.withValues(alpha: 0.4)
              : WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            '${score.round()}%',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: isWinner
                  ? WasiColors.onSuccessContainer
                  : WasiColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'de compatibilidad',
            style: TextStyle(
              fontSize: 11,
              color: isWinner
                  ? WasiColors.onSuccessContainer
                  : WasiColors.textTertiaryLight,
            ),
          ),
          if (isWinner) ...[
            const SizedBox(height: 6),
            const Icon(
              Icons.emoji_events,
              color: WasiColors.accent,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Price Item ──────────────────────────────────────────────────────

class _PriceItem extends StatelessWidget {
  final String label;
  final double price;
  final double deposit;
  final double utilities;
  final bool isCheaper;

  const _PriceItem({
    required this.label,
    required this.price,
    required this.deposit,
    required this.utilities,
    required this.isCheaper,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isCheaper
            ? WasiColors.successContainer.withValues(alpha: 0.5)
            : WasiColors.surfaceVariantLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 6),
          Text(
            F.pricePerMonth(price),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isCheaper
                  ? WasiColors.successDark
                  : WasiColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Depósito: ${F.price(deposit)}',
            style: const TextStyle(
              fontSize: 11,
              color: WasiColors.textSecondaryLight,
            ),
          ),
          Text(
            'Servicios: ${utilities > 0 ? F.pricePerMonth(utilities) : "Incluidos"}',
            style: const TextStyle(
              fontSize: 11,
              color: WasiColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
