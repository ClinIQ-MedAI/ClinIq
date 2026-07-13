import 'package:cliniq/features/ai/data/models/input_gate_model.dart';
import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

class AIAnalysisSuccessModel extends AIAnalysisSuccessEntity {
  const AIAnalysisSuccessModel({
    required super.inputGate,
    required super.annotatedImageBase64,
    required super.urgency,
    required super.summary,
    required super.recommendations,
    required super.primaryDiagnosis,
    required super.confidence,
  });

  factory AIAnalysisSuccessModel.fromJson(Map<String, dynamic> json) {
    final findings = json['ai_findings'] as Map<String, dynamic>? ?? {};

    return AIAnalysisSuccessModel(
      inputGate: InputGateModel.fromJson(
        json['input_gate'] as Map<String, dynamic>?,
      ),
      annotatedImageBase64: json['annotated_image_base64'] as String? ?? '',
      urgency: json['urgency'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      recommendations: (json['recommendations'] as List<dynamic>? ?? [])
          .map((recommendation) => recommendation.toString())
          .toList(),
      primaryDiagnosis:
          findings['primary_diagnosis'] as String? ??
          json['primary_diagnosis'] as String? ??
          '',
      confidence:
          findings['confidence']?.toString() ??
          json['confidence']?.toString() ??
          '',
    );
  }

  factory AIAnalysisSuccessModel.fromEntity(AIAnalysisSuccessEntity entity) {
    return AIAnalysisSuccessModel(
      inputGate: entity.inputGate,
      annotatedImageBase64: entity.annotatedImageBase64,
      urgency: entity.urgency,
      summary: entity.summary,
      recommendations: entity.recommendations,
      primaryDiagnosis: entity.primaryDiagnosis,
      confidence: entity.confidence,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'input_gate': _inputGateToJson(inputGate),
      'annotated_image_base64': annotatedImageBase64,
      'urgency': urgency,
      'summary': summary,
      'recommendations': recommendations,
      'ai_findings': {
        'primary_diagnosis': primaryDiagnosis,
        'confidence': confidence,
      },
    };
  }

  AIAnalysisSuccessModel copyWith({
    InputGateEntity? inputGate,
    String? annotatedImageBase64,
    String? urgency,
    String? summary,
    List<String>? recommendations,
    String? primaryDiagnosis,
    String? confidence,
  }) {
    return AIAnalysisSuccessModel(
      inputGate: inputGate ?? this.inputGate,
      annotatedImageBase64: annotatedImageBase64 ?? this.annotatedImageBase64,
      urgency: urgency ?? this.urgency,
      summary: summary ?? this.summary,
      recommendations: recommendations ?? this.recommendations,
      primaryDiagnosis: primaryDiagnosis ?? this.primaryDiagnosis,
      confidence: confidence ?? this.confidence,
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
