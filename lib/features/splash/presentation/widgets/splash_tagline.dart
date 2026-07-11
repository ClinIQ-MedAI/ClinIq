import 'package:easy_localization/easy_localization.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashTagline extends StatelessWidget {
  const SplashTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.splashTagline.tr(),
      style: AppTextStyles.getTextStyle(16).copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.white.withValues(alpha: 0.75),
        letterSpacing: 1.sp,
      ),
    ).animate().fadeIn(
          delay: 1400.ms,
          duration: 500.ms,
        ).slideY(begin: 0.3, end: 0.0, curve: Curves.easeOutCubic);
  }
}
