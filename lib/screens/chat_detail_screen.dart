import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';

/// Pantalla de detalle de conversación.
/// Muestra mensajes con burbujas diferenciadas (enviado/recibido),
/// indicador de escritura, campo de entrada con botón de enviar,
/// botón de adjuntar imagen y auto-scroll al fondo.
class ChatDetailScreen extends StatefulWidget {
  final String conversationId;

  const ChatDetailScreen({super.key, required this.conversationId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
    // Scroll al fondo después de que se renderice
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isComposing = _messageController.text.trim().isNotEmpty;
    if (isComposing != _isComposing) {
      setState(() => _isComposing = isComposing);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final provider = context.read<ChatProvider>();
    provider.sendMessage(widget.conversationId, text);
    _messageController.clear();

    // Scroll después de enviar
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        title: _buildAppBarTitle(),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$value próximamente')),
              );
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'Ver perfil', child: Text('Ver perfil')),
              const PopupMenuItem(value: 'Silenciar', child: Text('Silenciar')),
              const PopupMenuItem(value: 'Bloquear', child: Text('Bloquear')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Messages List ──
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, _) {
                final messages = provider.getMessages(widget.conversationId);

                if (messages.isEmpty) {
                  final conversation = provider.sortedConversations.firstWhere(
                    (c) => c.id == widget.conversationId,
                    orElse: () => ChatConversation(
                      id: widget.conversationId,
                      otherUserId: '',
                      otherUserName: 'Usuario',
                      otherUserAvatar: 'U',
                      lastMessage: '',
                      lastMessageTime: DateTime.now(),
                      unreadCount: 0,
                      roomId: '',
                    ),
                  );
                  return _buildEmptyMessages(conversation);
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isFromMe = message.isFromMe('user-001');
                    final showAvatar = _shouldShowAvatar(messages, index);

                    return _MessageBubble(
                      message: message,
                      isFromMe: isFromMe,
                      showAvatar: showAvatar,
                    );
                  },
                );
              },
            ),
          ),

          // ── Typing Indicator ──
          Consumer<ChatProvider>(
            builder: (context, provider, _) {
              final messages = provider.getMessages(widget.conversationId);
              if (messages.isEmpty) return const SizedBox.shrink();

              final lastMsg = messages.last;
              final isTyping = !lastMsg.isFromMe('user-001') &&
                  !lastMsg.isRead &&
                  DateTime.now().difference(lastMsg.timestamp).inSeconds < 3;

              if (isTyping) {
                return const _TypingIndicator();
              }
              return const SizedBox.shrink();
            },
          ),

          // ── Message Input ──
          _buildMessageInput(),
        ],
      ),
    );
  }

  // ── AppBar Title ───────────────────────────────────────────────────

  Widget _buildAppBarTitle() {
    final chatProvider = context.watch<ChatProvider>();
    final conversation = chatProvider.sortedConversations.firstWhere(
      (c) => c.id == widget.conversationId,
      orElse: () => ChatConversation(
        id: widget.conversationId,
        otherUserId: '',
        otherUserName: 'Usuario',
        otherUserAvatar: 'U',
        lastMessage: '',
        lastMessageTime: DateTime.now(),
        unreadCount: 0,
        roomId: '',
      ),
    );
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: WasiColors.primaryContainer,
          child: Text(
            conversation.otherUserAvatar,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: WasiColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                conversation.otherUserName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                conversation.isOnline ? 'En línea' : 'Desconectado/a',
                style: TextStyle(
                  fontSize: 11,
                  color: conversation.isOnline
                      ? WasiColors.success
                      : WasiColors.textTertiaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Empty Messages ─────────────────────────────────────────────────

  Widget _buildEmptyMessages(ChatConversation conversation) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.waving_hand_outlined,
              size: 48,
              color: WasiColors.accent,
            ),
            const SizedBox(height: 12),
            Text(
              '¡Saluda a ${conversation.otherUserName}!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Envía el primer mensaje para empezar la conversación.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: WasiColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Message Input ──────────────────────────────────────────────────

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: WasiColors.outlineLight.withValues(alpha: 0.5),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ── Attach Button ──
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Adjuntar imagen próximamente')),
                );
              },
              icon: const Icon(
                Icons.image_outlined,
                color: WasiColors.textSecondaryLight,
              ),
            ),

            // ── Text Field ──
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: WasiColors.textTertiaryLight,
                    ),
                    filled: true,
                    fillColor: WasiColors.surfaceVariantLight,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // ── Send Button ──
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                onPressed: _isComposing ? _sendMessage : null,
                icon: Icon(
                  Icons.send_rounded,
                  color: _isComposing
                      ? WasiColors.primary
                      : WasiColors.textTertiaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────

  bool _shouldShowAvatar(List<ChatMessage> messages, int index) {
    if (index == messages.length - 1) return true;
    final current = messages[index];
    final next = messages[index + 1];
    return current.senderId != next.senderId;
  }
}

// ── Message Bubble ───────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isFromMe;
  final bool showAvatar;

  const _MessageBubble({
    required this.message,
    required this.isFromMe,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isFromMe ? 48 : 0,
        right: isFromMe ? 0 : 48,
        bottom: showAvatar ? 8 : 2,
      ),
      child: Row(
        mainAxisAlignment:
            isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromMe) ...[
            if (showAvatar)
              CircleAvatar(
                radius: 14,
                backgroundColor: WasiColors.primaryContainer,
                child: Text(
                  message.senderAvatar,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: WasiColors.primary,
                  ),
                ),
              )
            else
              const SizedBox(width: 28),
            const SizedBox(width: 6),
          ],

          // ── Bubble ──
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isFromMe
                    ? WasiColors.primary
                    : WasiColors.surfaceVariantLight,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isFromMe ? 16 : 4),
                  bottomRight: Radius.circular(isFromMe ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (message.type == MessageType.image &&
                      message.imageUrl != null)
                    _buildImageContent()
                  else
                    _buildTextContent(),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.timeFormatted,
                        style: TextStyle(
                          fontSize: 10,
                          color: isFromMe
                              ? Colors.white.withValues(alpha: 0.7)
                              : WasiColors.textTertiaryLight,
                        ),
                      ),
                      if (isFromMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead
                              ? Icons.done_all
                              : Icons.done,
                          size: 14,
                          color: message.isRead
                              ? WasiColors.accent
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Text(
      message.content,
      style: TextStyle(
        fontSize: 14,
        color: isFromMe ? Colors.white : WasiColors.textPrimaryLight,
        height: 1.4,
      ),
    );
  }

  Widget _buildImageContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 200,
        height: 150,
        color: WasiColors.outlineLight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.image_outlined,
              size: 40,
              color: WasiColors.textTertiaryLight,
            ),
            if (message.content.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Typing Indicator ─────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48, bottom: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: WasiColors.primaryContainer,
            child: Text(
              'M',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: WasiColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: WasiColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final progress =
                        (_controller.value * 3 - index).clamp(0.0, 1.0);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: Opacity(
                        opacity: 0.3 + 0.7 * progress,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: WasiColors.textTertiaryLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
