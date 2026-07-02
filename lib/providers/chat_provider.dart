import 'package:flutter/material.dart';

import '../models/chat_message.dart';

/// Proveedor de chat para la aplicación WasiStudent.
/// Gestiona las conversaciones, mensajes y estados de lectura
/// para la comunicación entre estudiantes y propietarios.
class ChatProvider extends ChangeNotifier {
  // ── Estado ──────────────────────────────────────────────────────

  List<ChatConversation> _conversations = [];
  Map<String, List<ChatMessage>> _messages = {};
  String? _activeConversationId;
  bool _isLoading = false;
  String? _error;

  // ── Getters ─────────────────────────────────────────────────────

  /// Lista de todas las conversaciones.
  List<ChatConversation> get conversations => _conversations;

  /// ID de la conversación activa actualmente.
  String? get activeConversationId => _activeConversationId;

  /// Indica si hay una operación de carga en curso.
  bool get isLoading => _isLoading;

  /// Mensaje de error de la última operación fallida.
  String? get error => _error;

  /// Conversaciones ordenadas por última actividad (más reciente primero).
  List<ChatConversation> get sortedConversations {
    final sorted = List<ChatConversation>.from(_conversations);
    sorted.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return sorted;
  }

  /// Total de mensajes no leídos en todas las conversaciones.
  int get totalUnreadCount =>
      _conversations.fold(0, (sum, c) => sum + c.unreadCount);

  /// Conversación activa actual.
  ChatConversation? get activeConversation {
    if (_activeConversationId == null) return null;
    try {
      return _conversations.firstWhere((c) => c.id == _activeConversationId);
    } catch (e) {
      return null;
    }
  }

  // ── Constructor ─────────────────────────────────────────────────

  ChatProvider() {
    loadConversations();
  }

  // ── Carga de Datos ──────────────────────────────────────────────

  /// Carga las conversaciones desde los datos mock.
  Future<void> loadConversations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      _conversations = ChatConversation.mockConversations();

      // Precargar mensajes para cada conversación
      for (final conv in _conversations) {
        if (conv.roomId != null) {
          _messages[conv.id] = ChatMessage.mockMessages(
            roomId: conv.roomId!,
          );
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error al cargar las conversaciones. Intenta de nuevo.';
      notifyListeners();
    }
  }

  // ── Mensajes ────────────────────────────────────────────────────

  /// Obtiene los mensajes de una conversación específica.
  List<ChatMessage> getMessages(String conversationId) {
    return _messages[conversationId] ?? [];
  }

  /// Envía un mensaje en una conversación.
  void sendMessage(String conversationId, String content) {
    if (content.trim().isEmpty) return;

    final conv = _conversations.where((c) => c.id == conversationId).firstOrNull;
    if (conv == null) return;

    final now = DateTime.now();
    final messageId = 'msg-${now.millisecondsSinceEpoch}';

    final message = ChatMessage(
      id: messageId,
      roomId: conv.roomId ?? '',
      senderId: 'user-001', // Usuario actual mock
      senderName: 'Valentina Rojas',
      senderAvatar: 'VR',
      content: content.trim(),
      timestamp: now,
      isRead: true,
      type: MessageType.text,
    );

    // Agregar mensaje a la lista
    if (!_messages.containsKey(conversationId)) {
      _messages[conversationId] = [];
    }
    _messages[conversationId]!.add(message);

    // Actualizar última actividad de la conversación
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _conversations[convIndex] = _conversations[convIndex].copyWith(
        lastMessage: content.trim(),
        lastMessageTime: now,
      );
    }

    notifyListeners();

    // Simular respuesta automática después de un breve delay
    _simulateReply(conversationId, conv);
  }

  /// Simula una respuesta del propietario (solo para desarrollo).
  Future<void> _simulateReply(String conversationId, ChatConversation conv) async {
    await Future.delayed(const Duration(seconds: 2));

    final now = DateTime.now();
    final replyId = 'msg-reply-${now.millisecondsSinceEpoch}';

    final replies = [
      '¡Gracias por tu mensaje! Te responderé en breve.',
      'Entendido, lo tendré en cuenta.',
      '¡Perfecto! Nos pondremos de acuerdo.',
      'Claro que sí, sin problema.',
      'Te lo confirmo en un momento.',
    ];

    final reply = ChatMessage(
      id: replyId,
      roomId: conv.roomId ?? '',
      senderId: conv.otherUserId,
      senderName: conv.otherUserName,
      senderAvatar: conv.otherUserAvatar,
      content: replies[DateTime.now().millisecond % replies.length],
      timestamp: now,
      isRead: false,
      type: MessageType.text,
    );

    _messages[conversationId]?.add(reply);

    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _conversations[convIndex] = _conversations[convIndex].copyWith(
        lastMessage: reply.content,
        lastMessageTime: now,
        unreadCount: _conversations[convIndex].unreadCount + 1,
      );
    }

    notifyListeners();
  }

  // ── Conversación Activa ─────────────────────────────────────────

  /// Establece la conversación activa.
  void setActiveConversation(String? id) {
    _activeConversationId = id;
    if (id != null) {
      // Marcar como leído al abrir
      markAsRead(id);
    }
    notifyListeners();
  }

  // ── Lectura ─────────────────────────────────────────────────────

  /// Marca una conversación como leída.
  void markAsRead(String conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1 && _conversations[index].unreadCount > 0) {
      _conversations[index] = _conversations[index].copyWith(unreadCount: 0);

      // Marcar todos los mensajes recibidos como leídos
      final msgs = _messages[conversationId];
      if (msgs != null) {
        _messages[conversationId] = msgs
            .map((m) => m.senderId != 'user-001' ? m.copyWith(isRead: true) : m)
            .toList();
      }

      notifyListeners();
    }
  }

  // ── Utilidades ──────────────────────────────────────────────────

  /// Obtiene una conversación por su ID.
  ChatConversation? getConversationById(String id) {
    try {
      return _conversations.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Indica si hay mensajes no leídos en una conversación.
  bool hasUnread(String conversationId) {
    final conv = getConversationById(conversationId);
    return conv != null && conv.unreadCount > 0;
  }
}
