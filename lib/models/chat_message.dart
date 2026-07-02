/// Modelos de chat para la aplicación WasiStudent.
/// Incluye mensajes individuales y conversaciones completas.

library;

enum MessageType { text, image, system, document, contract }

class ChatMessage {
  final String id;
  final String roomId;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final MessageType type;

  final String? imageUrl;
  final String? documentUrl;

  const ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.type = MessageType.text,
    this.imageUrl,
    this.documentUrl,
  });

  /// Si el mensaje fue enviado por el usuario actual.
  bool isFromMe(String currentUserId) => senderId == currentUserId;

  /// Hora formateada del mensaje.
  String get timeFormatted {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Fecha relativa del mensaje.
  String get relativeDate {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';

    final months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${timestamp.day} ${months[timestamp.month - 1]}';
  }

  ChatMessage copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    MessageType? type,
    String? imageUrl,
    String? documentUrl,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      documentUrl: documentUrl ?? this.documentUrl,
    );
  }

  // ── Mock Data ─────────────────────────────────────────────────────

  static List<ChatMessage> mockMessages({
    String currentUserId = 'user-001',
    String otherUserId = 'owner-001',
    String roomId = 'room-001',
  }) {
    final now = DateTime.now();

    return [
      ChatMessage(
        id: 'msg-001',
        roomId: roomId,
        senderId: currentUserId,
        senderName: 'Valentina Rojas',
        senderAvatar: 'VR',
        content: 'Hola, vi su habitación en Wanchaq. ¿Aún está disponible?',
        timestamp: now.subtract(const Duration(hours: 3, minutes: 45)),
        isRead: true,
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg-002',
        roomId: roomId,
        senderId: otherUserId,
        senderName: 'María Elena Quispe',
        senderAvatar: 'MQ',
        content:
            '¡Hola Valentina! Sí, la habitación sigue disponible. Es muy cómoda y luminosa, perfecta para estudiar.',
        timestamp: now.subtract(const Duration(hours: 3, minutes: 30)),
        isRead: true,
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg-003',
        roomId: roomId,
        senderId: currentUserId,
        senderName: 'Valentina Rojas',
        senderAvatar: 'VR',
        content: '¡Qué bueno! ¿Puedo visitarla esta semana?',
        timestamp: now.subtract(const Duration(hours: 3, minutes: 20)),
        isRead: true,
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg-004',
        roomId: roomId,
        senderId: otherUserId,
        senderName: 'María Elena Quispe',
        senderAvatar: 'MQ',
        content:
            'Claro que sí. ¿Qué tal el jueves a las 4 de la tarde? Te puedo esperar en la puerta de la casa.',
        timestamp: now.subtract(const Duration(hours: 3, minutes: 10)),
        isRead: true,
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg-005',
        roomId: roomId,
        senderId: currentUserId,
        senderName: 'Valentina Rojas',
        senderAvatar: 'VR',
        content: 'Perfecto, el jueves a las 4 estoy ahí. ¿El precio incluye los servicios?',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 55)),
        isRead: true,
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg-006',
        roomId: roomId,
        senderId: otherUserId,
        senderName: 'María Elena Quispe',
        senderAvatar: 'MQ',
        content:
            'El alquiler es S/ 650 y los servicios (luz, agua, internet) son S/ 80 adicionales. El depósito es de un mes.',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 40)),
        isRead: true,
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg-007',
        roomId: roomId,
        senderId: otherUserId,
        senderName: 'María Elena Quispe',
        senderAvatar: 'MQ',
        content: 'Te envío unas fotos adicionales del cuarto y las áreas comunes.',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 35)),
        isRead: true,
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg-008',
        roomId: roomId,
        senderId: otherUserId,
        senderName: 'María Elena Quispe',
        senderAvatar: 'MQ',
        content: 'Vista del patio interior',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 30)),
        isRead: true,
        type: MessageType.image,
        imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=600',
      ),
      ChatMessage(
        id: 'msg-009',
        roomId: roomId,
        senderId: currentUserId,
        senderName: 'Valentina Rojas',
        senderAvatar: 'VR',
        content: '¡Se ve muy bonito! El patio es encantador. Una última pregunta, ¿puedo tener plantas en mi cuarto?',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 50)),
        isRead: true,
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg-010',
        roomId: roomId,
        senderId: otherUserId,
        senderName: 'María Elena Quispe',
        senderAvatar: 'MQ',
        content:
            '¡Por supuesto! Me encantan las plantas. La habitación tiene buena luz natural, así que tus plantitas estarán felices ahí 😊',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 30)),
        isRead: false,
        type: MessageType.text,
      ),
    ];
  }
}

