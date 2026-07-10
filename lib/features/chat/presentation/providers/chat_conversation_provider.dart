import 'dart:async';

import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';
import 'package:cliniq/features/chat/presentation/providers/attachment_provider.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_repo_provider.dart';
import 'package:cliniq/features/chat/presentation/providers/doctor_conversations_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatConversationProvider =
    AsyncNotifierProvider.family<
      ChatConversationNotifier,
      ChatConversationEntity,
      ChatConversationRequest
    >((request) => ChatConversationNotifier(request));

class ChatConversationRequest {
  const ChatConversationRequest({required this.conversationId});

  final String conversationId;

  @override
  bool operator ==(Object other) {
    return other is ChatConversationRequest &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode => conversationId.hashCode;
}

class ChatConversationNotifier extends AsyncNotifier<ChatConversationEntity> {
  ChatConversationNotifier(this._request);

  final ChatConversationRequest _request;
  late final ChatRepo _repo;
  final List<ChatRealtimeSubscription> _subscriptions = [];
  bool _isTyping = false;

  @override
  FutureOr<ChatConversationEntity> build() async {
    _repo = ref.read(chatRepoProvider);
    await _repo.connectRealtime();

    final conversation = await _getConversation();
    _repo.joinConversation(conversation.id);
    _subscribe(conversation.id);
    _markIncomingMessagesSeen(conversation);

    ref.onDispose(() {
      if (_isTyping) {
        _repo.sendTypingStatus(
          conversationId: conversation.id,
          isTyping: false,
        );
      }
      _repo.leaveConversation(conversation.id);
      for (final cancel in _subscriptions) {
        cancel();
      }
    });

    return conversation.copyWith(unreadCount: 0);
  }

  void sendMessage(String content) {
    final text = content.trim();
    final conversation = state.value;
    if (conversation == null) return;

    final attachState = ref.read(attachmentUploadProvider);
    if (text.isEmpty && !attachState.hasAttachment) return;

    final uploadedFile = attachState.uploadedFile;
    final localPath = attachState.pickedFile?.filePath;

    final message = ChatMessageEntity(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      content: text,
      sentAt: _currentTimeLabel(),
      sender: ChatMessageSender.user,
      status: ChatMessageStatus.sending,
      attachmentUrl: uploadedFile?.url,
      attachmentName: uploadedFile?.fileName,
      attachmentSize: uploadedFile?.size,
      attachmentMimeType: uploadedFile?.mimeType,
      localFilePath: localPath,
    );

    _upsertMessage(conversation.id, message);
    _repo.sendMessage(conversationId: conversation.id, message: message);
    updateTypingStatus(false);

    if (uploadedFile != null) {
      ref.read(attachmentUploadProvider.notifier).resetAfterSend();
    }
  }

  void retryMessage(String messageId) {
    final conversation = state.value;
    if (conversation == null) return;

    final messageIndex = conversation.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) return;

    final message = conversation.messages[messageIndex];
    if (message.status != ChatMessageStatus.failed) return;

    _updateMessageStatus(conversation.id, messageId, ChatMessageStatus.sending);
    _repo.sendMessage(conversationId: conversation.id, message: message);
  }

  void updateTypingStatus(bool isTyping) {
    final conversation = state.value;
    if (conversation == null || _isTyping == isTyping) return;

    _isTyping = isTyping;
    _repo.sendTypingStatus(conversationId: conversation.id, isTyping: isTyping);
  }

  void _subscribe(String conversationId) {
    _subscriptions
      ..add(
        _repo.onMessageReceived(({required conversationId, required message}) {
          _upsertMessage(conversationId, message);
          if (message.sender != ChatMessageSender.user) {
            _repo.markMessageSeen(
              conversationId: conversationId,
              messageId: message.id,
            );
          }
        }),
      )
      ..add(
        _repo.onTypingStatusChanged(({
          required conversationId,
          required isTyping,
        }) {
          _updateConversation(
            conversationId,
            (conversation) => conversation.copyWith(isTyping: isTyping),
          );
        }),
      )
      ..add(
        _repo.onMessageStatusChanged(({
          required conversationId,
          required messageId,
          required status,
        }) {
          _updateMessageStatus(conversationId, messageId, status);
        }),
      )
      ..add(
        _repo.onOnlineStatusChanged(({
          required conversationId,
          required isOnline,
        }) {
          _updateConversation(
            conversationId,
            (conversation) => conversation.copyWith(isOnline: isOnline),
          );
        }),
      );
  }

  void _upsertMessage(String conversationId, ChatMessageEntity message) {
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
        isTyping: false,
      );
    });
  }

  void _updateMessageStatus(
    String conversationId,
    String messageId,
    ChatMessageStatus status,
  ) {
    _updateConversation(conversationId, (conversation) {
      final messages = conversation.messages
          .map(
            (message) => message.id == messageId
                ? message.copyWith(status: status)
                : message,
          )
          .toList();

      return conversation.copyWith(messages: messages);
    });
  }

  void _updateConversation(
    String conversationId,
    ChatConversationEntity Function(ChatConversationEntity conversation) update,
  ) {
    final conversation = state.value;
    if (conversation == null || conversation.id != conversationId) return;
    state = AsyncData(update(conversation));
  }

  void _markIncomingMessagesSeen(ChatConversationEntity conversation) {
    for (final message in conversation.messages) {
      if (message.sender != ChatMessageSender.user &&
          message.status != ChatMessageStatus.seen) {
        _repo.markMessageSeen(
          conversationId: conversation.id,
          messageId: message.id,
        );
      }
    }
  }

  String _currentTimeLabel() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<ChatConversationEntity> _getConversation() async {
    final conversationId = _request.conversationId;

    final conversationsState = ref.read(doctorConversationsProvider);
    ChatConversationEntity? baseConversation;
    if (conversationsState.hasValue) {
      for (final conversation in conversationsState.value!) {
        if (conversation.id == conversationId) {
          baseConversation = conversation;
          break;
        }
      }
    }

    if (baseConversation == null) {
      final conversations = await _repo.getConversations();
      baseConversation = conversations.firstWhere(
        (c) => c.id == conversationId,
        orElse: () => throw Exception('Conversation not found'),
      );
    }

    final messages = await _repo.getConversationMessages(conversationId);

    return baseConversation.copyWith(messages: messages);
  }
}
