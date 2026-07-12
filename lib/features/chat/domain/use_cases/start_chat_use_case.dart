import 'package:cliniq/core/errors/exceptions.dart';
import 'package:cliniq/core/models/error_model.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';

class StartChatUseCase {
  StartChatUseCase({required this.repo});

  final ChatRepo repo;

  Future<ChatConversationEntity> call({
    required String doctorId,
    required String doctorName,
  }) async {
    final conversations = await repo.getConversations();

    final existing = conversations.cast<ChatConversationEntity?>().firstWhere(
      (c) => c!.participantId == doctorId || c.title == doctorName,
      orElse: () => null,
    );

    if (existing != null) return existing;

    try {
      return await repo.createConversation(doctorId: doctorId);
    } on ServerException catch (e) {
      if (e.errModel.message.contains('Conversation with this doctor already exists')) {
        final refreshed = await repo.getConversations();
        final found = refreshed.cast<ChatConversationEntity?>().firstWhere(
          (c) => c!.participantId == doctorId || c.title == doctorName,
          orElse: () => null,
        );
        if (found != null) return found;
        throw ServerException(
          errModel: ErrorModel(code: 400, message: 'Unable to open the conversation. Please try again.'),
        );
      }
      rethrow;
    } catch (e) {
      if (e.toString().contains('Conversation with this doctor already exists')) {
        final refreshed = await repo.getConversations();
        final found = refreshed.cast<ChatConversationEntity?>().firstWhere(
          (c) => c!.participantId == doctorId || c.title == doctorName,
          orElse: () => null,
        );
        if (found != null) return found;
        throw Exception('Unable to open the conversation. Please try again.');
      }
      rethrow;
    }
  }
}
