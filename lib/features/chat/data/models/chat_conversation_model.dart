import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/data/models/chat_message_model.dart';

class ChatConversationModel extends ChatConversationEntity {
  const ChatConversationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.subtitle,
    required super.emptyTitle,
    required super.emptyDescription,
    required super.messages,
    required super.lastMessage,
    required super.lastMessageTime,
    super.isTyping,
    super.unreadCount,
    super.isOnline,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      id: json['id'] as String,
      type: ChatType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => ChatType.doctor,
      ),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      emptyTitle: json['emptyTitle'] as String,
      emptyDescription: json['emptyDescription'] as String,
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map(
            (message) =>
                ChatMessageModel.fromJson(message as Map<String, dynamic>),
          )
          .toList(),
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: json['lastMessageTime'] as String,
      isTyping: json['isTyping'] as bool? ?? false,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }

  @override
  ChatConversationModel copyWith({
    String? id,
    ChatType? type,
    String? title,
    String? subtitle,
    String? emptyTitle,
    String? emptyDescription,
    List<ChatMessageEntity>? messages,
    String? lastMessage,
    String? lastMessageTime,
    bool? isTyping,
    int? unreadCount,
    bool? isOnline,
  }) {
    return ChatConversationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      emptyTitle: emptyTitle ?? this.emptyTitle,
      emptyDescription: emptyDescription ?? this.emptyDescription,
      messages: messages ?? this.messages,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isTyping: isTyping ?? this.isTyping,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'subtitle': subtitle,
      'emptyTitle': emptyTitle,
      'emptyDescription': emptyDescription,
      'messages': messages
          .map(
            (message) => ChatMessageModel(
              id: message.id,
              content: message.content,
              sentAt: message.sentAt,
              sender: message.sender,
              status: message.status,
            ).toJson(),
          )
          .toList(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'isTyping': isTyping,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
    };
  }
}
