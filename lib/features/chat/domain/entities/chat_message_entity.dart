enum ChatMessageSender { user, doctor, ai }

enum ChatMessageStatus { sending, sent, delivered, seen, failed }

class ChatMessageEntity {
  const ChatMessageEntity({
    required this.id,
    required this.content,
    required this.sentAt,
    required this.sender,
    required this.status,
  });

  final String id;
  final String content;
  final String sentAt;
  final ChatMessageSender sender;
  final ChatMessageStatus status;

  ChatMessageEntity copyWith({
    String? id,
    String? content,
    String? sentAt,
    ChatMessageSender? sender,
    ChatMessageStatus? status,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      sender: sender ?? this.sender,
      status: status ?? this.status,
    );
  }
}
