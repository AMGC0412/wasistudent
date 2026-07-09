import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/room.dart';
import '../providers/room_provider.dart';
import '../utils/format_helpers.dart';
import 'room_detail_screen.dart';

/// Pantalla de favoritos.
/// Lista de habitaciones favoritas con toggle grid/lista, botón de
/// quitar de favoritos y estado vacío con ilustración.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: [
          IconButton(
            onPressed: () => setState(() => _isGridView = !_isGridView),
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
          ),
        ],
      ),
      body: Consumer<RoomProvider>(
        builder: (context, provider, _) {
          final favoriteRooms = provider.favorites;

          if (favoriteRooms.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadRooms(),
            color: WasiColors.primary,
            child: _isGridView
                ? _buildGridView(provider, favoriteRooms)
                : _buildListView(provider, favoriteRooms),
          );
        },
      ),
    );
  }

  // ── Grid View ──────────────────────────────────────────────────────

  Widget _buildGridView(RoomProvider provider, List<Room> rooms) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 240,
      ),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        return _FavoriteGridCard(
          room: rooms[index],
          onToggleFavorite: () => provider.toggleFavorite(rooms[index].id),
          onTap: () => _navigateToDetail(context, rooms[index]),
        );
      },
    );
  }

  // ── List View ──────────────────────────────────────────────────────

  Widget _buildListView(RoomProvider provider, List<Room> rooms) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: rooms.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _FavoriteListCard(
          room: rooms[index],
          onToggleFavorite: () => provider.toggleFavorite(rooms[index].id),
          onTap: () => _navigateToDetail(context, rooms[index]),
        );
      },
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
            // Illustration placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: WasiColors.accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 48,
                    color: WasiColors.accent.withValues(alpha: 0.5),
                  ),
                  Positioned(
                    top: 28,
                    right: 24,
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 20,
                      color: WasiColors.accent.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sin favoritos aún',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cuando encuentres habitaciones que te gusten, toca el corazón para guardarlas aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: WasiColors.textSecondaryLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Explorar habitaciones próximamente')),
                );
              },
              icon: const Icon(Icons.explore_outlined, size: 18),
              label: const Text('Explorar habitaciones'),
              style: ElevatedButton.styleFrom(
                backgroundColor: WasiColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Navigation ─────────────────────────────────────────────────────

  void _navigateToDetail(BuildContext context, Room room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RoomDetailScreen(roomId: room.id),
      ),
    );
  }
}

// ── Favorite List Card ───────────────────────────────────────────────

class _FavoriteListCard extends StatelessWidget {
  final Room room;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const _FavoriteListCard({
    required this.room,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: WasiRadius.card,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: WasiColors.surfaceLight,
          borderRadius: WasiRadius.card,
          border: Border.all(
            color: WasiColors.outlineLight.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            // ── Thumbnail ──
            ClipRRect(
              borderRadius: BorderRadius.circular(WasiRadius.md),
              child: Container(
                width: 80,
                height: 80,
                color: WasiColors.surfaceVariantLight,
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.home_outlined,
                        size: 32,
                        color: WasiColors.textTertiaryLight,
                      ),
                    ),
                    if (room.isUrgent)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: WasiColors.error,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Urgente',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 12, color: WasiColors.textTertiaryLight),
                      const SizedBox(width: 2),
                      Text(
                        room.district,
                        style: const TextStyle(
                          fontSize: 12,
                          color: WasiColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.directions_walk,
                          size: 12, color: WasiColors.textTertiaryLight),
                      const SizedBox(width: 2),
                      Text(
                        F.walkingTime(room.walkingTimeMin),
                        style: const TextStyle(
                          fontSize: 12,
                          color: WasiColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    F.pricePerMonth(room.price),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: WasiColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // ── Unfavorite Button ──
            IconButton(
              onPressed: onToggleFavorite,
              icon: const Icon(
                Icons.favorite,
                color: WasiColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Favorite Grid Card ───────────────────────────────────────────────

class _FavoriteGridCard extends StatelessWidget {
  final Room room;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const _FavoriteGridCard({
    required this.room,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: WasiRadius.card,
      child: Container(
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
            // ── Image Placeholder ──
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: WasiColors.surfaceVariantLight,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.home_outlined,
                      size: 40,
                      color: WasiColors.textTertiaryLight,
                    ),
                  ),
                ),
                if (room.isUrgent)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: WasiColors.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Urgente',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: onToggleFavorite,
                      icon: const Icon(
                        Icons.favorite,
                        color: WasiColors.error,
                        size: 20,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),

            // ── Info ──
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 11, color: WasiColors.textTertiaryLight),
                      Text(
                        room.district,
                        style: const TextStyle(
                          fontSize: 11,
                          color: WasiColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    F.pricePerMonth(room.price),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: WasiColors.primary,
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
}
