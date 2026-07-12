import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashLoader extends StatelessWidget {
  const SplashLoader({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => SizedBox(
        height: 18.h,
        width: 68.w,
        child: CustomPaint(
          painter: _SplashPulsePainter(color, animation.value),
        ),
      ),
    );
  }
}

class _SplashPulsePainter extends CustomPainter {
  const _SplashPulsePainter(this.color, this.progress);

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: .72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final beat = (progress * 2 - 1).abs();
    final path = Path()
      ..moveTo(0, size.height * .58)
      ..lineTo(size.width * .24, size.height * .58)
      ..lineTo(size.width * .37, size.height * (.58 - (.26 * beat)))
      ..lineTo(size.width * .48, size.height * (.87 - (.48 * beat)))
      ..lineTo(size.width * .59, size.height * .58)
      ..lineTo(size.width, size.height * .58);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SplashPulsePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
