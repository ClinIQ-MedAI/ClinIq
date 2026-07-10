import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/attachment_preview_widget.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_header.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatConversationBody extends StatelessWidget {
  const ChatConversationBody({
    super.key,
    required this.conversation,
    required this.onMessageSubmitted,
    required this.onTypingChanged,
    this.onAttachmentTap,
    this.onRemoveAttachment,
    this.hasAttachment = false,
    this.attachmentFileName,
    this.attachmentFilePath,
    this.isAttachmentUploading = false,
    this.attachmentFileSize,
    this.isSendDisabled = false,
    this.onMessageRetry,
    this.inputBottomSpacing = 16,
  });

  final ChatConversationEntity conversation;
  final ValueChanged<String> onMessageSubmitted;
  final ValueChanged<bool> onTypingChanged;
  final VoidCallback? onAttachmentTap;
  final VoidCallback? onRemoveAttachment;
  final ValueChanged<String>? onMessageRetry;
  final bool hasAttachment;
  final String? attachmentFileName;
  final String? attachmentFilePath;
  final bool isAttachmentUploading;
  final int? attachmentFileSize;
  final bool isSendDisabled;
  final double inputBottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VerticalGap(18),
        ChatHeader(
          conversation: conversation,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.1),
        const VerticalGap(8),
        Expanded(
          child: ChatMessageList(
            conversation: conversation,
            onMessageRetry: onMessageRetry,
          ),
        ),
        if (attachmentFileName != null && attachmentFilePath != null) ...[
          const VerticalGap(8),
          AttachmentPreviewWidget(
            fileName: attachmentFileName!,
            filePath: attachmentFilePath!,
            isUploading: isAttachmentUploading,
            fileSize: attachmentFileSize,
            onRemove: onRemoveAttachment ?? () {},
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
          const VerticalGap(8),
        ],
        ChatInputField(
          bottomSpacing: inputBottomSpacing,
          onMessageSubmitted: onMessageSubmitted,
          onTypingChanged: onTypingChanged,
          onAttachmentTap: onAttachmentTap,
          hasAttachment: hasAttachment,
          isSendDisabled: isSendDisabled,
        ),
      ],
    );
  }
}
