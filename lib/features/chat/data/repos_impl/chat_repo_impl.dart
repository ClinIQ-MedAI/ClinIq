import 'package:cliniq/core/api/api_consumer.dart';
import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/socket/socket_consumer.dart';
import 'package:cliniq/core/socket/socket_events.dart';
import 'package:cliniq/features/chat/data/models/chat_conversation_model.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  ChatRepoImpl({required this.api, required this.socket});

  final ApiConsumer api;
  final SocketConsumer socket;

  @override
  Future<ChatConversationEntity> getConversation(ChatType type) async {
    final response = await api.get(
      EndPoints.getConversation,
      queryParameters: {'type': type.name},
    );

    return ChatConversationModel.fromJson(response['data']);
  }

  @override
  Future<List<ChatConversationEntity>> getDoctorConversations() async {
    final response = await api.get(EndPoints.getConversations);

    return (response['data'] as List)
        .map((conversation) => ChatConversationModel.fromJson(conversation))
        .toList();
  }

  @override
  Future<ChatConversationEntity> getDoctorConversationById(String id) async {
    final response = await api.get(
      EndPoints.getConversationById,
      queryParameters: {'id': id},
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
  void sendMessage({required String conversationId, required String message}) {
    socket.emit(SocketEvents.sendMessage, {
      'conversationId': conversationId,
      'message': message,
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
    socket.emit(SocketEvents.seen, {
      'conversationId': conversationId,
      'messageId': messageId,
    });
  }

  @override
  void onMessageReceived(void Function(dynamic data) handler) {
    socket.on(SocketEvents.receiveMessage, handler);
  }

  @override
  void offMessageReceived([void Function(dynamic data)? handler]) {
    socket.off(SocketEvents.receiveMessage, handler);
  }
}
