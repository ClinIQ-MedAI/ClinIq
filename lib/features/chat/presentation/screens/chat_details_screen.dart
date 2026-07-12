import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/chat/domain/entities/attachment_type.dart';
import 'package:cliniq/features/chat/presentation/providers/attachment_provider.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_conversation_provider.dart';
import 'package:cliniq/features/chat/presentation/widgets/attachment_picker_sheet.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_conversation_body.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_loading_state.dart';
import 'package:cliniq/features/chat/presentation/widgets/doctor_chat_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDetailsScreen extends ConsumerWidget {
  const ChatDetailsScreen({super.key, required this.conversationId});

  final String conversationId;

  void _handleAttachmentTap(BuildContext context, WidgetRef ref) {
    AttachmentPickerSheet.show(
      context,
      onTypeSelected: (AttachmentType type) {
        ref.read(attachmentUploadProvider.notifier).pickFile(type);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ChatConversationRequest(conversationId: conversationId);
    final conversationAsync = ref.watch(chatConversationProvider(request));
    final uploadState = ref.watch(attachmentUploadProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: conversationAsync.when(
          data: (conversation) => Column(
            children: [
              DoctorChatHeader(conversation: conversation),
              Divider(
                height: 1,
                thickness: 1,
                color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
              Expanded(
                child: ChatConversationBody(
                  conversation: conversation,
                  onMessageSubmitted: (text) => ref
                      .read(chatConversationProvider(request).notifier)
                      .sendMessage(text),
                  onMessageRetry: (messageId) => ref
                      .read(chatConversationProvider(request).notifier)
                      .retryMessage(messageId),
                  onTypingChanged: ref
                      .read(chatConversationProvider(request).notifier)
                      .updateTypingStatus,
                  onAttachmentTap: () => _handleAttachmentTap(context, ref),
                  hasAttachment: uploadState.hasAttachment,
                  attachmentFileName: uploadState.pickedFile?.fileName,
                  attachmentFilePath: uploadState.pickedFile?.filePath,
                  isAttachmentUploading: uploadState.isUploading,
                  attachmentFileSize: uploadState.pickedFile?.fileSize,
                  onRemoveAttachment: () =>
                      ref.read(attachmentUploadProvider.notifier).removeAttachment(),
                  isSendDisabled: uploadState.isUploading,
                ),
              ),
            ],
          ),
          error: (error, stackTrace) => Center(
            child: Text(LocaleKeys.messagesFailuresUnexpectedError.tr()),
          ),
          loading: () => const ChatLoadingState(),
        ),
      ),
    );
  }
}
