import 'package:cliniq/features/ai/domain/entities/probability_entity.dart';

class ProbabilityModel extends ProbabilityEntity {
  const ProbabilityModel({
    required super.label,
    required super.value,
  });

  factory ProbabilityModel.fromJson(Map<String, dynamic> json) {
    return ProbabilityModel(
      label: (json['label'] as String? ?? json['name'] as String? ?? ''),
      value: (json['value'] as num? ?? json['probability'] as num? ?? 0)
          .toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };

  ProbabilityEntity copyWith({String? label, double? value}) {
    return ProbabilityEntity(
      label: label ?? this.label,
      value: value ?? this.value,
    );
  }
}
