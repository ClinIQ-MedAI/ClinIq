import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'ClinIQ',
      style: AppTextStyles.getTextStyle(36).copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 4.sp,
      ),
    ).animate().fadeIn(
          delay: 1000.ms,
          duration: 500.ms,
        ).slideY(begin: 0.3, end: 0.0, curve: Curves.easeOutCubic);
  }
}
