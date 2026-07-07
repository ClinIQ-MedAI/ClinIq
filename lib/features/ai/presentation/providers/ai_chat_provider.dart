import 'dart:async';

import 'package:cliniq/core/dummy/dummy_responses.dart';
import 'package:cliniq/features/chat/data/models/chat_conversation_model.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiChatProvider =
    AsyncNotifierProvider<AiChatNotifier, ChatConversationEntity>(
        AiChatNotifier.new);

class AiChatNotifier extends AsyncNotifier<ChatConversationEntity> {
  @override
  FutureOr<ChatConversationEntity> build() {
    return ChatConversationModel.fromJson(DummyResponses.aiConversation);
  }

  void sendMessage(String content) {
    final text = content.trim();
    final conversation = state.value;
    if (text.isEmpty || conversation == null) return;

    final userMessage = ChatMessageEntity(
      id: 'local-ai-user-${DateTime.now().microsecondsSinceEpoch}',
      content: text,
      sentAt: _currentTimeLabel(),
      sender: ChatMessageSender.user,
      status: ChatMessageStatus.seen,
    );

    final updatedMessages = [...conversation.messages, userMessage];

    state = AsyncData(conversation.copyWith(
      messages: updatedMessages,
      lastMessage: text,
      lastMessageTime: userMessage.sentAt,
    ));

    Future.delayed(const Duration(seconds: 1), () {
      final currentConversation = state.value;
      if (currentConversation == null) return;

      final aiMessage = ChatMessageEntity(
        id: 'local-ai-response-${DateTime.now().microsecondsSinceEpoch}',
        content: 'This is a mock response from your AI Assistant.',
        sentAt: _currentTimeLabel(),
        sender: ChatMessageSender.ai,
        status: ChatMessageStatus.seen,
      );

      state = AsyncData(currentConversation.copyWith(
        messages: [...currentConversation.messages, aiMessage],
        lastMessage: aiMessage.content,
        lastMessageTime: aiMessage.sentAt,
      ));
    });
  }

  String _currentTimeLabel() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
