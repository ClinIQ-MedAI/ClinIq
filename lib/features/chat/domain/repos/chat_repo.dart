import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';

typedef ChatRealtimeSubscription = void Function();

abstract class ChatRepo {
  Future<List<ChatConversationEntity>> getConversations();

  Future<List<ChatMessageEntity>> getConversationMessages(String conversationId);

  Future<ChatConversationEntity> createConversation({
    required String doctorId,
    String? initialMessage,
  });

  Future<void> joinConversation(int conversationId);

  Future<void> leaveConversation(int conversationId);

  Future<ChatMessageEntity> sendMessage({
    required String conversationId,
    required ChatMessageEntity message,
  });

  ChatRealtimeSubscription onMessageReceived(
    void Function({
      required String conversationId,
      required ChatMessageEntity message,
    })
    handler,
  );
}
