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

    return (response['data'] as List)
        .map((conversation) => ChatConversationModel.fromJson(conversation))
        .toList();
  }

  @override
  Future<List<ChatMessageEntity>> getConversationMessages(String conversationId) async {
    final response = await api.get(
      EndPoints.getConversationById(conversationId),
    );

    return (response['data'] as List)
        .map((message) => ChatMessageModel.fromJson(message))
        .toList();
  }

  @override
  Future<ChatConversationEntity> createConversation(String doctorId) async {
    final response = await api.post(
      EndPoints.createConversation,
      queryParameters: {'doctorId': doctorId},
      data: {'doctorId': doctorId},
    );

    return ChatConversationModel.fromJson(response['data']);
  }

  @override
  Future<void> connectRealtime() {
    return socket.connect();
  }

  @override
  Future<void> disconnectRealtime() {
    return socket.disconnect();
  }

  @override
  Future<void> reconnectRealtime() {
    return socket.reconnect();
  }

  @override
  void joinConversation(String conversationId) {
    socket.emit(SocketEvents.joinConversation, {
      'conversationId': conversationId,
    });
  }

  @override
  void leaveConversation(String conversationId) {
    socket.emit(SocketEvents.leaveConversation, {
      'conversationId': conversationId,
    });
  }

  @override
  void sendMessage({
    required String conversationId,
    required ChatMessageEntity message,
  }) {
    socket.emit(SocketEvents.sendMessage, {
      'conversationId': conversationId,
      'message': ChatMessageModel(
        id: message.id,
        content: message.content,
        sentAt: message.sentAt,
        sender: message.sender,
        status: message.status,
      ).toJson(),
    });
  }

  @override
  void sendTypingStatus({
    required String conversationId,
    required bool isTyping,
  }) {
    socket.emit(isTyping ? SocketEvents.typing : SocketEvents.stopTyping, {
      'conversationId': conversationId,
    });
  }

  @override
  void markMessageSeen({
    required String conversationId,
    required String messageId,
  }) {
    socket.emit(SocketEvents.markMessageSeen, {
      'conversationId': conversationId,
      'messageId': messageId,
    });
  }

  @override
  ChatRealtimeSubscription onMessageReceived(
    void Function({
      required String conversationId,
      required ChatMessageEntity message,
    })
    handler,
  ) {
    void listener(dynamic data) {
      final payload = _payload(data);
      final messageData = payload['message'];
      if (messageData is! Map<String, dynamic>) return;

      handler(
        conversationId: payload['conversationId'] as String? ?? '',
        message: ChatMessageModel.fromJson(messageData),
      );
    }

    socket.on(SocketEvents.receiveMessage, listener);
    return () => socket.off(SocketEvents.receiveMessage, listener);
  }

  @override
  ChatRealtimeSubscription onTypingStatusChanged(
    void Function({required String conversationId, required bool isTyping})
    handler,
  ) {
    void listener(dynamic data) {
      final payload = _payload(data);
      handler(
        conversationId: payload['conversationId'] as String? ?? '',
        isTyping: payload['isTyping'] as bool? ?? false,
      );
    }

    socket.on(SocketEvents.typingStatusChanged, listener);
    return () => socket.off(SocketEvents.typingStatusChanged, listener);
  }

  @override
  ChatRealtimeSubscription onMessageStatusChanged(
    void Function({
      required String conversationId,
      required String messageId,
      required ChatMessageStatus status,
    })
    handler,
  ) {
    void listener(dynamic data) {
      final payload = _payload(data);
      final status = ChatMessageStatus.values.firstWhere(
        (status) => status.name == payload['status'],
        orElse: () => ChatMessageStatus.delivered,
      );

      handler(
        conversationId: payload['conversationId'] as String? ?? '',
        messageId: payload['messageId'] as String? ?? '',
        status: status,
      );
    }

    socket.on(SocketEvents.messageStatusChanged, listener);
    return () => socket.off(SocketEvents.messageStatusChanged, listener);
  }

  @override
  ChatRealtimeSubscription onOnlineStatusChanged(
    void Function({required String conversationId, required bool isOnline})
    handler,
  ) {
    void listener(dynamic data) {
      final payload = _payload(data);
      handler(
        conversationId: payload['conversationId'] as String? ?? '',
        isOnline: payload['isOnline'] as bool? ?? false,
      );
    }

    socket.on(SocketEvents.onlineStatusChanged, listener);
    return () => socket.off(SocketEvents.onlineStatusChanged, listener);
  }

  Map<String, dynamic> _payload(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }
}
