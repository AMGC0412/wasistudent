import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Servicio de notificaciones para WasiStudent.
/// Gestiona notificaciones locales (recordatorios de pago, nuevos matches,
/// mensajes, etc.) usando flutter_local_notifications.
///
/// Configura canales diferentes para Android (por importancia) y
/// maneja permisos de notificación en iOS.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Indica si el servicio ya fue inicializado.
  bool get isInitialized => _initialized;

  // ── IDs de canal para Android ──────────────────────────────────────
  static const String _defaultChannelId = 'wasistudent_default';
  static const String _defaultChannelName = 'WasiStudent';
  static const String _defaultChannelDescription =
      'Notificaciones generales de WasiStudent';

  static const String _paymentsChannelId = 'wasistudent_payments';
  static const String _paymentsChannelName = 'Pagos';
  static const String _paymentsChannelDescription =
      'Recordatorios y alertas de pagos';

  static const String _matchesChannelId = 'wasistudent_matches';
  static const String _matchesChannelName = 'Matches';
  static const String _matchesChannelDescription =
      'Nuevas habitaciones que coinciden con tus preferencias';

  static const String _messagesChannelId = 'wasistudent_messages';
  static const String _messagesChannelName = 'Mensajes';
  static const String _messagesChannelDescription =
      'Mensajes de propietarios y compañeros';

  // ── Inicialización ─────────────────────────────────────────────────

  /// Inicializa el servicio de notificaciones locales.
  ///
  /// Debe llamarse una vez al inicio de la app, idealmente en `main()`
  /// antes de `runApp()`.
  ///
  /// Configura los canales de notificación para Android y solicita
  /// permisos en iOS.
  Future<bool> initialize() async {
    if (_initialized) return true;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      final result = await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (result != null && result) {
        _initialized = true;

        // Solicitar permisos en Android 13+
        if (Platform.isAndroid) {
          final androidPlugin =
              _plugin.resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
          if (androidPlugin != null) {
            await androidPlugin.requestNotificationsPermission();
          }
        }

        // Crear canales de notificación en Android
        await _createNotificationChannels();
      }

      return _initialized;
    } catch (_) {
      return false;
    }
  }

  /// Crea los canales de notificación para Android.
  Future<void> _createNotificationChannels() async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    final channels = [
      const AndroidNotificationChannel(
        _defaultChannelId,
        _defaultChannelName,
        description: _defaultChannelDescription,
        importance: Importance.defaultImportance,
      ),
      const AndroidNotificationChannel(
        _paymentsChannelId,
        _paymentsChannelName,
        description: _paymentsChannelDescription,
        importance: Importance.high,
      ),
      const AndroidNotificationChannel(
        _matchesChannelId,
        _matchesChannelName,
        description: _matchesChannelDescription,
        importance: Importance.defaultImportance,
      ),
      const AndroidNotificationChannel(
        _messagesChannelId,
        _messagesChannelName,
        description: _messagesChannelDescription,
        importance: Importance.high,
      ),
    ];

    for (final channel in channels) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  /// Callback cuando el usuario toca una notificación.
  void _onNotificationTapped(NotificationResponse response) {
    // Aquí se puede navegar a la pantalla correspondiente
    // usando el payload de la notificación.
    // Por ahora solo registramos el payload.
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      // TODO: Implementar navegación basada en payload
    }
  }

  // ── Mostrar notificación inmediata ─────────────────────────────────

  /// Muestra una notificación local inmediatamente.
  ///
  /// Parámetros:
  /// - [title]: Título de la notificación (requerido)
  /// - [body]: Cuerpo del mensaje (requerido)
  /// - [payload]: Datos adicionales para navegación (opcional)
  /// - [channelId]: ID del canal de Android (por defecto el canal general)
  /// - [id]: ID único de la notificación (por defecto genera uno basado en tiempo)
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = _defaultChannelId,
    String channelName = _defaultChannelName,
    int? id,
  }) async {
    if (!_initialized) await initialize();

    final notificationId = id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;

    const androidDetails = AndroidNotificationDetails(
      _defaultChannelId,
      _defaultChannelName,
      channelDescription: _defaultChannelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Usar detalles específicos del canal si se proporciona
    AndroidNotificationDetails androidSpecific;
    if (channelId == _paymentsChannelId) {
      androidSpecific = const AndroidNotificationDetails(
        _paymentsChannelId,
        _paymentsChannelName,
        channelDescription: _paymentsChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        autoCancel: false,
      );
    } else if (channelId == _matchesChannelId) {
      androidSpecific = const AndroidNotificationDetails(
        _matchesChannelId,
        _matchesChannelName,
        channelDescription: _matchesChannelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        showWhen: true,
      );
    } else if (channelId == _messagesChannelId) {
      androidSpecific = const AndroidNotificationDetails(
        _messagesChannelId,
        _messagesChannelName,
        channelDescription: _messagesChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );
    } else {
      androidSpecific = androidDetails;
    }

    final details = NotificationDetails(
      android: androidSpecific,
      iOS: iosDetails,
    );

    await _plugin.show(
      notificationId,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // ── Notificaciones de pagos ────────────────────────────────────────

  /// Muestra una notificación de recordatorio de pago.
  Future<void> showPaymentReminder({
    required String roomTitle,
    required double amount,
    required DateTime dueDate,
    String? payload,
  }) async {
    final daysLeft = dueDate.difference(DateTime.now()).inDays;
    String body;

    if (daysLeft <= 0) {
      body = 'Tu pago de S/ ${amount.toStringAsFixed(0)} por "$roomTitle" '
          'está vencido. Realiza el pago lo antes posible.';
    } else if (daysLeft == 1) {
      body = 'Mañana vence tu pago de S/ ${amount.toStringAsFixed(0)} '
          'por "$roomTitle". ¡No olvides pagar!';
    } else if (daysLeft <= 5) {
      body = 'Faltan $daysLeft días para el vencimiento de tu pago de '
          'S/ ${amount.toStringAsFixed(0)} por "$roomTitle".';
    } else {
      body = 'Tu pago de S/ ${amount.toStringAsFixed(0)} por "$roomTitle" '
          'vence en $daysLeft días.';
    }

    await showLocalNotification(
      title: daysLeft <= 0
          ? '¡Pago vencido!'
          : daysLeft == 1
              ? '¡Pago mañana!'
              : 'Recordatorio de pago',
      body: body,
      payload: payload,
      channelId: _paymentsChannelId,
      channelName: _paymentsChannelName,
    );
  }

  /// Muestra una notificación de nuevo match.
  Future<void> showNewMatchNotification({
    required String roomTitle,
    required double matchScore,
    String? payload,
  }) async {
    await showLocalNotification(
      title: '¡Nuevo match encontrado!',
      body: '"$roomTitle" tiene un ${matchScore.toStringAsFixed(0)}% '
          'de compatibilidad contigo. ¡Mírala ahora!',
      payload: payload,
      channelId: _matchesChannelId,
      channelName: _matchesChannelName,
    );
  }

  /// Muestra una notificación de nuevo mensaje.
  Future<void> showMessageNotification({
    required String senderName,
    required String messagePreview,
    String? payload,
  }) async {
    await showLocalNotification(
      title: senderName,
      body: messagePreview.length > 80
          ? '${messagePreview.substring(0, 80)}...'
          : messagePreview,
      payload: payload,
      channelId: _messagesChannelId,
      channelName: _messagesChannelName,
    );
  }

  // ── Programar notificación futura ──────────────────────────────────

  /// Programa una notificación para mostrarse en una fecha futura.
  ///
  /// Parámetros:
  /// - [title]: Título de la notificación
  /// - [body]: Cuerpo del mensaje
  /// - [scheduledDate]: Fecha y hora en que debe mostrarse
  /// - [id]: ID único de la notificación (para poder cancelarla)
  /// - [payload]: Datos adicionales
  /// - [channelId]: Canal de Android
  Future<void> scheduleReminder({
    required String title,
    required String body,
    required DateTime scheduledDate,
    int? id,
    String? payload,
    String channelId = _defaultChannelId,
  }) async {
    if (!_initialized) await initialize();

    // No programar en el pasado
    if (scheduledDate.isBefore(DateTime.now())) return;

    final notificationId =
        id ?? scheduledDate.millisecondsSinceEpoch ~/ 1000;

    const androidDetails = AndroidNotificationDetails(
      _defaultChannelId,
      _defaultChannelName,
      channelDescription: _defaultChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      _scheduleTZDateTime(scheduledDate),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Programa un recordatorio de pago recurrente.
  /// Envía notificación 5 días antes del vencimiento de cada mes.
  Future<void> schedulePaymentReminder({
    required String roomTitle,
    required double amount,
    required int dueDay, // Día del mes (1-31)
    int monthsAhead = 3, // Programar los próximos N meses
    String? payload,
  }) async {
    final now = DateTime.now();

    for (int i = 0; i < monthsAhead; i++) {
      DateTime reminderDate = DateTime(
        now.month + i > 12 ? now.year + 1 : now.year,
        now.month + i > 12 ? now.month + i - 12 : now.month + i,
        dueDay - 5, // 5 días antes
        9, // 9:00 AM
        0,
      );

      // Si la fecha ya pasó, programar para el siguiente mes
      if (reminderDate.isBefore(now)) continue;

      await scheduleReminder(
        title: 'Recordatorio de pago',
        body: 'Tu alquiler de S/ ${amount.toStringAsFixed(0)} por '
            '"$roomTitle" vence el día $dueDay. ¡Prepárate para pagar!',
        scheduledDate: reminderDate,
        payload: payload,
        channelId: _paymentsChannelId,
      );
    }
  }

  // ── Cancelar notificaciones ────────────────────────────────────────

  /// Cancela una notificación específica por su ID.
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  /// Cancela todas las notificaciones pendientes y activas.
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  // ── Notificaciones pendientes ──────────────────────────────────────

  /// Retorna las notificaciones pendientes (programadas).
  /// Nota: Esta funcionalidad es limitada en iOS.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  // ── Helpers ────────────────────────────────────────────────────────

  /// Convierte un DateTime a TZDateTime para la zona horaria local.
  tz.TZDateTime _scheduleTZDateTime(DateTime dateTime) {
    tz_data.initializeTimeZones();
    return tz.TZDateTime.from(dateTime, tz.local);
  }
}
