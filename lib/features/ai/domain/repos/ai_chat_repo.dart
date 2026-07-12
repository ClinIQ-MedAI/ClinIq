import 'dart:async';

import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/features/ai/domain/entities/chatbot_reply_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AiChatRepo {
  Future<void> connectSocket();
  Future<void> disconnectSocket();
  Stream<ChatbotReplyEntity> get onReplyReceived;

  Future<Either<Failure, ChatbotReplyEntity>> sendChatMessage({
    required String message,
    String? languagePreference,
    String? scanId,
    String? prescriptionId,
  });

  Future<Either<Failure, List<ChatMessageEntity>>> getChatHistory();
}
