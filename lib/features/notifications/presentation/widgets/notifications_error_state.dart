import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsErrorState extends StatelessWidget {
  const NotificationsErrorState({
    super.key,
    required this.title,
    required this.description,
    required this.onRetry,
  });

  final String title;
  final String description;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: context.colorScheme.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48.sp,
                color: context.colorScheme.error,
              ),
            ),
            const VerticalGap(20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(18).copyWith(
                fontWeight: FontWeight.w700,
                color: context.textPalette.primaryColor,
              ),
            ),
            const VerticalGap(10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(13).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const VerticalGap(24),
            FilledButton.tonal(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                LocaleKeys.notificationsRetry.tr(),
                style: AppTextStyles.getTextStyle(14).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
