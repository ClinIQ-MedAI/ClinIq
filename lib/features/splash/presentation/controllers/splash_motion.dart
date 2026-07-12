import 'package:flutter/material.dart';

class SplashMotion {
  SplashMotion({
    required TickerProvider vsync,
    required VoidCallback onCompleted,
  }) : _controller = AnimationController(
         vsync: vsync,
         duration: const Duration(milliseconds: 2100),
       ) {
    background = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, .24, curve: Curves.easeOut),
    );
    logo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.08, .42, curve: Curves.easeOutCubic),
    );
    symbols = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.25, .66, curve: Curves.easeOutCubic),
    );
    copy = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.52, .78, curve: Curves.easeOutCubic),
    );
    pulse = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.5, 1, curve: Curves.easeInOut),
    );
    exit = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.9, 1, curve: Curves.easeInOut),
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) onCompleted();
    });
  }

  final AnimationController _controller;
  late final Animation<double> background;
  late final Animation<double> logo;
  late final Animation<double> symbols;
  late final Animation<double> copy;
  late final Animation<double> pulse;
  late final Animation<double> exit;

  void start() => _controller.forward();
  void dispose() => _controller.dispose();
}
