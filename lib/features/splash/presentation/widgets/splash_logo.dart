import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final scale = .8 + (.2 * animation.value);
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 136.w,
              height: 136.w,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: onPrimary.withValues(alpha: .1 * animation.value),
              ),
              child: child,
            ),
          ),
        );
      },
      child: RepaintBoundary(child: Image.asset('assets/images/logo.png')),
    );
  }
}
