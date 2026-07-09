import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../models/room.dart';
import '../../providers/room_provider.dart';
import '../../utils/format_helpers.dart';

/// Lista de cuartos publicados por la propietaria.
///
/// Permite ver, editar y desactivar cuartos. Botón flotante para
/// publicar un cuarto nuevo.
class OwnerRoomsListScreen extends StatelessWidget {
  const OwnerRoomsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roomProvider = context.watch<RoomProvider>();
    final myRooms = roomProvider.allRooms.take(6).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis cuartos'),
        actions: [
          IconButton(
            onPressed: () => context.push('/owner/rooms/new'),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Publicar cuarto',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: myRooms.length,
        itemBuilder: (context, index) {
          final room = myRooms[index];
          return _OwnerRoomCard(room: room);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/owner/rooms/new'),
        icon: const Icon(Icons.add),
        label: const Text('Publicar cuarto'),
        heroTag: 'add_room_fab',
      ),
    );
  }
}

class _OwnerRoomCard extends StatelessWidget {
  final Room room;

  const _OwnerRoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: WasiColors.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.home_work_outlined,
                    color: WasiColors.onPrimaryContainer,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: WasiColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: WasiColors.textTertiaryLight,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            room.district,
                            style: TextStyle(
                              fontSize: 12,
                              color: WasiColors.textTertiaryLight,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.directions_walk_rounded,
                            size: 12,
                            color: WasiColors.textTertiaryLight,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${room.walkingTimeMin} min UNSAAC',
                            style: TextStyle(
                              fontSize: 11,
                              color: WasiColors.textTertiaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            F.pricePerMonth(room.price),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: WasiColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (room.verificationLevel >= 2)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: WasiColors.successContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Verificado',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: WasiColors.onSuccessContainer,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Stats
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: WasiColors.surfaceVariantLight.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _miniStat(Icons.visibility_outlined, '${room.viewCount}', 'vistas'),
                _miniStat(Icons.favorite_outline, '${room.favoriteCount}', 'favoritos'),
                _miniStat(Icons.star_outline, '${room.reviewCount}', 'reseñas'),
                _miniStat(Icons.share_outlined, '0', 'solicitudes'),
              ],
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: navegar a edición
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Edición de cuarto próximamente (cascarón mockup)',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Editar'),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: () => context.push('/room/${room.id}'),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('Ver'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: WasiColors.textSecondaryLight),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: WasiColors.textPrimaryLight,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: WasiColors.textTertiaryLight,
          ),
        ),
      ],
    );
  }
}
