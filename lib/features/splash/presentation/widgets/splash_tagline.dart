import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashTagline extends StatelessWidget {
  const SplashTagline({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return FadeTransition(
      opacity: animation,
      child: Text(
        LocaleKeys.splashTagline.tr(),
        textAlign: TextAlign.center,
        style: AppTextStyles.getTextStyle(15).copyWith(
          color: onPrimary.withValues(alpha: .76),
          fontWeight: FontWeight.w500,
          letterSpacing: .35.sp,
        ),
      ),
    );
  }
}
