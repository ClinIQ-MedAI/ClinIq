import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvailableDoctorsEmptyState extends StatelessWidget {
  final VoidCallback onSelectAnotherDate;

  const AvailableDoctorsEmptyState({
    super.key,
    required this.onSelectAnotherDate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.primary.withValues(alpha: 0.08),
              ),
              child: Icon(
                Icons.event_busy_rounded,
                size: 48.sp,
                color: context.colorScheme.primary,
              ),
            ).animate().fadeIn(duration: 400.ms).scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
              curve: Curves.easeOutBack,
            ),
            const VerticalGap(24),
            Text(
              LocaleKeys.bookingAvailableDoctorsEmptyTitle.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(20).copyWith(
                fontWeight: FontWeight.w900,
                color: context.textPalette.primaryColor,
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(
              begin: 0.1,
              end: 0,
              curve: Curves.easeOut,
            ),
            const VerticalGap(12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                LocaleKeys.bookingAvailableDoctorsEmptyDescription.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.getTextStyle(14).copyWith(
                  color: context.textPalette.secondaryColor,
                  height: 1.5,
                ),
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(
              begin: 0.1,
              end: 0,
              curve: Curves.easeOut,
            ),
            const VerticalGap(24),
            SizedBox(
              height: 48.h,
              child: ElevatedButton(
                onPressed: onSelectAnotherDate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.primary,
                  foregroundColor: context.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  elevation: 0,
                ),
                child: Text(
                  LocaleKeys.bookingAvailableDoctorsSelectAnotherDate.tr(),
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 350.ms, duration: 400.ms).slideY(
              begin: 0.1,
              end: 0,
              curve: Curves.easeOut,
            ),
          ],
        ),
      ),
    );
  }
}
