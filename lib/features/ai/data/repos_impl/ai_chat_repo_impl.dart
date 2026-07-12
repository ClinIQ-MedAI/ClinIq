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
  final StreamController<ChatbotReplyEntity> _replyController =
      StreamController<ChatbotReplyEntity>.broadcast();
  bool _listening = false;

  @override
  Future<Either<Failure, String>> sendMessage({
    required String message,
    String? languagePreference,
    String? scanId,
    String? prescriptionId,
  }) {
    return handleApi(() async {
      final body = <String, dynamic>{'message': message};
      if (languagePreference != null) {
        body['languagePreference'] = languagePreference;
      } else {
        body['languagePreference'] = 'en';
      }
      if (scanId != null) body['scanId'] = scanId;
      if (prescriptionId != null) body['prescriptionId'] = prescriptionId;

      final response = await api.post(EndPoints.aiSendMessage, data: body);
      final chatId = response is Map<String, dynamic>
          ? (response['chatId']?.toString() ??
                response['chat_id']?.toString() ??
                '')
          : '';
      return chatId;
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

  @override
  Future<void> connectSocket() async {
    if (socket.isConnected) return;
    await socket.connect();
    _listenForReplies();
  }

  @override
  Future<void> disconnectSocket() async {
    await socket.disconnect();
  }

  @override
  bool get isSocketConnected => socket.isConnected;

  @override
  Stream<ChatbotReplyEntity> get onReplyReceived => _replyController.stream;

  void _listenForReplies() {
    if (_listening) return;
    _listening = true;

    socket.on(SocketEvents.receiveChatbotReply, (List<dynamic>? arguments) {
      if (arguments == null || arguments.isEmpty) return;
      final data = arguments.first;
      if (data is! Map<String, dynamic>) return;

      log('AI Socket: ReceiveChatbotReply payload: $data');
      final reply = ChatbotReplyModel.fromJson(data);
      _replyController.add(reply);
    });
  }

  void dispose() {
    _replyController.close();
    socket.dispose();
    _listening = false;
  }
}
