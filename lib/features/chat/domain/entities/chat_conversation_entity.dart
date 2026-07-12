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
    this.imageUrl = '',
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
  final String imageUrl;
  final bool isTyping;
  final int unreadCount;
  final bool isOnline;

  ChatConversationEntity copyWith({
    String? id,
    ChatType? type,
    String? title,
    String? subtitle,
    String? emptyTitle,
    String? emptyDescription,
    List<ChatMessageEntity>? messages,
    String? lastMessage,
    String? lastMessageTime,
    String? imageUrl,
    bool? isTyping,
    int? unreadCount,
    bool? isOnline,
  }) {
    return ChatConversationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      emptyTitle: emptyTitle ?? this.emptyTitle,
      emptyDescription: emptyDescription ?? this.emptyDescription,
      messages: messages ?? this.messages,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      imageUrl: imageUrl ?? this.imageUrl,
      isTyping: isTyping ?? this.isTyping,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
