import 'package:cliniq/features/splash/presentation/widgets/splash_glow_orb.dart';
import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primary,
              Color.lerp(scheme.primary, scheme.secondary, .16)!,
            ],
          ),
        ),
        child: Stack(
          children: [
            SplashGlowOrb(
              alignment: const Alignment(.95, -.9),
              sizeFactor: .62,
              opacity: .13 * animation.value,
            ),
            SplashGlowOrb(
              alignment: const Alignment(-.95, .58),
              sizeFactor: .48,
              opacity: .08 * animation.value,
            ),
          ],
        ),
      ),
    );
  }
}
