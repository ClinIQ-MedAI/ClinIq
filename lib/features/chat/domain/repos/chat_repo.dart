import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';

abstract class ChatRepo {
  Future<ChatConversationEntity> getConversation(ChatType type);

  Future<List<ChatConversationEntity>> getDoctorConversations();

  Future<ChatConversationEntity> getDoctorConversationById(String id);

  Future<void> connectRealtime();

  Future<void> disconnectRealtime();

  Future<void> reconnectRealtime();

  void joinConversation(String conversationId);

  void leaveConversation(String conversationId);

  void sendMessage({required String conversationId, required String message});

  void sendTypingStatus({
    required String conversationId,
    required bool isTyping,
  });

  void markMessageSeen({
    required String conversationId,
    required String messageId,
  });

  void onMessageReceived(void Function(dynamic data) handler);

  void offMessageReceived([void Function(dynamic data)? handler]);
}
