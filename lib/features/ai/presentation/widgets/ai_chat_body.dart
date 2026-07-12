import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_chat_provider.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_scan_upload_provider.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_chat_attachment_picker.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_chat_suggested_prompts.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_upload_request_card.dart';
import 'package:cliniq/features/ai/presentation/widgets/scan_modality_bottom_sheet.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/attachment_preview_widget.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_header.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiChatBody extends ConsumerWidget {
  const AiChatBody({
    super.key,
    required this.conversation,
    required this.uploadState,
    required this.showUpload,
  });
  final ChatConversationEntity conversation;
  final AiScanUploadState uploadState;
  final bool showUpload;

  Future<void> _handleAttachmentTap(BuildContext context, WidgetRef ref) async {
    await AiChatAttachmentPicker.show(
      context,
      onScanSelected: () async {
        final notifier = ref.read(aiScanUploadProvider.notifier);
        final picked = await notifier.pickFile(true);
        if (picked && context.mounted) {
          final modality = await ScanModalityBottomSheet.show(context);
          if (modality != null && context.mounted) {
            notifier.uploadWithModality(modality);
          }
        }
      },
      onPrescriptionSelected: () async {
        final notifier = ref.read(aiScanUploadProvider.notifier);
        notifier.pickFile(false);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const VerticalGap(18),
        ChatHeader(conversation: conversation).animate().fadeIn(),
        const VerticalGap(8),
        Expanded(
          child: ChatMessageList(
            conversation: conversation,
            onMessageRetry: (messageId) {
              ref.read(aiChatProvider.notifier).retryFailedAi(messageId);
            },
          ),
        ),
        if (conversation.messages.isEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: AiChatSuggestedPrompts(
              onPromptTapped: (prompt) {
                ref.read(aiChatProvider.notifier).sendMessage(prompt);
              },
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.08),
          ),
        if (showUpload)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ).copyWith(bottom: 12.h),
            child: AiUploadRequestCard(
              onUploadTap: () => _handleAttachmentTap(context, ref),
            ).animate().fadeIn().slideY(begin: 0.1),
          ),
        if (uploadState.localFilePath != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: AttachmentPreviewWidget(
              fileName: uploadState.fileName ?? '',
              filePath: uploadState.localFilePath!,
              isUploading: uploadState.isUploading,
              fileSize: uploadState.fileSize,
              onRemove: () =>
                  ref.read(aiScanUploadProvider.notifier).removeAttachment(),
            ),
          ),
        ChatInputField(
          bottomSpacing: 28,
          onMessageSubmitted: (text) {
            ref.read(aiChatProvider.notifier).sendMessage(text);
          },
          onTypingChanged: (_) {},
          onAttachmentTap: () => _handleAttachmentTap(context, ref),
          hasAttachment: uploadState.hasAttachment,
          isSendDisabled: uploadState.isUploading,
        ),
      ],
    );
  }
}
