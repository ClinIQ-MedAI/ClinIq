import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:cliniq/features/ai/domain/entities/chatbot_reply_entity.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_chat_repo_provider.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_scan_repo_provider.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/presentation/providers/attachment_provider.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowUploadNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;
  void hide() => state = false;
}

final aiShowUploadRequestProvider =
    NotifierProvider<ShowUploadNotifier, bool>(ShowUploadNotifier.new);

final aiChatProvider =
    AsyncNotifierProvider<AiChatNotifier, ChatConversationEntity>(
        AiChatNotifier.new);

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
    final historyMessages = historyResult.fold(
      (failure) {
        log('AI Chat: History load failed: $failure');
        return <ChatMessageEntity>[];
      },
      (messages) => messages,
    );

    final conversation = _buildConversation();
    if (historyMessages.isEmpty) return conversation;

    return conversation.copyWith(
      messages: historyMessages,
      lastMessage: historyMessages.last.content,
      lastMessageTime: historyMessages.last.sentAt,
    );
  }

  void _handleReply(ChatbotReplyEntity reply) {
    log('_handleReply called — chatId: ${reply.chatId}, status: ${reply.status}');

    final conversation = state.value;
    if (conversation == null) {
      return;
    }

    final loadingId = '${reply.chatId}-loading';

    final loadingIndex =
        conversation.messages.indexWhere((m) => m.id == loadingId);
    if (loadingIndex == -1) {
      return;
    }


    final messages = [...conversation.messages];
    messages.removeAt(loadingIndex);

    final status = reply.status.toLowerCase();

    if (status == 'completed') {
      messages.add(ChatMessageEntity(
        id: reply.chatId,
        content: reply.reply,
        sentAt: reply.finishedAt ?? _currentTimeLabel(),
        sender: ChatMessageSender.ai,
        status: ChatMessageStatus.seen,
      ));
    } else if (status == 'failed') {
      messages.add(ChatMessageEntity(
        id: reply.chatId,
        content: reply.error ?? 'An error occurred',
        sentAt: _currentTimeLabel(),
        sender: ChatMessageSender.ai,
        status: ChatMessageStatus.failed,
      ));
    } 

    state = AsyncData(conversation.copyWith(
      messages: messages,
      lastMessage: messages.last.content,
      lastMessageTime: messages.last.sentAt,
    ));

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
    if (conversation == null) return;

    final attachState = ref.read(attachmentUploadProvider);
    if (text.isEmpty && !attachState.hasAttachment) return;

    ref.read(aiShowUploadRequestProvider.notifier).hide();

    String? scanId;
    String? prescriptionId;
    String? attachmentUrl;
    String? mimeType;

    if (attachState.hasAttachment) {
      final modality = attachState.selectedModality;
      final filePath = attachState.localFilePath;
      if (filePath != null) {
        final base64 = await _fileToBase64(filePath);
        if (base64 != null) {
          final patientId = _getPatientId();
          if (patientId != null) {
            final scanRepo = ref.read(aiScanRepoProvider);
            if (modality != null && modality != 'PRESCRIPTION') {
              final result = await scanRepo.uploadScan(
                imageBase64: base64,
                patientId: patientId,
                modality: modality,
              );
              result.fold((_) {}, (scan) {
                scanId = scan.id;
                attachmentUrl = scan.url;
                mimeType = _guessMimeType(scan.url);
              });
            } else {
              final result = await scanRepo.uploadPrescription(
                imageBase64: base64,
                patientId: patientId,
              );
              result.fold((_) {}, (scan) {
                prescriptionId = scan.id;
                attachmentUrl = scan.url;
                mimeType = _guessMimeType(scan.url);
              });
            }
          }
        }
      }
    }

    final userMessage = ChatMessageEntity(
      id: 'local-ai-${DateTime.now().microsecondsSinceEpoch}',
      content: text,
      sentAt: _currentTimeLabel(),
      sender: ChatMessageSender.user,
      status: ChatMessageStatus.sending,
      attachmentUrl: attachmentUrl,
      attachmentName: attachState.fileName,
      attachmentSize: attachState.fileSize,
      attachmentMimeType: mimeType,
      localFilePath: attachState.localFilePath,
    );

    _addMessage(userMessage);

    if (attachState.hasAttachment) {
      ref.read(attachmentUploadProvider.notifier).resetAfterSend();
    }

    final languagePreference =
        ref.read(currentUserProvider)?.role == 'ar' ? 'ar' : null;

    try {
      final repo = ref.read(aiChatRepoProvider);
      final result = await repo.sendChatMessage(
        message: text,
        languagePreference: languagePreference,
        scanId: scanId,
        prescriptionId: prescriptionId,
      );

      result.fold(
        (failure) {
          _updateMessageStatus(userMessage.id, ChatMessageStatus.failed);
        },
        (response) {
          _updateMessageStatus(userMessage.id, ChatMessageStatus.sent);

          final loadingId = '${response.chatId}-loading';
          _addMessage(ChatMessageEntity(
            id: loadingId,
            content: '',
            sentAt: _currentTimeLabel(),
            sender: ChatMessageSender.ai,
            status: ChatMessageStatus.loading,
          ));
        },
      );
    } catch (e) {
      _updateMessageStatus(userMessage.id, ChatMessageStatus.failed);
    }
  }

  void retryFailedAi(String messageId) {
    final conversation = state.value;
    if (conversation == null) return;

    final messageIndex =
        conversation.messages.indexWhere((m) => m.id == messageId);
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

  void _addMessage(ChatMessageEntity message) {
    final conversation = state.value;
    if (conversation == null) return;

    state = AsyncData(conversation.copyWith(
      messages: [...conversation.messages, message],
      lastMessage: message.content,
      lastMessageTime: message.sentAt,
    ));
  }

  void _updateMessageStatus(String messageId, ChatMessageStatus status) {
    final conversation = state.value;
    if (conversation == null) return;

    state = AsyncData(conversation.copyWith(
      messages: conversation.messages
          .map((m) => m.id == messageId ? m.copyWith(status: status) : m)
          .toList(),
    ));
  }

  Future<String?> _fileToBase64(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (_) {
      return null;
    }
  }

  String? _getPatientId() {
    return ref.read(currentUserProvider)?.id;
  }

  String _guessMimeType(String url) {
    final ext = url.split('.').last.toLowerCase();
    if (['jpg', 'jpeg'].contains(ext)) return 'image/jpeg';
    if (ext == 'png') return 'image/png';
    if (ext == 'pdf') return 'application/pdf';
    if (ext == 'dcm') return 'application/dicom';
    return 'application/octet-stream';
  }

  String _currentTimeLabel() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
