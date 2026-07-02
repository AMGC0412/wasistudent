import 'package:flutter/material.dart';

/// Modelo de notificaciones para la aplicación WasiStudent.
/// Cubre todos los tipos de alertas relevantes para estudiantes
/// que buscan o viven en alojamiento en Cusco.

enum NotificationType {
  booking,
  review,
  payment,
  reminder,
  system,
  promo,
  message,
  trust,
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final String icon;
  final String color; // Hex color

  final DateTime timestamp;
  final bool isRead;

  final String? actionRoute;
  final Map<String, String>? actionParams;
  final String? imageUrl;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.icon = 'notifications',
    this.color = '#2196F3',
    required this.timestamp,
    this.isRead = false,
    this.actionRoute,
    this.actionParams,
    this.imageUrl,
  });

  // ── Computed Getters ──────────────────────────────────────────────

  /// Tiempo relativo desde la notificación.
  String get relativeTime {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} d';
    if (diff.inDays < 30) return 'Hace ${diff.inDays ~/ 7} sem';
    return 'Hace ${diff.inDays ~/ 30} meses';
  }

  /// Color como objeto Color de Flutter.
  Color get colorValue {
    final hex = color.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  /// Icono como IconData de Material.
  IconData get iconData {
    switch (type) {
      case NotificationType.booking:
        return Icons.event_available;
      case NotificationType.review:
        return Icons.star;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.system:
        return Icons.info;
      case NotificationType.promo:
        return Icons.local_offer;
      case NotificationType.message:
        return Icons.chat_bubble;
      case NotificationType.trust:
        return Icons.verified_user;
    }
  }

  /// Tipo de notificación en español.
  String get typeLabel {
    switch (type) {
      case NotificationType.booking:
        return 'Reserva';
      case NotificationType.review:
        return 'Reseña';
      case NotificationType.payment:
        return 'Pago';
      case NotificationType.reminder:
        return 'Recordatorio';
      case NotificationType.system:
        return 'Sistema';
      case NotificationType.promo:
        return 'Promoción';
      case NotificationType.message:
        return 'Mensaje';
      case NotificationType.trust:
        return 'Confianza';
    }
  }

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? body,
    String? icon,
    String? color,
    DateTime? timestamp,
    bool? isRead,
    String? actionRoute,
    Map<String, String>? actionParams,
    String? imageUrl,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      actionParams: actionParams ?? this.actionParams,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // ── Mock Data ─────────────────────────────────────────────────────

  static List<AppNotification> mockNotifications() {
    final now = DateTime.now();

    return [
      AppNotification(
        id: 'notif-001',
        type: NotificationType.booking,
        title: 'Visita confirmada',
        body:
            'Tu visita a "Habitación luminosa cerca de la UNSAAC" está confirmada para el jueves a las 4:00 PM. ¡No olvides llevar tu DNI!',
        icon: 'event_available',
        color: '#4CAF50',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        actionRoute: '/room/room-001',
        actionParams: {'roomId': 'room-001'},
      ),
      AppNotification(
        id: 'notif-002',
        type: NotificationType.trust,
        title: '¡Nuevo nivel de confianza!',
        body:
            'Has alcanzado el nivel "Bueno" en tu puntuación de confianza. ¡Sigue así! Los propietarios confían más en inquilinos verificados.',
        icon: 'verified_user',
        color: '#FF9800',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: false,
        actionRoute: '/trust',
      ),
      AppNotification(
        id: 'notif-003',
        type: NotificationType.payment,
        title: 'Recordatorio de pago',
        body:
            'Tu alquiler de S/ 650 vence en 5 días. Recuerda que el pago puntual mejora tu puntuación de confianza.',
        icon: 'payment',
        color: '#F44336',
        timestamp: now.subtract(const Duration(hours: 8)),
        isRead: false,
        actionRoute: '/payments',
      ),
      AppNotification(
        id: 'notif-004',
        type: NotificationType.message,
        title: 'Nuevo mensaje',
        body: 'María Elena Quispe te envió un mensaje sobre la habitación en Wanchaq.',
        icon: 'chat_bubble',
        color: '#2196F3',
        timestamp: now.subtract(const Duration(hours: 12)),
        isRead: true,
        actionRoute: '/chat/conv-001',
        actionParams: {'conversationId': 'conv-001'},
      ),
      AppNotification(
        id: 'notif-005',
        type: NotificationType.review,
        title: 'Nueva reseña en tu zona',
        body:
            'Alguien dejó una reseña de 5 estrellas en "Habitación con vista a Sacsayhuamán". Échale un vistazo.',
        icon: 'star',
        color: '#FFC107',
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        isRead: true,
        actionRoute: '/room/room-009',
        actionParams: {'roomId': 'room-009'},
      ),
      AppNotification(
        id: 'notif-006',
        type: NotificationType.reminder,
        title: 'Completa tu perfil',
        body:
            'Los perfiles completos reciben 3x más respuestas de propietarios. Agrega tu foto y verify tu identidad para mejorar tus posibilidades.',
        icon: 'alarm',
        color: '#9C27B0',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        actionRoute: '/profile',
      ),
      AppNotification(
        id: 'notif-007',
        type: NotificationType.promo,
        title: '🏡 Semana del estudiante cusqueño',
        body:
            '¡10% de descuento en depósitos esta semana! Usa el código ESTUDIANTE10 al reservar. Válido hasta el 15 de abril.',
        icon: 'local_offer',
        color: '#E91E63',
        timestamp: now.subtract(const Duration(days: 2, hours: 6)),
        isRead: false,
        actionRoute: '/promo/student-week',
      ),
      AppNotification(
        id: 'notif-008',
        type: NotificationType.system,
        title: 'Actualización de términos',
        body:
            'Hemos actualizado nuestros Términos de Servicio y Política de Privacidad. Tu uso continuo implica aceptación de los cambios.',
        icon: 'info',
        color: '#607D8B',
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
        actionRoute: '/terms',
      ),
      AppNotification(
        id: 'notif-009',
        type: NotificationType.booking,
        title: 'Nueva coincidencia',
        body:
            'Encontramos 3 habitaciones nuevas que coinciden con tus preferencias en Wanchaq. ¡Míralas antes que nadie!',
        icon: 'event_available',
        color: '#4CAF50',
        timestamp: now.subtract(const Duration(days: 4)),
        isRead: true,
        actionRoute: '/search',
        actionParams: {'district': 'Wanchaq'},
      ),
      AppNotification(
        id: 'notif-010',
        type: NotificationType.trust,
        title: 'Insignia desbloqueada',
        body:
            '¡Felicidades! Has obtenido la insignia "Respuesta rápida". Los propietarios valoran a inquilinos que responden pronto.',
        icon: 'bolt',
        color: '#FF9800',
        timestamp: now.subtract(const Duration(days: 5)),
        isRead: true,
        actionRoute: '/trust',
      ),
      AppNotification(
        id: 'notif-011',
        type: NotificationType.payment,
        title: 'Pago recibido',
        body:
            'Tu pago de S/ 730 por "Habitación luminosa cerca de la UNSAAC" ha sido registrado. Recibo #KW-2025-0342.',
        icon: 'payment',
        color: '#4CAF50',
        timestamp: now.subtract(const Duration(days: 6)),
        isRead: true,
        actionRoute: '/payments',
      ),
      AppNotification(
        id: 'notif-012',
        type: NotificationType.message,
        title: 'Familia Mamani-Loayza te escribió',
        body:
            '¡Hola! Tenemos disponibilidad desde agosto. Si te interesa la experiencia de homestay, escríbenos para coordinar. ¡Te esperamos!',
        icon: 'chat_bubble',
        color: '#2196F3',
        timestamp: now.subtract(const Duration(days: 7)),
        isRead: true,
        actionRoute: '/chat/conv-003',
        actionParams: {'conversationId': 'conv-003'},
      ),
    ];
  }
}
