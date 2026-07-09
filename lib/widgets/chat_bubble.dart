import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/chat_message.dart';

/// Burbuja de mensaje de chat con estilos diferentes para enviado/recibido.
/// Muestra marca de tiempo y estado de lectura.
class ChatBubble extends StatelessWidget {
  final String content;
  final bool isSent;
  final String time;
  final bool isRead;
  final bool showTail;
  final MessageType type;
  final String? imageUrl;
  final VoidCallback? onImageTap;

  const ChatBubble({
    super.key,
    required this.content,
    required this.isSent,
    required this.time,
    this.isRead = false,
    this.showTail = true,
    this.type = MessageType.text,
    this.imageUrl,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: isSent ? 48 : 8,
          right: isSent ? 8 : 48,
        ),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Burbuja
            Container(
              padding: _bubblePadding(),
              decoration: BoxDecoration(
                color: _bubbleColor(context),
                borderRadius: _bubbleBorderRadius(),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: _buildContent(context),
            ),
            const SizedBox(height: 3),
            // Hora y estado
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isSent
                        ? WasiColors.textTertiaryLight
                        : WasiColors.textTertiaryLight.withValues(alpha: 0.7),
                  ),
                ),
                if (isSent) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isRead ? Icons.done_all_rounded : Icons.done_rounded,
                    size: 13,
                    color: isRead
                        ? WasiColors.primaryLight
                        : WasiColors.textTertiaryLight,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (type) {
      case MessageType.text:
        return Text(
          content,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: isSent ? Colors.white : WasiColors.textPrimaryLight,
          ),
        );
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              GestureDetector(
                onTap: onImageTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: Colors.black12,
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                ),
              ),
            if (content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: isSent ? Colors.white : WasiColors.textPrimaryLight,
                ),
              ),
            ],
          ],
        );
      case MessageType.system:
        return Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: WasiColors.textTertiaryLight,
            fontStyle: FontStyle.italic,
          ),
        );
      case MessageType.document:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.description_rounded,
              size: 20,
              color: isSent ? Colors.white70 : WasiColors.primary,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSent ? Colors.white : WasiColors.textPrimaryLight,
                ),
              ),
            ),
          ],
        );
      case MessageType.contract:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.assignment_rounded,
                size: 20,
                color: isSent ? Colors.white70 : WasiColors.accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSent ? Colors.white : WasiColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  EdgeInsetsGeometry _bubblePadding() {
    if (type == MessageType.image) {
      return const EdgeInsets.all(4);
    }
    return const EdgeInsets.symmetric(horizontal: 14, vertical: 10);
  }

  Color _bubbleColor(BuildContext context) {
    if (type == MessageType.system) {
      return WasiColors.surfaceVariantLight.withValues(alpha: 0.5);
    }
    if (isSent) {
      return WasiColors.primary;
    }
    return Theme.of(context).brightness == Brightness.dark
        ? WasiColors.surfaceVariantDark
        : WasiColors.surfaceLight;
  }

  BorderRadiusGeometry _bubbleBorderRadius() {
    if (type == MessageType.system) {
      return BorderRadius.circular(12);
    }
    if (isSent) {
      return BorderRadius.only(
        topLeft: const Radius.circular(16),
        topRight: const Radius.circular(16),
        bottomLeft: const Radius.circular(16),
        bottomRight: Radius.circular(showTail ? 4 : 16),
      );
    }
    return BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomRight: const Radius.circular(16),
      bottomLeft: Radius.circular(showTail ? 4 : 16),
    );
  }
}

