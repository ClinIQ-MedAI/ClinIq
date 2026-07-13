import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';

class InputGateModel extends InputGateEntity {
  const InputGateModel({
    required super.passed,
    super.reason,
    super.action,
    super.width,
    super.height,
    super.aspectRatio,
    super.intensityStd,
    super.colorSpread,
    super.colorfulFraction,
  });

  static bool _truthyPassed(Object? raw) {
    if (raw == null) return true;
    if (raw is bool) return raw;
    if (raw is num) return raw == 1;
    if (raw is String) return raw.toLowerCase() == 'true';
    return false;
  }

  factory InputGateModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const InputGateModel(passed: true);
    }
    return InputGateModel(
      passed: _truthyPassed(json['passed']),
      reason: json['reason'] as String? ?? '',
      action: json['action'] as String? ?? '',
      width: (json['width'] as num? ?? 0).toDouble(),
      height: (json['height'] as num? ?? 0).toDouble(),
      aspectRatio: (json['aspect_ratio'] as num? ?? json['aspectRatio'] as num? ?? 0).toDouble(),
      intensityStd:
          (json['intensity_std'] as num? ?? json['intensityStd'] as num? ?? 0).toDouble(),
      colorSpread:
          (json['color_spread'] as num? ?? json['colorSpread'] as num? ?? 0).toDouble(),
      colorfulFraction:
          (json['colorful_fraction'] as num? ?? json['colorfulFraction'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'passed': passed,
        if (reason.isNotEmpty) 'reason': reason,
        if (action.isNotEmpty) 'action': action,
        'width': width,
        'height': height,
        'aspectRatio': aspectRatio,
        'intensityStd': intensityStd,
        'colorSpread': colorSpread,
        'colorfulFraction': colorfulFraction,
      };

  InputGateEntity copyWith({
    bool? passed,
    String? reason,
    String? action,
    double? width,
    double? height,
    double? aspectRatio,
    double? intensityStd,
    double? colorSpread,
    double? colorfulFraction,
  }) {
    return InputGateEntity(
      passed: passed ?? this.passed,
      reason: reason ?? this.reason,
      action: action ?? this.action,
      width: width ?? this.width,
      height: height ?? this.height,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      intensityStd: intensityStd ?? this.intensityStd,
      colorSpread: colorSpread ?? this.colorSpread,
      colorfulFraction: colorfulFraction ?? this.colorfulFraction,
    );
  }
}
