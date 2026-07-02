import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/notification.dart';
import '../providers/notification_provider.dart';

/// Pantalla de notificaciones.
/// Lista agrupada por hoy/ayer/anterior, con icono, título, cuerpo,
/// hora, punto de no leído y acción al tocar. Botón "Marcar todo como leído".
/// Estado vacío con ilustración.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              if (provider.unreadCount == 0) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () => provider.markAllAsRead(),
                icon: const Icon(Icons.done_all, size: 16),
                label: const Text('Leer todo'),
                style: TextButton.styleFrom(
                  foregroundColor: WasiColors.primary,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return _buildErrorState(provider);
          }

          final notifications = provider.getSortedNotifications();

          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          final grouped = _groupByDate(notifications);

          return RefreshIndicator(
            onRefresh: () => provider.loadNotifications(),
            color: WasiColors.primary,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final group = grouped[index];
                return _NotificationGroup(
                  label: group.label,
                  notifications: group.notifications,
                  onNotificationTap: (notification) {
                    provider.markAsRead(notification.id);
                    _handleNotificationAction(context, notification);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ── Group Notifications by Date ─────────────────────────────────────

  List<_NotificationGroupData> _groupByDate(List<AppNotification> notifications) {
    final now = DateTime.now();
    final today = <AppNotification>[];
    final yesterday = <AppNotification>[];
    final earlier = <AppNotification>[];

    for (final notif in notifications) {
      final diff = now.difference(notif.timestamp);
      if (diff.inDays == 0) {
        today.add(notif);
      } else if (diff.inDays == 1) {
        yesterday.add(notif);
      } else {
        earlier.add(notif);
      }
    }

    final groups = <_NotificationGroupData>[];
    if (today.isNotEmpty) groups.add(_NotificationGroupData('Hoy', today));
    if (yesterday.isNotEmpty) groups.add(_NotificationGroupData('Ayer', yesterday));
    if (earlier.isNotEmpty) groups.add(_NotificationGroupData('Anterior', earlier));

    return groups;
  }

  // ── Handle Tap ─────────────────────────────────────────────────────

  void _handleNotificationAction(BuildContext context, AppNotification notification) {
    if (notification.actionRoute != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navegar a: ${notification.actionRoute}')),
      );
    }
  }

  // ── Error State ────────────────────────────────────────────────────

  Widget _buildErrorState(NotificationProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: WasiColors.error),
            const SizedBox(height: 16),
            Text(
              provider.error ?? 'Error al cargar notificaciones',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: WasiColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => provider.loadNotifications(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: WasiColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: WasiColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 48,
                color: WasiColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sin notificaciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: WasiColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cuando tengas novedades sobre reservas, pagos o mensajes, las verás aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: WasiColors.textSecondaryLight,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Notification Group ───────────────────────────────────────────────

class _NotificationGroup extends StatelessWidget {
  final String label;
  final List<AppNotification> notifications;
  final ValueChanged<AppNotification> onNotificationTap;

  const _NotificationGroup({
    required this.label,
    required this.notifications,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: WasiColors.textTertiaryLight,
              letterSpacing: 0.3,
            ),
          ),
        ),
        ...notifications.map((notif) => _NotificationTile(
          notification: notif,
          onTap: () => onNotificationTap(notif),
        )),
      ],
    );
  }
}

// ── Notification Tile ────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isUnread
            ? WasiColors.primaryContainer.withValues(alpha: 0.2)
            : Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon ──
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification.colorValue.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.iconData,
                size: 20,
                color: notification.colorValue,
              ),
            ),
            const SizedBox(width: 12),

            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                            color: WasiColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: WasiColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: const TextStyle(
                      fontSize: 13,
                      color: WasiColors.textSecondaryLight,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.relativeTime,
                    style: const TextStyle(
                      fontSize: 11,
                      color: WasiColors.textTertiaryLight,
                      fontWeight: FontWeight.w500,
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

// ── Group Data Helper ────────────────────────────────────────────────

class _NotificationGroupData {
  final String label;
  final List<AppNotification> notifications;

  const _NotificationGroupData(this.label, this.notifications);
}
