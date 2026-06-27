enum ChatMessageSender { user, doctor, ai }

enum ChatMessageStatus { sending, delivered, seen }

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
}
