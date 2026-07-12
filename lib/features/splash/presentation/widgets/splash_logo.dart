import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashLogo extends StatefulWidget {
  const SplashLogo({
    super.key,
    required this.animation,
    required this.heartbeatNotifier,
  });

  final Animation<double> animation;
  final ValueNotifier<int> heartbeatNotifier;

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _pulseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    widget.heartbeatNotifier.addListener(_onHeartbeat);
  }

  void _onHeartbeat() {
    if (mounted) {
      _pulseController.forward(from: 0).then((_) {
        if (mounted) {
          _pulseController.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    widget.heartbeatNotifier.removeListener(_onHeartbeat);
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.animation, _pulseAnimation]),
      builder: (context, child) {
        // Base scale from entrance animation
        final baseScale = 0.8 + (0.2 * widget.animation.value);
        // Pulse adds up to 3% (1.03) scale when heartbeat happens
        final pulseScale = 1.0 + (0.03 * _pulseAnimation.value);
        final finalScale = baseScale * pulseScale;
        
        final glowOpacity = 0.15 * _pulseAnimation.value * widget.animation.value;

        return Opacity(
          opacity: widget.animation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Heartbeat glow
              if (glowOpacity > 0)
                Container(
                  width: 150.w,
                  height: 150.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: glowOpacity),
                        blurRadius: 20.w,
                        spreadRadius: 5.w,
                      ),
                    ],
                  ),
                ),
              // Logo
              Transform.scale(
                scale: finalScale,
                child: Container(
                  width: 136.w,
                  height: 136.w,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent, // Clean minimal style
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
      child: RepaintBoundary(child: Image.asset('assets/images/logo.png')),
    );
  }
}

