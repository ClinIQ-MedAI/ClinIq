import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_online_indicator.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_unread_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatConversationTile extends StatelessWidget {
  const ChatConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final ChatConversationEntity conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: context.colorScheme.primary.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.primary.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ChatAvatar(type: conversation.type, size: 54),
                Positioned(
                  right: -1.w,
                  bottom: -1.w,
                  child: ChatOnlineIndicator(isOnline: conversation.isOnline),
                ),
              ],
            ),
            const HorizontalGap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.getTextStyle(16).copyWith(
                            color: context.textPalette.primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const HorizontalGap(8),
                      Text(
                        conversation.lastMessageTime,
                        style: AppTextStyles.getTextStyle(11).copyWith(
                          color: conversation.unreadCount > 0
                              ? context.colorScheme.primary
                              : context.textPalette.secondaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const VerticalGap(5),
                  Text(
                    conversation.subtitle.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.getTextStyle(12).copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const VerticalGap(7),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.getTextStyle(13).copyWith(
                            color: context.textPalette.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const HorizontalGap(10),
                      ChatUnreadBadge(count: conversation.unreadCount),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
