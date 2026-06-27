import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_message_status_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message});

  final ChatMessageEntity message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatMessageSender.user;
    final isAi = message.sender == ChatMessageSender.ai;
    final bubbleColor = isUser
        ? context.colorScheme.primary
        : isAi
        ? context.colorScheme.secondary.withValues(alpha: 0.12)
        : context.colorScheme.surfaceContainerHigh;
    final textColor = isUser
        ? context.colorScheme.onPrimary
        : context.textPalette.primaryColor;
    final metaColor = isUser
        ? context.colorScheme.onPrimary.withValues(alpha: 0.72)
        : context.textPalette.secondaryColor;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.78.sw),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
              bottomLeft: Radius.circular(isUser ? 20.r : 6.r),
              bottomRight: Radius.circular(isUser ? 6.r : 20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.content.tr(),
                style: AppTextStyles.getTextStyle(14).copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
              const VerticalGap(7),
              Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
