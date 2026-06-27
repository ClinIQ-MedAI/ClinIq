import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.content,
    required super.sentAt,
    required super.sender,
    required super.status,
  });
}
