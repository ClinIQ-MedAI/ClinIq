import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';

enum ChatType { doctor, ai }

class ChatConversationEntity {
  const ChatConversationEntity({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.emptyTitle,
    required this.emptyDescription,
    required this.messages,
    this.isTyping = false,
    this.unreadCount = 0,
  });

  final ChatType type;
  final String title;
  final String subtitle;
  final String emptyTitle;
  final String emptyDescription;
  final List<ChatMessageEntity> messages;
  final bool isTyping;
  final int unreadCount;
}
