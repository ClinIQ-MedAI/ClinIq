import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      width: 120.w,
      height: 120.w,
    ).animate().scaleXY(
          begin: 0.7,
          end: 1.0,
          duration: 500.ms,
          curve: Curves.easeOutBack,
        ).fadeIn(duration: 400.ms);
  }
}
