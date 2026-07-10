import 'dart:async';

import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final doctorConversationsProvider =
    AsyncNotifierProvider<
      DoctorConversationsNotifier,
      List<ChatConversationEntity>
    >(DoctorConversationsNotifier.new);

class DoctorConversationsNotifier
    extends AsyncNotifier<List<ChatConversationEntity>> {
  late final ChatRepo _repo;
  final List<ChatRealtimeSubscription> _subscriptions = [];

  @override
  FutureOr<List<ChatConversationEntity>> build() async {
    _repo = ref.read(chatRepoProvider);

    _subscribe();

    ref.onDispose(() {
      for (final cancel in _subscriptions) {
        cancel();
      }
    });

    return _repo.getConversations();
  }

  void _subscribe() {
    _subscriptions.add(
      _repo.onMessageReceived(({required conversationId, required message}) {
        final currentUserId =
            AppStorageHelper.getString(StorageKeys.currentUserId) ?? '';
        if (message.senderId != null && message.senderId == currentUserId) {
          return;
        }

        _updateConversation(conversationId, (conversation) {
          final messages = [...conversation.messages];
          final index = messages.indexWhere((item) => item.id == message.id);
          if (index == -1) {
            messages.add(message);
          } else {
            messages[index] = message;
          }

          return conversation.copyWith(
            messages: messages,
            lastMessage: message.content,
            lastMessageTime: message.sentAt,
            unreadCount: message.sender == ChatMessageSender.user
                ? conversation.unreadCount
                : conversation.unreadCount + 1,
          );
        });
      }),
    );
  }

  void _updateConversation(
    String conversationId,
    ChatConversationEntity Function(ChatConversationEntity conversation) update,
  ) {
    final conversations = state.value;
    if (conversations == null) return;

    state = AsyncData([
      for (final conversation in conversations)
        if (conversation.id == conversationId)
          update(conversation)
        else
          conversation,
    ]);
  }
}
