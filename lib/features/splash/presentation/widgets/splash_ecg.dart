import 'package:flutter/material.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_ecg_painter.dart';

class SplashECG extends StatefulWidget {
  const SplashECG({super.key, required this.animation, required this.onHeartbeat});

  final Animation<double> animation;
  final VoidCallback onHeartbeat;

  @override
  State<SplashECG> createState() => _SplashECGState();
}

class _SplashECGState extends State<SplashECG> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _hasTriggeredHeartbeat = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _controller.addListener(() {
      // Trigger heartbeat callback when the leading edge of the ECG passes the spike
      // The spike in the painter happens around the middle of the screen
      // If we assume a repeating pattern, let's trigger when it hits a certain phase.
      // E.g., when the value crosses 0.5.
      if (_controller.value >= 0.45 && _controller.value <= 0.55) {
        if (!_hasTriggeredHeartbeat) {
          _hasTriggeredHeartbeat = true;
          widget.onHeartbeat();
        }
      } else {
        _hasTriggeredHeartbeat = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return SizedBox(
            width: double.infinity,
            height: 40,
            child: CustomPaint(
              painter: SplashECGPainter(
                progress: _controller.value,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          );
        },
      ),
    );
  }
}
