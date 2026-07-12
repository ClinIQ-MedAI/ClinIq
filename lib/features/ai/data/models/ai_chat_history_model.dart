import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';

class AiChatHistoryModel {
  final String id;
  final String message;
  final String reply;
  final String createdAt;

  const AiChatHistoryModel({
    required this.id,
    required this.message,
    required this.reply,
    required this.createdAt,
  });

  factory AiChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return AiChatHistoryModel(
      id: json['id']?.toString() ?? '',
      message: json['message'] as String? ?? '',
      reply: json['reply'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  static List<ChatMessageEntity> toMessageList(List<dynamic> jsonList) {
    final items = jsonList
        .map((item) =>
            AiChatHistoryModel.fromJson(item as Map<String, dynamic>))
        .toList();

    items.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final messages = <ChatMessageEntity>[];
    for (final item in items) {
      final sentAt = _formatSentAt(item.createdAt);

      if (item.message.isNotEmpty) {
        messages.add(ChatMessageEntity(
          id: 'history-user-${item.id}',
          content: item.message,
          sentAt: sentAt,
          sender: ChatMessageSender.user,
          status: ChatMessageStatus.seen,
        ));
      }

      if (item.reply.isNotEmpty) {
        messages.add(ChatMessageEntity(
          id: 'history-ai-${item.id}',
          content: item.reply,
          sentAt: sentAt,
          sender: ChatMessageSender.ai,
          status: ChatMessageStatus.seen,
        ));
      }
    }

    return messages;
  }

  static String _formatSentAt(String iso) {
    if (iso.length >= 16) {
      try {
        return iso.substring(11, 16);
      } catch (_) {
        return iso;
      }
    }
    return iso;
  }
}
