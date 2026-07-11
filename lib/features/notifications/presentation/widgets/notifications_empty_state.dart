import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

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
                color: context.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 48.sp,
                color: context.colorScheme.primary,
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
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
