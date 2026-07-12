import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/features/ai/domain/entities/chatbot_reply_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AiChatRepo {
  Future<Either<Failure, String>> sendMessage({
    required String message,
    String? languagePreference,
    String? scanId,
    String? prescriptionId,
  });

  Future<void> connectSocket();
  Future<void> disconnectSocket();
  Stream<ChatbotReplyEntity> get onReplyReceived;
  bool get isSocketConnected;
}
