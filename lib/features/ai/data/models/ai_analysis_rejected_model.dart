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
    super.scanBase64,
    super.scanUrl,
    super.aiJobStatus,
    super.modality,
    super.createdAt,
    super.patientName,
    super.patientId,
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
      scanBase64: json['scanBase64'] as String? ?? '',
      scanUrl: json['scanUrl'] as String? ?? '',
      aiJobStatus: json['aiJobStatus'] as String? ??
          json['ai_job_status'] as String? ??
          '',
      modality: json['modality'] as String? ?? '',
      createdAt: json['createdAt'] as String? ??
          json['created_at'] as String? ??
          '',
      patientName: json['patient_name'] as String? ??
          json['patientName'] as String? ??
          '',
      patientId: json['patient_id'] as String? ??
          json['patientId'] as String? ??
          '',
    );
  }

  factory AIAnalysisRejectedModel.fromEntity(AIAnalysisRejectedEntity entity) {
    return AIAnalysisRejectedModel(
      inputRejected: entity.inputRejected,
      inputGate: entity.inputGate,
      urgency: entity.urgency,
      summary: entity.summary,
      recommendations: entity.recommendations,
      scanBase64: entity.scanBase64,
      scanUrl: entity.scanUrl,
      aiJobStatus: entity.aiJobStatus,
      modality: entity.modality,
      createdAt: entity.createdAt,
      patientName: entity.patientName,
      patientId: entity.patientId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'input_rejected': inputRejected,
      'input_gate': _inputGateToJson(inputGate),
      'urgency': urgency,
      'summary': summary,
      'recommendations': recommendations,
      'scanBase64': scanBase64,
      'scanUrl': scanUrl,
      'ai_job_status': aiJobStatus,
      'modality': modality,
      'createdAt': createdAt,
      'patient_name': patientName,
      'patient_id': patientId,
    };
  }

  AIAnalysisRejectedModel copyWith({
    bool? inputRejected,
    InputGateEntity? inputGate,
    String? urgency,
    String? summary,
    List<String>? recommendations,
    String? scanBase64,
    String? scanUrl,
    String? aiJobStatus,
    String? modality,
    String? createdAt,
    String? patientName,
    String? patientId,
  }) {
    return AIAnalysisRejectedModel(
      inputRejected: inputRejected ?? this.inputRejected,
      inputGate: inputGate ?? this.inputGate,
      urgency: urgency ?? this.urgency,
      summary: summary ?? this.summary,
      recommendations: recommendations ?? this.recommendations,
      scanBase64: scanBase64 ?? this.scanBase64,
      scanUrl: scanUrl ?? this.scanUrl,
      aiJobStatus: aiJobStatus ?? this.aiJobStatus,
      modality: modality ?? this.modality,
      createdAt: createdAt ?? this.createdAt,
      patientName: patientName ?? this.patientName,
      patientId: patientId ?? this.patientId,
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
