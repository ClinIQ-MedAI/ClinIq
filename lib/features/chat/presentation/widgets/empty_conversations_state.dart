import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyConversationsState extends StatelessWidget {
  const EmptyConversationsState({super.key, this.onStartConversation});

  final VoidCallback? onStartConversation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(context).animate().fadeIn(
              duration: 600.ms,
            ).slideY(begin: 0.2, curve: Curves.easeOut),
            const VerticalGap(32),
            Text(
              LocaleKeys.chatDoctorListEmptyTitle.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(24).copyWith(
                color: context.textPalette.primaryColor,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15),
            const VerticalGap(14),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 320.w),
              child: Text(
                LocaleKeys.chatDoctorListEmptyDescription.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.getTextStyle(14).copyWith(
                  color: context.textPalette.secondaryColor,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
              ),
            ).animate().fadeIn(delay: 350.ms),
            if (onStartConversation != null) ...[
              const VerticalGap(36),
              _buildStartButton(context).animate().fadeIn(delay: 500.ms)
                ..scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), duration: 400.ms),
              const VerticalGap(16),
              Text(
                LocaleKeys.chatDoctorHelperText.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.getTextStyle(12).copyWith(
                  color: context.textPalette.secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(delay: 650.ms),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return Container(
      width: 140.w,
      height: 140.w,
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 56.sp,
            color: context.colorScheme.primary.withValues(alpha: 0.3),
          ),
          Icon(
            Icons.chat_bubble_rounded,
            size: 48.sp,
            color: context.colorScheme.primary,
          ),
          Positioned(
            right: 32.w,
            bottom: 32.w,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_hospital_rounded,
                size: 16.sp,
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: onStartConversation,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
          elevation: 6,
          shadowColor: context.colorScheme.primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_rounded,
              size: 20.sp,
            ),
            const HorizontalGap(10),
            Text(
              LocaleKeys.chatDoctorStartFirstConversation.tr(),
              style: AppTextStyles.getTextStyle(16).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
