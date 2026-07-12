import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashHeartbeat extends StatelessWidget {
  const SplashHeartbeat({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Transform.scale(
        scale: .88 + (.12 * animation.value),
        child: Icon(
          Icons.favorite_rounded,
          color: color.withValues(alpha: .9),
          size: 16.sp,
        ),
      ),
    );
  }
}
