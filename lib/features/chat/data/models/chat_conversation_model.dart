import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';

class ChatConversationModel extends ChatConversationEntity {
  const ChatConversationModel({
    required super.type,
    required super.title,
    required super.subtitle,
    required super.emptyTitle,
    required super.emptyDescription,
    required super.messages,
    super.isTyping,
    super.unreadCount,
  });

  ChatConversationModel copyWith({
    ChatType? type,
    String? title,
    String? subtitle,
    String? emptyTitle,
    String? emptyDescription,
    List<ChatMessageEntity>? messages,
    bool? isTyping,
    int? unreadCount,
  }) {
    return ChatConversationModel(
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      emptyTitle: emptyTitle ?? this.emptyTitle,
      emptyDescription: emptyDescription ?? this.emptyDescription,
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
