import 'package:cliniq/core/api/api_consumer.dart';
import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/features/chat/data/models/chat_conversation_model.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  ChatRepoImpl({required this.api});

  final ApiConsumer api;

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
}
