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

    // Image-quality metrics live inside `scores` in the backend payload,
    // but tolerate a flat shape too for backwards compatibility.
    final scoresRaw = json['scores'];
    final scores = scoresRaw is Map
        ? Map<String, dynamic>.from(scoresRaw)
        : <String, dynamic>{};

    num? metric(String snake, String camel) =>
        scores[snake] as num? ??
        scores[camel] as num? ??
        json[snake] as num? ??
        json[camel] as num?;

    return InputGateModel(
      passed: _truthyPassed(json['passed']),
      reason: json['reason'] as String? ?? '',
      action: json['action'] as String? ?? '',
      width: (metric('width', 'width') ?? 0).toDouble(),
      height: (metric('height', 'height') ?? 0).toDouble(),
      aspectRatio: (metric('aspect_ratio', 'aspectRatio') ?? 0).toDouble(),
      intensityStd: (metric('intensity_std', 'intensityStd') ?? 0).toDouble(),
      colorSpread: (metric('color_spread', 'colorSpread') ?? 0).toDouble(),
      colorfulFraction:
          (metric('colorful_fraction', 'colorfulFraction') ?? 0).toDouble(),
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
