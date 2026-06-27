import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatConversationProvider =
    FutureProvider.family<ChatConversationEntity, ChatType>((ref, type) {
      return ref.read(chatRepoProvider).getConversation(type);
    });
