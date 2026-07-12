import 'dart:async';
import 'dart:developer';

import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/core/repos/base_repo/base_repo_impl.dart';
import 'package:cliniq/core/socket/socket_consumer.dart';
import 'package:cliniq/core/socket/socket_events.dart';
import 'package:cliniq/features/ai/data/models/ai_chat_history_model.dart';
import 'package:cliniq/features/ai/data/models/chatbot_reply_model.dart';
import 'package:cliniq/features/ai/domain/entities/chatbot_reply_entity.dart';
import 'package:cliniq/features/ai/domain/repos/ai_chat_repo.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:dartz/dartz.dart';

class AiChatRepoImpl extends BaseRepoImpl implements AiChatRepo {
  AiChatRepoImpl({required super.api, required this.socket});

  final SocketConsumer socket;
  bool _listenerRegistered = false;

  final StreamController<ChatbotReplyEntity> _replyController =
      StreamController<ChatbotReplyEntity>.broadcast();

  @override
  Stream<ChatbotReplyEntity> get onReplyReceived => _replyController.stream;

  @override
  Future<void> connectSocket() async {
    if (socket.isConnected && _listenerRegistered) return;

    if (!socket.isConnected) {
      await socket.connect();
    }

    if (!_listenerRegistered) {
      socket.on(SocketEvents.receiveChatbotReply, _onReplyReceived);
      _listenerRegistered = true;
    }
  }

  @override
  Future<void> disconnectSocket() async {
    _listenerRegistered = false;
    await socket.disconnect();
  }

  void _onReplyReceived(List<dynamic>? arguments) {
    final data = arguments?.first;
    if (data is! Map<String, dynamic>) return;
    log('AI Socket: ReceiveChatbotReply payload: $data');
    _replyController.add(ChatbotReplyModel.fromJson(data));
  }

  @override
  Future<Either<Failure, ChatbotReplyEntity>> sendChatMessage({
    required String message,
    String? languagePreference,
    String? scanId,
    String? prescriptionId,
  }) {
    return handleApi<ChatbotReplyEntity>(() async {
      final body = <String, dynamic>{'message': message};
      body['languagePreference'] = languagePreference ?? 'en';
      if (scanId != null) body['scanId'] = scanId;
      if (prescriptionId != null) body['prescriptionId'] = prescriptionId;

      final response = await api.post(EndPoints.aiSendMessage, data: body);
      return ChatbotReplyModel.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getChatHistory() {
    return handleApi<List<ChatMessageEntity>>(() async {
      final response = await api.get(EndPoints.aiGetHistory);
      final list = response as List<dynamic>;
      return AiChatHistoryModel.toMessageList(list);
    });
  }
}
