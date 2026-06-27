import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final doctorConversationsProvider =
    FutureProvider<List<ChatConversationEntity>>((ref) {
      return ref.read(chatRepoProvider).getDoctorConversations();
    });

final doctorConversationDetailsProvider =
    FutureProvider.family<ChatConversationEntity, String>((ref, id) {
      return ref.read(chatRepoProvider).getDoctorConversationById(id);
    });
