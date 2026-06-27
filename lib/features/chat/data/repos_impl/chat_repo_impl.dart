import 'package:cliniq/features/chat/data/data_sources/chat_dummy_data_source.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  ChatRepoImpl({required this.dataSource});

  final ChatDummyDataSource dataSource;

  @override
  Future<ChatConversationEntity> getConversation(ChatType type) {
    return dataSource.getConversation(type);
  }
}
