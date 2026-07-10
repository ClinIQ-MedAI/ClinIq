import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSectionEmptyState extends StatelessWidget {
  const HomeSectionEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: context.colorScheme.primary.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                icon,
                size: 32.sp,
                color: context.colorScheme.primary,
              ),
            ),
            const VerticalGap(16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(16).copyWith(
                fontWeight: FontWeight.w700,
                color: context.textPalette.primaryColor,
              ),
            ),
            const VerticalGap(8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(13).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            if (action != null) ...[
              const VerticalGap(20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
