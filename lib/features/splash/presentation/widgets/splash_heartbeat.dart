import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashHeartbeat extends StatefulWidget {
  const SplashHeartbeat({super.key});

  @override
  State<SplashHeartbeat> createState() => _SplashHeartbeatState();
}

class _SplashHeartbeatState extends State<SplashHeartbeat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) => Transform.scale(
        scale: _pulseAnim.value,
        child: child,
      ),
      child: Icon(
        Icons.favorite_rounded,
        color: Colors.white.withValues(alpha: 0.5),
        size: 18.sp,
      ),
    );
  }
}
