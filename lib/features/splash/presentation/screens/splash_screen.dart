import 'package:cliniq/core/helpers/get_initial_route_name.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/splash/presentation/controllers/splash_motion.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_background.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_heartbeat.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_loader.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_logo.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_orbiting_symbols.dart';
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
  late final SplashMotion _motion;

  @override
  void initState() {
    super.initState();
    _motion = SplashMotion(vsync: this, onCompleted: _navigateToInitialRoute)
      ..start();
  }

  void _navigateToInitialRoute() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(getInitialRouteName());
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SplashBackground(animation: _motion.background),

          SplashOrbitingSymbols(animation: _motion.symbols),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SplashLogo(animation: _motion.logo),
                const VerticalGap(24),
                SplashTitle(animation: _motion.copy),
                const VerticalGap(10),
                SplashTagline(animation: _motion.copy),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 58.h,
            child: Column(
              children: [
                SplashHeartbeat(animation: _motion.pulse),
                const VerticalGap(14),
                SplashLoader(animation: _motion.pulse),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
