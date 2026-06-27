import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';

abstract class ChatRepo {
  Future<ChatConversationEntity> getConversation(ChatType type);

  Future<List<ChatConversationEntity>> getDoctorConversations();

  Future<ChatConversationEntity> getDoctorConversationById(String id);
}
