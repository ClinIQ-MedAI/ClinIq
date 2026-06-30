import 'dart:async';

import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatConversationProvider =
    AsyncNotifierProvider.family<
      ChatConversationNotifier,
      ChatConversationEntity,
      ChatConversationRequest
    >((request) => ChatConversationNotifier(request));

class ChatConversationRequest {
  const ChatConversationRequest._({this.type, this.conversationId});

  const ChatConversationRequest.byType(ChatType type) : this._(type: type);

  const ChatConversationRequest.byId(String conversationId)
    : this._(conversationId: conversationId);

  final ChatType? type;
  final String? conversationId;

  @override
  bool operator ==(Object other) {
    return other is ChatConversationRequest &&
        other.type == type &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode => Object.hash(type, conversationId);
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
    if (text.isEmpty || conversation == null) return;

    final message = ChatMessageEntity(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      content: text,
      sentAt: _currentTimeLabel(),
      sender: ChatMessageSender.user,
      status: ChatMessageStatus.sending,
    );

    _upsertMessage(conversation.id, message);
    _repo.sendMessage(conversationId: conversation.id, message: message);
    updateTypingStatus(false);
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

  Future<ChatConversationEntity> _getConversation() {
    final conversationId = _request.conversationId;
    if (conversationId != null) {
      return _repo.getDoctorConversationById(conversationId);
    }

    return _repo.getConversation(_request.type ?? ChatType.doctor);
  }
}
