import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key, required this.conversation});

  final ChatConversationEntity conversation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mark_chat_read_rounded,
                size: 64.sp,
                color: context.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const VerticalGap(24),
            DoctorAvatar(
              imageUrl: conversation.imageUrl,
              name: conversation.title,
              size: 80,
            ),
            const VerticalGap(16),
            Text(
              'startYourConversationWith'.tr(args: [conversation.title.tr()]),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(20).copyWith(
                color: context.textPalette.primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const VerticalGap(10),
            Text(
              'weAreHereToHelpYou'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(14).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
