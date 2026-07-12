import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashSymbol extends StatelessWidget {
  const SplashSymbol({
    super.key,
    required this.alignment,
    required this.icon,
    required this.color,
    required this.progress,
    required this.delay,
  });
  final Alignment alignment;
  final IconData icon;
  final Color color;
  final double progress;
  final double delay;
  @override
  Widget build(BuildContext context) {
    final value = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);
    final drift = math.sin((value + delay) * math.pi) * 7.h;
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: Offset(0, -drift),
        child: Opacity(
          opacity: value * .38,
          child: Icon(icon, color: color, size: 23.sp),
        ),
      ),
    );
  }
}
