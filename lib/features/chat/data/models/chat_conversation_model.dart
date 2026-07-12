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
    super.imageUrl,
    super.isTyping,
    super.unreadCount,
    super.isOnline,
    super.participantId,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final title = json['doctorName'] as String? ??
        json['patientName'] as String? ??
        '';
    final participantId = json['doctorId']?.toString() ??
        json['participantId']?.toString() ??
        json['patientId']?.toString();
    final subtitle = json['doctorSpecialization'] as String? ?? '';
    final lastMessageAt = json['lastMessageAt'] as String? ?? '';
    final lastMessageTime = lastMessageAt.length >= 16
        ? lastMessageAt.substring(11, 16)
        : lastMessageAt;

    return ChatConversationModel(
      id: id,
      type: ChatType.doctor,
      title: title,
      subtitle: subtitle,
      emptyTitle: '',
      emptyDescription: '',
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map(
            (message) =>
                ChatMessageModel.fromJson(message as Map<String, dynamic>),
          )
          .toList(),
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageTime: lastMessageTime,
      imageUrl: json['doctorAvatar'] as String? ?? '',
      unreadCount: json['unreadCount'] as int? ?? 0,
      participantId: participantId,
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
    String? imageUrl,
    bool? isTyping,
    int? unreadCount,
    bool? isOnline,
    String? participantId,
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
      imageUrl: imageUrl ?? this.imageUrl,
      isTyping: isTyping ?? this.isTyping,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      participantId: participantId ?? this.participantId,
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
      'imageUrl': imageUrl,
      'isTyping': isTyping,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      if (participantId != null) 'participantId': participantId,
    };
  }
}
