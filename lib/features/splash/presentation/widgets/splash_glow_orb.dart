import 'package:flutter/material.dart';

class SplashGlowOrb extends StatelessWidget {
  const SplashGlowOrb({
    super.key,
    required this.alignment,
    required this.sizeFactor,
    required this.opacity,
  });
  final Alignment alignment;
  final double sizeFactor;
  final double opacity;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: sizeFactor,
        child: AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: opacity),
            ),
          ),
        ),
      ),
    );
  }
}
