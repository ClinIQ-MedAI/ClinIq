import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, .18),
          end: Offset.zero,
        ).animate(animation),
        child: Text(
          LocaleKeys.splashTitle.tr(),
          style: AppTextStyles.getTextStyle(34).copyWith(
            color: onPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2.sp,
          ),
        ),
      ),
    );
  }
}
