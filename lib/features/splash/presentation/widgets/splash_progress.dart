import 'package:flutter/material.dart';

class SplashProgress extends StatefulWidget {
  const SplashProgress({super.key, required this.animation});

  final Animation<double> animation;

  @override
  State<SplashProgress> createState() => _SplashProgressState();
}

class _SplashProgressState extends State<SplashProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        animation: _shimmerAnimation,
        builder: (context, _) {
          return Container(
            width: 140,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.5),
              child: FractionalTranslation(
                translation: Offset(_shimmerAnimation.value, 0),
                child: Container(
                  width: 140,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.7),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
