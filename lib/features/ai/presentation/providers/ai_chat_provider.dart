import 'dart:async';
import 'dart:developer';

import 'package:cliniq/features/ai/domain/entities/chatbot_reply_entity.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_chat_repo_provider.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowUploadNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;
  void hide() => state = false;
}

final aiShowUploadRequestProvider = NotifierProvider<ShowUploadNotifier, bool>(
  ShowUploadNotifier.new,
);

final aiChatProvider =
    AsyncNotifierProvider<AiChatNotifier, ChatConversationEntity>(
      AiChatNotifier.new,
    );

class AiChatNotifier extends AsyncNotifier<ChatConversationEntity> {
  StreamSubscription<ChatbotReplyEntity>? _replySubscription;

  @override
  FutureOr<ChatConversationEntity> build() async {
    final repo = ref.read(aiChatRepoProvider);

    await repo.connectSocket();
    _replySubscription = repo.onReplyReceived.listen(_handleReply);

    ref.onDispose(() async {
      _replySubscription?.cancel();
      await repo.disconnectSocket();
    });

    final historyResult = await repo.getChatHistory();
    final historyMessages = historyResult.fold((failure) {
      log('AI Chat: History load failed: $failure');
      return <ChatMessageEntity>[];
    }, (messages) => messages);

    final conversation = _buildConversation();
    if (historyMessages.isEmpty) return conversation;

    return conversation.copyWith(
      messages: historyMessages,
      lastMessage: historyMessages.last.content,
      lastMessageTime: historyMessages.last.sentAt,
    );
  }

  void _handleReply(ChatbotReplyEntity reply) {
    log(
      '_handleReply called — chatId: ${reply.chatId}, status: ${reply.status}',
    );

    final conversation = state.value;
    if (conversation == null) {
      return;
    }

    final loadingId = '${reply.chatId}-loading';

    final loadingIndex = conversation.messages.indexWhere(
      (m) => m.id == loadingId,
    );
    if (loadingIndex == -1) {
      return;
    }

    final messages = [...conversation.messages];
    messages.removeAt(loadingIndex);

    final status = reply.status.toLowerCase();

    if (status == 'completed') {
      messages.add(
        ChatMessageEntity(
          id: reply.chatId,
          content: reply.reply,
          sentAt: reply.finishedAt ?? _currentTimeLabel(),
          sender: ChatMessageSender.ai,
          status: ChatMessageStatus.seen,
        ),
      );
    } else if (status == 'failed') {
      messages.add(
        ChatMessageEntity(
          id: reply.chatId,
          content: reply.error ?? 'An error occurred',
          sentAt: _currentTimeLabel(),
          sender: ChatMessageSender.ai,
          status: ChatMessageStatus.failed,
        ),
      );
    }

    state = AsyncData(
      conversation.copyWith(
        messages: messages,
        lastMessage: messages.last.content,
        lastMessageTime: messages.last.sentAt,
      ),
    );

    if (reply.showUpload) {
      ref.read(aiShowUploadRequestProvider.notifier).show();
    } else {
      ref.read(aiShowUploadRequestProvider.notifier).hide();
    }
  }

  ChatConversationEntity _buildConversation() {
    return ChatConversationEntity(
      id: 'ai-assistant',
      type: ChatType.ai,
      title: 'AI Chat',
      subtitle: 'Instant medical guidance assistant',
      emptyTitle: 'Ask the AI assistant',
      emptyDescription:
          'Describe your symptoms or health question to get helpful guidance before your visit.',
      lastMessage: '',
      lastMessageTime: '',
      messages: [],
    );
  }

  Future<void> sendMessage(String content) async {
    final text = content.trim();
    final conversation = state.value;
    if (conversation == null || text.isEmpty) return;

    ref.read(aiShowUploadRequestProvider.notifier).hide();

    final userMessage = ChatMessageEntity(
      id: 'local-ai-${DateTime.now().microsecondsSinceEpoch}',
      content: text,
      sentAt: _currentTimeLabel(),
      sender: ChatMessageSender.user,
      status: ChatMessageStatus.sending,
    );

    _addMessage(userMessage);

    final languagePreference =
        ref.read(currentUserProvider)?.role == 'ar' ? 'ar' : null;

    try {
      final repo = ref.read(aiChatRepoProvider);
      final result = await repo.sendChatMessage(
        message: text,
        languagePreference: languagePreference,
      );

      result.fold(
        (failure) {
          _updateMessageStatus(userMessage.id, ChatMessageStatus.failed);
        },
        (response) {
          _updateMessageStatus(userMessage.id, ChatMessageStatus.sent);

          final loadingId = '${response.chatId}-loading';
          _addMessage(
            ChatMessageEntity(
              id: loadingId,
              content: '',
              sentAt: _currentTimeLabel(),
              sender: ChatMessageSender.ai,
              status: ChatMessageStatus.loading,
            ),
          );
        },
      );
    } catch (e) {
      _updateMessageStatus(userMessage.id, ChatMessageStatus.failed);
    }
  }

  void retryFailedAi(String messageId) {
    final conversation = state.value;
    if (conversation == null) return;

    final messageIndex = conversation.messages.indexWhere(
      (m) => m.id == messageId,
    );
    if (messageIndex == -1) return;

    final message = conversation.messages[messageIndex];
    if (message.sender != ChatMessageSender.ai ||
        message.status != ChatMessageStatus.failed) {
      return;
    }

    final userMessageIndex = messageIndex - 1;
    if (userMessageIndex < 0) return;
    final userMessage = conversation.messages[userMessageIndex];
    if (userMessage.sender != ChatMessageSender.user) return;

    _updateMessageStatus(messageId, ChatMessageStatus.sending);
    sendMessage(userMessage.content);
  }

  void addMessage(ChatMessageEntity message) {
    _addMessage(message);
  }

  void updateMessage(
    String messageId, {
    String? content,
    ChatMessageStatus? status,
  }) {
    final conversation = state.value;
    if (conversation == null) return;

    final updatedMessages = conversation.messages.map((m) {
      if (m.id != messageId) return m;
      return m.copyWith(
        content: content,
        status: status,
      );
    }).toList();

    final updatedMessage = updatedMessages.firstWhere(
      (m) => m.id == messageId,
      orElse: () => conversation.messages.last,
    );
    final isLast = updatedMessages.lastOrNull?.id == messageId;

    state = AsyncData(
      conversation.copyWith(
        messages: updatedMessages,
        lastMessage: isLast ? (updatedMessage.content) : conversation.lastMessage,
        lastMessageTime: isLast ? updatedMessage.sentAt : conversation.lastMessageTime,
      ),
    );
  }

  void _addMessage(ChatMessageEntity message) {
    final conversation = state.value;
    if (conversation == null) return;

    state = AsyncData(
      conversation.copyWith(
        messages: [...conversation.messages, message],
        lastMessage: message.content,
        lastMessageTime: message.sentAt,
      ),
    );
  }

  void _updateMessageStatus(String messageId, ChatMessageStatus status) {
    final conversation = state.value;
    if (conversation == null) return;

    state = AsyncData(
      conversation.copyWith(
        messages: conversation.messages
            .map((m) => m.id == messageId ? m.copyWith(status: status) : m)
            .toList(),
      ),
    );
  }



  String _currentTimeLabel() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
