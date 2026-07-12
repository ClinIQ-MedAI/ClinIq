import 'package:cliniq/core/helpers/get_initial_route_name.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/splash/presentation/controllers/splash_motion.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_background.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_ecg.dart';
import 'package:cliniq/features/splash/presentation/widgets/splash_progress.dart';
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
  late final SplashMotion _motion;
  final ValueNotifier<int> _heartbeatNotifier = ValueNotifier(0);

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
    _heartbeatNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const SplashBackground(),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SplashLogo(
                  animation: _motion.logo,
                  heartbeatNotifier: _heartbeatNotifier,
                ),
                const VerticalGap(24),
                SplashTitle(animation: _motion.title),
                const VerticalGap(10),
                SplashTagline(animation: _motion.tagline),
                const VerticalGap(24),
                // ECG Line
                SizedBox(
                  width: 250.w, // About 65-75% of typical screen
                  child: SplashECG(
                    animation: _motion.ecg,
                    onHeartbeat: () {
                      _heartbeatNotifier.value++;
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 58.h,
            child: Column(
              children: [SplashProgress(animation: _motion.progress)],
            ),
          ),
        ],
      ),
    );
  }
}
