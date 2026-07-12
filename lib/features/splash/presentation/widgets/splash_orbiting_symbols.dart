import 'package:cliniq/features/splash/presentation/widgets/splash_symbol.dart';
import 'package:flutter/material.dart';

class SplashOrbitingSymbols extends StatelessWidget {
  const SplashOrbitingSymbols({super.key, required this.animation});
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) => Stack(
          children: [
            SplashSymbol(
              alignment: const Alignment(-.68, -.18),
              icon: Icons.forum_outlined,
              color: color,
              progress: animation.value,
              delay: 0,
            ),
            SplashSymbol(
              alignment: const Alignment(.66, -.28),
              icon: Icons.calendar_month_outlined,
              color: color,
              progress: animation.value,
              delay: .16,
            ),
            SplashSymbol(
              alignment: const Alignment(.6, .3),
              icon: Icons.shield_outlined,
              color: color,
              progress: animation.value,
              delay: .28,
            ),
            SplashSymbol(
              alignment: const Alignment(-.62, .36),
              icon: Icons.monitor_heart_outlined,
              color: color,
              progress: animation.value,
              delay: .38,
            ),
          ],
        ),
      ),
    );
  }
}
