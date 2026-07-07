import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';

typedef ChatRealtimeSubscription = void Function();

abstract class ChatRepo {
  Future<List<ChatConversationEntity>> getConversations();

  Future<List<ChatMessageEntity>> getConversationMessages(String conversationId);

  Future<ChatConversationEntity> createConversation(String doctorId);

  Future<void> connectRealtime();

  Future<void> disconnectRealtime();

  Future<void> reconnectRealtime();

  void joinConversation(String conversationId);

  void leaveConversation(String conversationId);

  void sendMessage({
    required String conversationId,
    required ChatMessageEntity message,
  });

  void sendTypingStatus({
    required String conversationId,
    required bool isTyping,
  });

  void markMessageSeen({
    required String conversationId,
    required String messageId,
  });

  ChatRealtimeSubscription onMessageReceived(
    void Function({
      required String conversationId,
      required ChatMessageEntity message,
    })
    handler,
  );

  ChatRealtimeSubscription onTypingStatusChanged(
    void Function({required String conversationId, required bool isTyping})
    handler,
  );

  ChatRealtimeSubscription onMessageStatusChanged(
    void Function({
      required String conversationId,
      required String messageId,
      required ChatMessageStatus status,
    })
    handler,
  );

  ChatRealtimeSubscription onOnlineStatusChanged(
    void Function({required String conversationId, required bool isOnline})
    handler,
  );
}
