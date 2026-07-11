import 'package:cliniq/core/helpers/get_initial_route.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_background.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_heartbeat.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_loader.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_logo.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_tagline.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeOutAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _fadeOutAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.9, 1.0, curve: Curves.easeOut),
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToInitialRoute();
      }
    });
    _controller.forward();
  }

  void _navigateToInitialRoute() {
    final route = getInitialRoute();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => route),
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
      opacity: _fadeOutAnim,
      child: Scaffold(
        body: Stack(
          children: [
            const SplashBackground(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SplashLogo(),
                  const VerticalGap(24),
                  const SplashTitle(),
                  const VerticalGap(12),
                  const SplashTagline(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 80.h,
              child: Column(
                children: [
                  const SplashHeartbeat(),
                  const VerticalGap(16),
                  const SplashLoader(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
