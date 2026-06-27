import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';

enum ChatType { doctor, ai }

class ChatConversationEntity {
  const ChatConversationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.emptyTitle,
    required this.emptyDescription,
    required this.messages,
    required this.lastMessage,
    required this.lastMessageTime,
    this.isTyping = false,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  final String id;
  final ChatType type;
  final String title;
  final String subtitle;
  final String emptyTitle;
  final String emptyDescription;
  final List<ChatMessageEntity> messages;
  final String lastMessage;
  final String lastMessageTime;
  final bool isTyping;
  final int unreadCount;
  final bool isOnline;
}
