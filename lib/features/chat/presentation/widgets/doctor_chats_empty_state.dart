import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorChatsEmptyState extends StatelessWidget {
  const DoctorChatsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              color: context.colorScheme.primary,
              size: 56.sp,
            ),
            const VerticalGap(18),
            Text(
              LocaleKeys.chatDoctorListEmptyTitle.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(20).copyWith(
                color: context.textPalette.primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const VerticalGap(10),
            Text(
              LocaleKeys.chatDoctorListEmptyDescription.tr(),
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
