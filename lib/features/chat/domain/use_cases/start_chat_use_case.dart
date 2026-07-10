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
      (c) => c!.title == doctorName,
      orElse: () => null,
    );

    if (existing != null) return existing;

    return repo.createConversation(doctorId: doctorId);
  }
}
