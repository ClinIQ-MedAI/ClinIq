import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_message_status_icon.dart';
import 'package:cliniq/features/chat/presentation/widgets/file_message_bubble.dart';
import 'package:cliniq/features/chat/presentation/widgets/image_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message, this.onRetry});

  final ChatMessageEntity message;
  final VoidCallback? onRetry;

  bool get _hasText => message.content.isNotEmpty;
  bool get _hasAttachment => message.hasAttachment;
  bool get _isImage => _hasAttachment && message.isImageAttachment;
  bool get _isFile => _hasAttachment && !message.isImageAttachment;
  bool get _isImageOnly => _isImage && !_hasText;
  bool get _isFailed => message.status == ChatMessageStatus.failed;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatMessageSender.user;
    final isAi = message.sender == ChatMessageSender.ai;

    if (!_hasText && !_hasAttachment) return const SizedBox.shrink();

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (_isImageOnly)
              ImageMessageBubble(message: message, isUser: isUser)
            else
              _bubbleWithContainer(context, isUser, isAi),
            if (_isFailed && onRetry != null) ...[
              const VerticalGap(4),
              _retryButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _bubbleWithContainer(BuildContext context, bool isUser, bool isAi) {
    final bubbleColor = _isFailed
        ? context.colorScheme.errorContainer
        : isUser
        ? context.colorScheme.primary
        : isAi
        ? context.colorScheme.secondary.withValues(alpha: 0.12)
        : context.colorScheme.surface;
    final textColor = isUser
        ? context.colorScheme.onPrimary
        : context.textPalette.primaryColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: _hasText || _isFile ? 14.h : 0,
      ),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
          bottomLeft: Radius.circular(isUser ? 24.r : 8.r),
          bottomRight: Radius.circular(isUser ? 8.r : 24.r),
        ),
        boxShadow: _isFailed
            ? null
            : [
                if (!isUser)
                  BoxShadow(
                    color: context.colorScheme.primary.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                if (isUser)
                  BoxShadow(
                    color: context.colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isImage)
            Padding(
              padding: EdgeInsets.only(bottom: _hasText ? 8.h : 0),
              child: ImageMessageBubble(message: message, isUser: isUser),
            ),
          if (_isFile)
            Padding(
              padding: EdgeInsets.only(bottom: _hasText ? 8.h : 0),
              child: FileMessageBubble(message: message, isUser: isUser),
            ),
          if (_hasText)
            Text(
              message.content,
              style: AppTextStyles.getTextStyle(15).copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          const VerticalGap(6),
          _metaRow(context, isUser),
        ],
      ),
    );
  }

  Widget _metaRow(BuildContext context, bool isUser) {
    final metaColor = isUser
        ? context.colorScheme.onPrimary.withValues(alpha: 0.72)
        : context.textPalette.secondaryColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message.sentAt,
          style: AppTextStyles.getTextStyle(
            10,
          ).copyWith(color: metaColor, fontWeight: FontWeight.w600),
        ),
        if (isUser) ...[
          const HorizontalGap(4),
          ChatMessageStatusIcon(status: message.status),
        ],
      ],
    );
  }

  Widget _retryButton(BuildContext context) {
    final scheme = context.colorScheme;

    return GestureDetector(
      onTap: onRetry,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh_rounded,
              size: 14.sp,
              color: scheme.onErrorContainer,
            ),
            const HorizontalGap(4),
            Text(
              'Retry',
              style: AppTextStyles.getTextStyle(11).copyWith(
                color: scheme.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
