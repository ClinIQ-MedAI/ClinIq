import 'package:flutter/material.dart';

class SplashBackground extends StatefulWidget {
  const SplashBackground({super.key});

  @override
  State<SplashBackground> createState() => _SplashBackgroundState();
}

class _SplashBackgroundState extends State<SplashBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4F46E5), // Indigo
            Color(0xFF5B52ED), // Slightly lighter Indigo
            Color(0xFF6D5EF9), // Deep Purple
          ],
        ),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final value = _animation.value;
          return Stack(
            children: [
              _buildSoftBlob(
                alignment: Alignment(-0.8 + (value * 0.4), -0.6 - (value * 0.2)),
                size: 300,
              ),
              _buildSoftBlob(
                alignment: Alignment(0.8 - (value * 0.3), 0.5 + (value * 0.3)),
                size: 400,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSoftBlob({required Alignment alignment, required double size}) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Color(0x0AFFFFFF), // ~4% opacity
              Color(0x00FFFFFF),
            ],
          ),
        ),
      ),
    );
  }
}