class ChatConversation {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? roomId;
  final bool isOnline;
  final bool isOwner;

  const ChatConversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.roomId,
    this.isOnline = false,
    this.isOwner = false,
  });

  /// Hora relativa para mostrar en la lista de conversaciones.
  String get timeLabel {
    final now = DateTime.now();
    final diff = now.difference(lastMessageTime);

    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) {
      return '${lastMessageTime.hour.toString().padLeft(2, '0')}:${lastMessageTime.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} d';

    final months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${lastMessageTime.day} ${months[lastMessageTime.month - 1]}';
  }

  ChatConversation copyWith({
    String? id,
    String? otherUserId,
    String? otherUserName,
    String? otherUserAvatar,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    String? roomId,
    bool? isOnline,
    bool? isOwner,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserAvatar: otherUserAvatar ?? this.otherUserAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      roomId: roomId ?? this.roomId,
      isOnline: isOnline ?? this.isOnline,
      isOwner: isOwner ?? this.isOwner,
    );
  }

  // ── Mock Data ─────────────────────────────────────────────────────

  static List<ChatConversation> mockConversations() {
    final now = DateTime.now();

    return [
      ChatConversation(
        id: 'conv-001',
        otherUserId: 'owner-001',
        otherUserName: 'María Elena Quispe',
        otherUserAvatar: 'MQ',
        lastMessage: '¡Por supuesto! Me encantan las plantas 😊',
        lastMessageTime: now.subtract(const Duration(hours: 1, minutes: 30)),
        unreadCount: 1,
        roomId: 'room-001',
        isOnline: true,
        isOwner: true,
      ),
      ChatConversation(
        id: 'conv-002',
        otherUserId: 'owner-002',
        otherUserName: 'Carlos Mendoza',
        otherUserAvatar: 'CM',
        lastMessage: 'El estudio estará libre desde marzo. ¿Te interesa?',
        lastMessageTime: now.subtract(const Duration(hours: 5)),
        unreadCount: 2,
        roomId: 'room-002',
        isOnline: false,
        isOwner: true,
      ),
      ChatConversation(
        id: 'conv-003',
        otherUserId: 'owner-012',
        otherUserName: 'Familia Mamani-Loayza',
        otherUserAvatar: 'ML',
        lastMessage: '¡Sería un gusto tenerte en casa! Nélida prepara una sopa deliciosa.',
        lastMessageTime: now.subtract(const Duration(days: 1)),
        unreadCount: 0,
        roomId: 'room-012',
        isOnline: true,
        isOwner: true,
      ),
      ChatConversation(
        id: 'conv-004',
        otherUserId: 'owner-006',
        otherUserName: 'Carmen Puma de Rojas',
        otherUserAvatar: 'CR',
        lastMessage: 'Solo para mujeres, mi hijita. Pero eres bienvenida.',
        lastMessageTime: now.subtract(const Duration(days: 2)),
        unreadCount: 0,
        roomId: 'room-006',
        isOnline: false,
        isOwner: true,
      ),
      ChatConversation(
        id: 'conv-005',
        otherUserId: 'owner-005',
        otherUserName: 'Arq. Lucía Salazar',
        otherUserAvatar: 'LS',
        lastMessage: 'Puedo mostrarte la suite este sábado. ¿A las 11 te queda bien?',
        lastMessageTime: now.subtract(const Duration(days: 3, hours: 4)),
        unreadCount: 1,
        roomId: 'room-005',
        isOnline: false,
        isOwner: true,
      ),
      ChatConversation(
        id: 'conv-006',
        otherUserId: 'owner-009',
        otherUserName: 'Dra. Ana María Zamora',
        otherUserAvatar: 'AZ',
        lastMessage: 'La vista desde la habitación es impresionante, especialmente al amanecer.',
        lastMessageTime: now.subtract(const Duration(days: 4)),
        unreadCount: 0,
        roomId: 'room-009',
        isOnline: false,
        isOwner: true,
      ),
    ];
  }
}
