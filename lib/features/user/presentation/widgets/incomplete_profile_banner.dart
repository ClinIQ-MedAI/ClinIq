import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IncompleteProfileBanner extends StatelessWidget {
  const IncompleteProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary.withValues(alpha: 0.08),
            context.colorScheme.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: context.colorScheme.primary,
              size: 40.sp,
            ),
          ),
          const VerticalGap(20),
          Text(
            LocaleKeys.profileUserCompleteProfileTitle.tr(),
            style: AppTextStyles.getTextStyle(20).copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPalette.primaryColor,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const VerticalGap(8),
          Text(
            LocaleKeys.profileUserCompleteProfileDescription.tr(),
            style: AppTextStyles.getTextStyle(14).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const VerticalGap(24),
          CustomButton(
            text: LocaleKeys.profileUserCompleteProfileButton,
            onPressed: () {
              Navigator.pushNamed(context, Routes.completeUserProfileScreen);
            },
          ),
        ],
      ),
    );
  }
}
