import 'dart:developer';

import 'package:cliniq/core/api/api_consumer.dart';
import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/socket/socket_consumer.dart';
import 'package:cliniq/core/socket/socket_events.dart';
import 'package:cliniq/features/chat/data/models/chat_conversation_model.dart';
import 'package:cliniq/features/chat/data/models/chat_message_model.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  ChatRepoImpl({required this.api, required this.socket});

  final ApiConsumer api;
  final SocketConsumer socket;

  @override
  Future<List<ChatConversationEntity>> getConversations() async {
    final response = await api.get(EndPoints.getConversations);
    final list = response as List<dynamic>;
    return list
        .map((item) => ChatConversationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ChatMessageEntity>> getConversationMessages(
      String conversationId) async {
    final response = await api.get(
      EndPoints.getConversationById(conversationId),
    );
    final list = response as List<dynamic>;
    return list
        .map((message) => ChatMessageModel.fromJson(message as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ChatConversationEntity> createConversation({
    required String doctorId,
    String? initialMessage,
  }) async {
    final response = await api.post(
      EndPoints.createConversation,
      data: {
        'doctorId': doctorId,
        if (initialMessage != null) 'initialMessage': initialMessage,
      },
    );
    return ChatConversationModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> joinConversation(int conversationId) async {
    log('Chat Socket: Joining conversation $conversationId');
    await socket.invoke(SocketEvents.joinConversation, [conversationId]);
    log('Chat Socket: Joined conversation $conversationId');
  }

  @override
  Future<void> leaveConversation(int conversationId) async {
    log('Chat Socket: Leaving conversation $conversationId');
    await socket.invoke(SocketEvents.leaveConversation, [conversationId]);
    log('Chat Socket: Left conversation $conversationId');
  }

  @override
  Future<ChatMessageEntity> sendMessage({
    required String conversationId,
    required ChatMessageEntity message,
  }) async {
    log('Chat HTTP: Sending message to conversation $conversationId');
    final response = await api.post(
      EndPoints.sendMessage(conversationId),
      data: {
        'content': message.content,
      },
    );
    log('Chat HTTP: Send response received: $response');
    return ChatMessageModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  ChatRealtimeSubscription onMessageReceived(
    void Function({
      required String conversationId,
      required ChatMessageEntity message,
    })
    handler,
  ) {
    void listener(List<dynamic>? arguments) {
      if (arguments == null || arguments.isEmpty) return;
      final data = arguments.first;
      if (data is! Map<String, dynamic>) return;

      log('Chat Socket: ReceiveMessage payload: $data');

      final conversationId = data['conversationId']?.toString() ?? '';
      final message = ChatMessageModel.fromJson(data);

      handler(
        conversationId: conversationId,
        message: message,
      );
    }

    socket.on(SocketEvents.receiveMessage, listener);
    return () => _removeListener();
  }

  void _removeListener() {
    // SignalR doesn't support removing individual listeners easily.
    // The connection is disposed when leaving the conversation.
  }
}
