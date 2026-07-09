import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../models/room.dart';
import '../../providers/room_provider.dart';
import '../../utils/format_helpers.dart';

/// Dashboard principal del panel de propietaria.
///
/// Muestra:
/// - Resumen de cuartos publicados (activos, vacantes).
/// - Solicitudes recibidas pendientes.
/// - Ingresos del mes actual.
/// - Accesos rápidos a las demás pantallas del panel.
class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roomProvider = context.watch<RoomProvider>();
    final rooms = roomProvider.allRooms;

    // Mock: asumimos que los primeros 4 rooms son del propietario actual.
    final myRooms = rooms.take(4).toList();
    final activeRooms = myRooms.where((r) => r.isActive).length;
    final vacancies = myRooms.length; // En mock todos están disponibles
    final monthlyIncome = myRooms.fold<double>(0, (sum, r) => sum + r.price);

    // Mock: solicitudes pendientes
    const pendingRequests = 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de propietaria'),
        actions: [
          IconButton(
            onPressed: () => context.push('/owner/rooms/new'),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Publicar cuarto',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => roomProvider.loadRooms(),
        child: CustomScrollView(
          slivers: [
            // ── Saludo y resumen ──
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [WasiColors.primary, WasiColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(WasiRadius.xl),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hola, doña Rosa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tienes 3 solicitudes pendientes de revisar',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _StatChip(
                          label: 'Cuartos activos',
                          value: '$activeRooms',
                          icon: Icons.home_work_outlined,
                        ),
                        const SizedBox(width: 8),
                        _StatChip(
                          label: 'Vacantes',
                          value: '$vacancies',
                          icon: Icons.bed_outlined,
                        ),
                        const SizedBox(width: 8),
                        _StatChip(
                          label: 'Solicitudes',
                          value: '$pendingRequests',
                          icon: Icons.notifications_active_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Ingresos del mes ──
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: WasiColors.successContainer,
                  borderRadius: BorderRadius.circular(WasiRadius.lg),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: WasiColors.success,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.payments_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ingresos mensuales estimados',
                            style: TextStyle(
                              fontSize: 12,
                              color: WasiColors.onSuccessContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            F.pricePerMonth(monthlyIncome),
                            style: const TextStyle(
                              fontSize: 24,
                              color: WasiColors.onSuccessContainer,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Accesos rápidos ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Accesos rápidos',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: WasiColors.textSecondaryLight,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.4,
                  children: [
                    _QuickAccessCard(
                      icon: Icons.home_work_outlined,
                      label: 'Mis cuartos',
                      subtitle: '${myRooms.length} publicados',
                      color: WasiColors.primary,
                      onTap: () => context.push('/owner/rooms'),
                    ),
                    _QuickAccessCard(
                      icon: Icons.mark_email_unread_outlined,
                      label: 'Solicitudes',
                      subtitle: '$pendingRequests pendientes',
                      color: WasiColors.accent,
                      onTap: () => context.push('/owner/requests'),
                    ),
                    _QuickAccessCard(
                      icon: Icons.receipt_long_outlined,
                      label: 'Contratos',
                      subtitle: 'Ver historial',
                      color: WasiColors.success,
                      onTap: () => context.push('/owner/contracts'),
                    ),
                    _QuickAccessCard(
                      icon: Icons.attach_money_outlined,
                      label: 'Ingresos',
                      subtitle: 'Pagos recibidos',
                      color: const Color(0xFF9C27B0),
                      onTap: () => context.push('/owner/payments'),
                    ),
                  ],
                ),
              ),
            ),

            // ── Mis cuartos ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mis cuartos publicados',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: WasiColors.textSecondaryLight,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/owner/rooms'),
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= myRooms.length) return null;
                  final room = myRooms[index];
                  return _OwnerRoomTile(room: room);
                },
                childCount: myRooms.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets internos ────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: WasiColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OwnerRoomTile extends StatelessWidget {
  final Room room;

  const _OwnerRoomTile({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: WasiColors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.home_work_outlined,
              color: WasiColors.onPrimaryContainer,
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
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: WasiColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 11,
                      color: WasiColors.textTertiaryLight,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      room.district,
                      style: TextStyle(
                        fontSize: 11,
                        color: WasiColors.textTertiaryLight,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.star,
                      size: 11,
                      color: WasiColors.accent,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      room.ownerRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: WasiColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                F.pricePerMonth(room.price),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: WasiColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: WasiColors.successContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Disponible',
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
    );
  }
}
