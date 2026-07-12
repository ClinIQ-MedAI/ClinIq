import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorChatHeader extends StatelessWidget {
  const DoctorChatHeader({super.key, required this.conversation});

  final ChatConversationEntity conversation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.textPalette.primaryColor,
              size: 20.sp,
            ),
          ),
          DoctorAvatar(
            imageUrl: conversation.imageUrl,
            name: conversation.title,
            size: 52,
          ),
          const HorizontalGap(12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.title.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.getTextStyle(16).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  conversation.subtitle.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.getTextStyle(12).copyWith(
                    color: context.textPalette.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1);
  }
}
