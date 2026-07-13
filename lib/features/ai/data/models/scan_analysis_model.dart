import 'dart:developer';

import 'package:cliniq/features/ai/data/models/input_gate_model.dart';
import 'package:cliniq/features/ai/data/models/probability_model.dart';
import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';
import 'package:cliniq/features/ai/domain/entities/probability_entity.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

class ScanAnalysisModel extends ScanAnalysisEntity {
  const ScanAnalysisModel({
    required super.id,
    super.findings,
    super.modality,
    super.status,
    super.createdAt,
    super.imageUrl,
    super.patientId,
    super.urgency,
    super.summary,
    super.recommendations,
    super.scanBase64,
    super.scanUrl,
    super.annotatedImageBase64,
    super.primaryDiagnosis,
    super.confidence,
    super.severity,
    super.patientContext,
    super.bodyPart,
    super.clinicalMeaning,
    super.allProbabilities,
    super.findingsList,
    super.inputGate,
    super.aiJobId,
  });

  factory ScanAnalysisModel.fromJson(Map<String, dynamic> json) {
    final candidateFields = [
      'findings', 'report', 'analysis', 'result', 'aiReply',
      'reply', 'summary', 'content', 'text', 'conclusion', 'description',
    ];
    final analysisText = () {
      for (final field in candidateFields) {
        final val = json[field];
        if (val is String && val.isNotEmpty) {
          log('ScanAnalysisModel: matched field "$field" with value length ${val.length}');
          return val;
        }
      }
      for (final field in candidateFields) {
        final val = json[field];
        if (val != null) {
          log('ScanAnalysisModel: matched non-string field "$field" = $val (${val.runtimeType})');
          return val.toString();
        }
      }
      log('ScanAnalysisModel: NO analysis field found in keys: ${json.keys}');
      return '';
    }();

    final probabilities = (json['all_probabilities'] as List<dynamic>?)
            ?.map((e) => ProbabilityModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        (json['allProbabilities'] as List<dynamic>?)
            ?.map((e) => ProbabilityModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <ProbabilityModel>[];

    final findingsList = (json['findings_list'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        (json['findingsList'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    return ScanAnalysisModel(
      id: json['id']?.toString() ?? '',
      findings: analysisText,
      modality: json['modality'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String? ?? '',
      patientId:
          json['patientId']?.toString() ?? json['patient_id']?.toString() ?? '',
      urgency: json['urgency'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      scanBase64: json['scanBase64'] as String? ?? json['scan_base64'] as String? ?? '',
      scanUrl: json['scanUrl'] as String? ?? json['scan_url'] as String? ?? '',
      annotatedImageBase64: json['annotated_image_base64'] as String? ??
          json['annotatedImageBase64'] as String? ??
          '',
      primaryDiagnosis: json['primary_diagnosis'] as String? ??
          json['primaryDiagnosis'] as String? ??
          json['diagnosis'] as String? ??
          '',
      confidence: (json['confidence'] as num? ?? 0).toDouble(),
      severity: json['severity'] as String? ?? '',
      patientContext: json['patient_context'] as String? ??
          json['patientContext'] as String? ??
          '',
      bodyPart: json['body_part'] as String? ?? json['bodyPart'] as String? ?? '',
      clinicalMeaning: json['clinical_meaning'] as String? ??
          json['clinicalMeaning'] as String? ??
          '',
      allProbabilities: probabilities,
      findingsList: findingsList,
      inputGate: InputGateModel.fromJson(
        json['input_gate'] as Map<String, dynamic>? ??
            json['inputGate'] as Map<String, dynamic>?,
      ),
      aiJobId: json['ai_job_id'] as String? ??
          json['aiJobId'] as String? ??
          json['jobId'] as String? ??
          '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (findings.isNotEmpty) 'findings': findings,
        if (modality.isNotEmpty) 'modality': modality,
        if (status.isNotEmpty) 'status': status,
        if (createdAt.isNotEmpty) 'createdAt': createdAt,
        if (imageUrl.isNotEmpty) 'imageUrl': imageUrl,
        if (patientId.isNotEmpty) 'patientId': patientId,
        if (urgency.isNotEmpty) 'urgency': urgency,
        if (summary.isNotEmpty) 'summary': summary,
        if (recommendations.isNotEmpty) 'recommendations': recommendations,
        if (scanBase64.isNotEmpty) 'scanBase64': scanBase64,
        if (scanUrl.isNotEmpty) 'scanUrl': scanUrl,
        if (annotatedImageBase64.isNotEmpty)
          'annotatedImageBase64': annotatedImageBase64,
        if (primaryDiagnosis.isNotEmpty)
          'primaryDiagnosis': primaryDiagnosis,
        if (confidence > 0) 'confidence': confidence,
        if (severity.isNotEmpty) 'severity': severity,
        if (patientContext.isNotEmpty) 'patientContext': patientContext,
        if (bodyPart.isNotEmpty) 'bodyPart': bodyPart,
        if (clinicalMeaning.isNotEmpty) 'clinicalMeaning': clinicalMeaning,
        if (allProbabilities.isNotEmpty)
          'allProbabilities': allProbabilities
              .map((p) => (p as ProbabilityModel).toJson())
              .toList(),
        if (findingsList.isNotEmpty) 'findingsList': findingsList,
        'inputGate': (inputGate as InputGateModel).toJson(),
        if (aiJobId.isNotEmpty) 'aiJobId': aiJobId,
      };

  ScanAnalysisEntity copyWith({
    String? id,
    String? findings,
    String? modality,
    String? status,
    String? createdAt,
    String? imageUrl,
    String? patientId,
    String? urgency,
    String? summary,
    List<String>? recommendations,
    String? scanBase64,
    String? scanUrl,
    String? annotatedImageBase64,
    String? primaryDiagnosis,
    double? confidence,
    String? severity,
    String? patientContext,
    String? bodyPart,
    String? clinicalMeaning,
    List<ProbabilityEntity>? allProbabilities,
    List<String>? findingsList,
    InputGateEntity? inputGate,
    String? aiJobId,
  }) {
    return ScanAnalysisEntity(
      id: id ?? this.id,
      findings: findings ?? this.findings,
      modality: modality ?? this.modality,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      patientId: patientId ?? this.patientId,
      urgency: urgency ?? this.urgency,
      summary: summary ?? this.summary,
      recommendations: recommendations ?? this.recommendations,
      scanBase64: scanBase64 ?? this.scanBase64,
      scanUrl: scanUrl ?? this.scanUrl,
      annotatedImageBase64:
          annotatedImageBase64 ?? this.annotatedImageBase64,
      primaryDiagnosis: primaryDiagnosis ?? this.primaryDiagnosis,
      confidence: confidence ?? this.confidence,
      severity: severity ?? this.severity,
      patientContext: patientContext ?? this.patientContext,
      bodyPart: bodyPart ?? this.bodyPart,
      clinicalMeaning: clinicalMeaning ?? this.clinicalMeaning,
      allProbabilities: allProbabilities ?? this.allProbabilities,
      findingsList: findingsList ?? this.findingsList,
      inputGate: inputGate ?? this.inputGate,
      aiJobId: aiJobId ?? this.aiJobId,
    );
  }
}
