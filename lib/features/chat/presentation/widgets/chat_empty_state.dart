import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_avatar.dart';
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
            ChatAvatar(type: conversation.type, size: 76),
            const VerticalGap(20),
            Text(
              conversation.emptyTitle.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(20).copyWith(
                color: context.textPalette.primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const VerticalGap(10),
            Text(
              conversation.emptyDescription.tr(),
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
