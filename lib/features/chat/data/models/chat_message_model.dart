import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.content,
    required super.sentAt,
    required super.sender,
    required super.status,
    super.attachmentUrl,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      sentAt: json['sentAt'] as String,
      sender: ChatMessageSender.values.firstWhere(
        (sender) => sender.name == json['sender'],
        orElse: () => ChatMessageSender.user,
      ),
      status: ChatMessageStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => ChatMessageStatus.delivered,
      ),
      attachmentUrl: json['attachmentUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sentAt': sentAt,
      'sender': sender.name,
      'status': status.name,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
    };
  }

  @override
  ChatMessageModel copyWith({
    String? id,
    String? content,
    String? sentAt,
    ChatMessageSender? sender,
    ChatMessageStatus? status,
    String? attachmentUrl,
    bool clearAttachmentUrl = false,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      sender: sender ?? this.sender,
      status: status ?? this.status,
      attachmentUrl:
          clearAttachmentUrl ? null : (attachmentUrl ?? this.attachmentUrl),
    );
  }
}
