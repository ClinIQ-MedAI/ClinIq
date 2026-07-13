class InputGateEntity {
  final bool passed;
  final String reason;
  final String action;
  final double width;
  final double height;
  final double aspectRatio;
  final double intensityStd;
  final double colorSpread;
  final double colorfulFraction;

  const InputGateEntity({
    required this.passed,
    this.reason = '',
    this.action = '',
    this.width = 0,
    this.height = 0,
    this.aspectRatio = 0,
    this.intensityStd = 0,
    this.colorSpread = 0,
    this.colorfulFraction = 0,
  });
}
