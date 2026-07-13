import 'package:cliniq/features/ai/data/models/input_gate_model.dart';
import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

class AIAnalysisRejectedModel extends AIAnalysisRejectedEntity {
  const AIAnalysisRejectedModel({
    required super.inputRejected,
    required super.inputGate,
    required super.urgency,
    required super.summary,
    required super.recommendations,
  });

  factory AIAnalysisRejectedModel.fromJson(Map<String, dynamic> json) {
    return AIAnalysisRejectedModel(
      inputRejected: json['input_rejected'] as bool? ?? true,
      inputGate: InputGateModel.fromJson(
        json['input_gate'] as Map<String, dynamic>?,
      ),
      urgency: json['urgency'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      recommendations: (json['recommendations'] as List<dynamic>? ?? [])
          .map((recommendation) => recommendation.toString())
          .toList(),
    );
  }

  factory AIAnalysisRejectedModel.fromEntity(AIAnalysisRejectedEntity entity) {
    return AIAnalysisRejectedModel(
      inputRejected: entity.inputRejected,
      inputGate: entity.inputGate,
      urgency: entity.urgency,
      summary: entity.summary,
      recommendations: entity.recommendations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'input_rejected': inputRejected,
      'input_gate': _inputGateToJson(inputGate),
      'urgency': urgency,
      'summary': summary,
      'recommendations': recommendations,
    };
  }

  AIAnalysisRejectedModel copyWith({
    bool? inputRejected,
    InputGateEntity? inputGate,
    String? urgency,
    String? summary,
    List<String>? recommendations,
  }) {
    return AIAnalysisRejectedModel(
      inputRejected: inputRejected ?? this.inputRejected,
      inputGate: inputGate ?? this.inputGate,
      urgency: urgency ?? this.urgency,
      summary: summary ?? this.summary,
      recommendations: recommendations ?? this.recommendations,
    );
  }

  Map<String, dynamic> _inputGateToJson(InputGateEntity inputGate) {
    return InputGateModel(
      passed: inputGate.passed,
      reason: inputGate.reason,
      action: inputGate.action,
      width: inputGate.width,
      height: inputGate.height,
      aspectRatio: inputGate.aspectRatio,
      intensityStd: inputGate.intensityStd,
      colorSpread: inputGate.colorSpread,
      colorfulFraction: inputGate.colorfulFraction,
    ).toJson();
  }
}
