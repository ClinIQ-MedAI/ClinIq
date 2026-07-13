import 'package:cliniq/features/ai/data/models/input_gate_model.dart';
import 'package:cliniq/features/ai/data/models/probability_model.dart';
import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';
import 'package:cliniq/features/ai/domain/entities/probability_entity.dart';
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
    super.severity,
    super.clinicalMeaning,
    super.bodyPart,
    super.patientContext,
    super.findingsList,
    super.allProbabilities,
    super.scanBase64,
    super.scanUrl,
    super.aiJobStatus,
    super.modality,
    super.createdAt,
    super.patientName,
    super.patientId,
  });

  factory AIAnalysisSuccessModel.fromJson(Map<String, dynamic> json) {
    final findings = json['ai_findings'] as Map<String, dynamic>? ?? {};
    final rawProbabilities = json['all_probabilities'] as List<dynamic>? ??
        json['allProbabilities'] as List<dynamic>? ??
        [];
    final rawFindings = json['findings_list'] as List<dynamic>? ??
        json['findingsList'] as List<dynamic>? ??
        json['findings'] as List<dynamic>? ??
        [];

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
      severity: findings['severity'] as String? ?? '',
      clinicalMeaning: findings['clinical_meaning'] as String? ??
          json['clinical_meaning'] as String? ??
          '',
      bodyPart: json['body_part'] as String? ??
          json['bodyPart'] as String? ??
          '',
      patientContext: json['patient_context'] as String? ??
          json['patientContext'] as String? ??
          '',
      findingsList: rawFindings.map((e) => e.toString()).toList(),
      allProbabilities: rawProbabilities
          .map(
            (e) => ProbabilityModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      scanBase64: json['scanBase64'] as String? ??
          json['scan_base64'] as String? ??
          '',
      scanUrl: json['scanUrl'] as String? ??
          json['scan_url'] as String? ??
          '',
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

  factory AIAnalysisSuccessModel.fromEntity(AIAnalysisSuccessEntity entity) {
    return AIAnalysisSuccessModel(
      inputGate: entity.inputGate,
      annotatedImageBase64: entity.annotatedImageBase64,
      urgency: entity.urgency,
      summary: entity.summary,
      recommendations: entity.recommendations,
      primaryDiagnosis: entity.primaryDiagnosis,
      confidence: entity.confidence,
      severity: entity.severity,
      clinicalMeaning: entity.clinicalMeaning,
      bodyPart: entity.bodyPart,
      patientContext: entity.patientContext,
      findingsList: entity.findingsList,
      allProbabilities: entity.allProbabilities,
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
      'input_gate': _inputGateToJson(inputGate),
      'annotated_image_base64': annotatedImageBase64,
      'urgency': urgency,
      'summary': summary,
      'recommendations': recommendations,
      'ai_findings': {
        'primary_diagnosis': primaryDiagnosis,
        'confidence': confidence,
        'severity': severity,
        'clinical_meaning': clinicalMeaning,
      },
      'body_part': bodyPart,
      'patient_context': patientContext,
      'findings_list': findingsList,
      'all_probabilities': allProbabilities
          .map(
            (p) =>
                ProbabilityModel(label: p.label, value: p.value).toJson(),
          )
          .toList(),
      'scanBase64': scanBase64,
      'scanUrl': scanUrl,
      'aiJobStatus': aiJobStatus,
      'modality': modality,
      'createdAt': createdAt,
      'patient_name': patientName,
      'patient_id': patientId,
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
    String? severity,
    String? clinicalMeaning,
    String? bodyPart,
    String? patientContext,
    List<String>? findingsList,
    List<ProbabilityEntity>? allProbabilities,
    String? scanBase64,
    String? scanUrl,
    String? aiJobStatus,
    String? modality,
    String? createdAt,
    String? patientName,
    String? patientId,
  }) {
    return AIAnalysisSuccessModel(
      inputGate: inputGate ?? this.inputGate,
      annotatedImageBase64: annotatedImageBase64 ?? this.annotatedImageBase64,
      urgency: urgency ?? this.urgency,
      summary: summary ?? this.summary,
      recommendations: recommendations ?? this.recommendations,
      primaryDiagnosis: primaryDiagnosis ?? this.primaryDiagnosis,
      confidence: confidence ?? this.confidence,
      severity: severity ?? this.severity,
      clinicalMeaning: clinicalMeaning ?? this.clinicalMeaning,
      bodyPart: bodyPart ?? this.bodyPart,
      patientContext: patientContext ?? this.patientContext,
      findingsList: findingsList ?? this.findingsList,
      allProbabilities: allProbabilities ?? this.allProbabilities,
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
