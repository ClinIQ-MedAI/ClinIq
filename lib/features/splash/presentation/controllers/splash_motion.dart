import 'package:flutter/material.dart';

class SplashMotion {
  SplashMotion({
    required TickerProvider vsync,
    required VoidCallback onCompleted,
  }) : _controller = AnimationController(
         vsync: vsync,
         duration: const Duration(milliseconds: 3000),
       ) {
    logo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.12, .32, curve: Curves.easeOutCubic),
    );
    title = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.28, .48, curve: Curves.easeOutCubic),
    );
    tagline = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.40, .60, curve: Curves.easeOutCubic),
    );
    ecg = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.52, .60, curve: Curves.easeOut),
    );
    progress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.60, .68, curve: Curves.easeOut),
    );
    exit = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.90, 1.0, curve: Curves.easeOut),
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) onCompleted();
    });
  }

  final AnimationController _controller;
  late final Animation<double> logo;
  late final Animation<double> title;
  late final Animation<double> tagline;
  late final Animation<double> ecg;
  late final Animation<double> progress;
  late final Animation<double> exit;

  void start() => _controller.forward();
  void dispose() => _controller.dispose();
}
