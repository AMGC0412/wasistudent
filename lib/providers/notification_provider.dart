import 'package:flutter/material.dart';

import '../models/notification.dart';

/// Proveedor de notificaciones para la aplicación WasiStudent.
/// Gestiona las notificaciones del usuario, estados de lectura
/// y filtrado por tipo.
class NotificationProvider extends ChangeNotifier {
  // ── Estado ──────────────────────────────────────────────────────

  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;

  // ── Getters ─────────────────────────────────────────────────────

  /// Lista de todas las notificaciones.
  List<AppNotification> get notifications => _notifications;

  /// Indica si hay una operación de carga en curso.
  bool get isLoading => _isLoading;

  /// Mensaje de error de la última operación fallida.
  String? get error => _error;

  /// Cantidad de notificaciones no leídas.
  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  // ── Constructor ─────────────────────────────────────────────────

  NotificationProvider() {
    loadNotifications();
  }

  // ── Carga de Datos ──────────────────────────────────────────────

  /// Carga las notificaciones desde los datos mock.
  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _notifications = AppNotification.mockNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error al cargar las notificaciones. Intenta de nuevo.';
      notifyListeners();
    }
  }

  // ── Acciones de Lectura ─────────────────────────────────────────

  /// Marca una notificación como leída.
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  /// Marca todas las notificaciones como leídas.
  void markAllAsRead() {
    bool hasUnread = _notifications.any((n) => !n.isRead);
    if (hasUnread) {
      _notifications = _notifications
          .map((n) => n.isRead ? n : n.copyWith(isRead: true))
          .toList();
      notifyListeners();
    }
  }

  // ── Eliminar ────────────────────────────────────────────────────

  /// Elimina una notificación por su ID.
  void deleteNotification(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications.removeAt(index);
      notifyListeners();
    }
  }

  // ── Filtrado por Tipo ───────────────────────────────────────────

  /// Obtiene notificaciones filtradas por tipo.
  List<AppNotification> getByType(String type) {
    final notifType = NotificationType.values.firstWhere(
      (t) => t.name == type,
      orElse: () => NotificationType.system,
    );
    return _notifications.where((n) => n.type == notifType).toList();
  }

  // ── Utilidades ──────────────────────────────────────────────────

  /// Obtiene las notificaciones no leídas.
  List<AppNotification> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  /// Obtiene las notificaciones ordenadas por fecha (más reciente primero).
  List<AppNotification> getSortedNotifications() {
    final sorted = List<AppNotification>.from(_notifications);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  /// Obtiene una notificación por su ID.
  AppNotification? getNotificationById(String id) {
    try {
      return _notifications.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }
}
