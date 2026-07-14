import 'dart:convert';

import 'package:cliniq/features/ai/data/models/input_gate_model.dart';
import 'package:cliniq/features/ai/data/models/probability_model.dart';
import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';
import 'package:cliniq/features/ai/domain/entities/probability_entity.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

class AIAnalysisSuccessModel extends AIAnalysisSuccessEntity {
  const AIAnalysisSuccessModel({
    required super.inputGate,
    required super.annotatedImageBase64,
    required super.primaryDiagnosis,
    required super.confidence,
    super.urgency,
    super.summary,
    super.recommendations,
    super.severity,
    super.clinicalMeaning,
    super.bodyPart,
    super.patientContext,
    super.timestamp,
    super.findingsList,
    super.differentialDiagnoses,
    super.allProbabilities,
    super.detections,
    super.id,
    super.modality,
    super.scanUrl,
    super.scanBase64,
    super.aiJobId,
    super.aiJobStatus,
    super.patientName,
    super.patientId,
    super.createdAt,
    super.doctorId,
    super.doctorName,
    super.doctorNotes,
    super.doctorReviewDate,
    super.isReviewed,
  });

  /// Parses the ORIGINAL (top-level) success response. Top-level fields are
  /// read directly, analysis fields live inside `aiAnalysisResult`, and the
  /// diagnosis fields inside `aiAnalysisResult.ai_findings`.
  factory AIAnalysisSuccessModel.fromJson(Map<String, dynamic> json) {
    // Analysis fields live inside `aiAnalysisResult` when wrapped, or at the
    // top level when the backend returns a flat response.
    final result = _asNullableMap(json['aiAnalysisResult']) ?? json;
    final findings = _asMap(result['ai_findings']);
    final rawDetections = result['detections'] as List<dynamic>? ?? [];
    final rawFindings = result['findings'] as List<dynamic>? ?? [];
    final rawDifferential =
        result['differential_diagnoses'] as List<dynamic>? ?? [];

    return AIAnalysisSuccessModel(
      // Top level.
      id: (json['id'] as num? ?? 0).toInt(),
      modality: json['modality'] as String? ?? '',
      scanUrl: json['scanUrl'] as String? ?? '',
      scanBase64: json['scanBase64'] as String? ?? '',
      aiJobId: json['aiJobId'] as String? ?? '',
      aiJobStatus: json['aiJobStatus'] as String? ?? '',
      patientName: json['patientName'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      doctorId: json['doctorId']?.toString() ?? '',
      doctorName: json['doctorName'] as String? ?? '',
      doctorNotes: json['doctorNotes'] as String? ?? '',
      doctorReviewDate: json['doctorReviewDate'] as String? ?? '',
      isReviewed: json['isReviewed'] == true,
      // aiAnalysisResult.
      inputGate: InputGateModel.fromJson(_asNullableMap(result['input_gate'])),
      annotatedImageBase64: result['annotated_image_base64'] as String? ?? '',
      urgency: result['urgency'] as String? ?? '',
      summary: result['summary'] as String? ?? '',
      recommendations: (result['recommendations'] as List<dynamic>? ?? [])
          .map((recommendation) => recommendation.toString())
          .toList(),
      bodyPart: result['body_part'] as String? ?? '',
      patientContext: result['patient_context'] as String? ?? '',
      timestamp: result['timestamp'] as String? ?? '',
      findingsList: rawFindings.map((e) => e.toString()).toList(),
      differentialDiagnoses:
          rawDifferential.map((e) => e.toString()).toList(),
      allProbabilities: _parseProbabilities(result['all_probabilities']),
      detections: rawDetections
          .whereType<Map>()
          .map((e) => ProbabilityModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      // aiAnalysisResult.ai_findings.
      primaryDiagnosis: findings['primary_diagnosis'] as String? ?? '',
      confidence: findings['confidence']?.toString() ?? '',
      severity: findings['severity'] as String? ?? '',
      clinicalMeaning: findings['clinical_meaning'] as String? ?? '',
    );
  }

  factory AIAnalysisSuccessModel.fromEntity(AIAnalysisSuccessEntity entity) {
    return AIAnalysisSuccessModel(
      inputGate: entity.inputGate,
      annotatedImageBase64: entity.annotatedImageBase64,
      primaryDiagnosis: entity.primaryDiagnosis,
      confidence: entity.confidence,
      urgency: entity.urgency,
      summary: entity.summary,
      recommendations: entity.recommendations,
      severity: entity.severity,
      clinicalMeaning: entity.clinicalMeaning,
      bodyPart: entity.bodyPart,
      patientContext: entity.patientContext,
      timestamp: entity.timestamp,
      findingsList: entity.findingsList,
      differentialDiagnoses: entity.differentialDiagnoses,
      allProbabilities: entity.allProbabilities,
      detections: entity.detections,
      id: entity.id,
      modality: entity.modality,
      scanUrl: entity.scanUrl,
      scanBase64: entity.scanBase64,
      aiJobId: entity.aiJobId,
      aiJobStatus: entity.aiJobStatus,
      patientName: entity.patientName,
      patientId: entity.patientId,
      createdAt: entity.createdAt,
      doctorId: entity.doctorId,
      doctorName: entity.doctorName,
      doctorNotes: entity.doctorNotes,
      doctorReviewDate: entity.doctorReviewDate,
      isReviewed: entity.isReviewed,
    );
  }

  /// Serializes back to the ORIGINAL response shape (top-level fields plus an
  /// `aiAnalysisResult` wrapper) so a round-trip re-parses identically.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modality': modality,
      'scanUrl': scanUrl,
      'scanBase64': scanBase64,
      'aiJobId': aiJobId,
      'aiJobStatus': aiJobStatus,
      'patientName': patientName,
      'patientId': patientId,
      'createdAt': createdAt,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorNotes': doctorNotes,
      'doctorReviewDate': doctorReviewDate,
      'isReviewed': isReviewed,
      'aiAnalysisResult': {
        'input_gate': _inputGateToJson(inputGate),
        'annotated_image_base64': annotatedImageBase64,
        'urgency': urgency,
        'summary': summary,
        'recommendations': recommendations,
        'body_part': bodyPart,
        'patient_context': patientContext,
        'timestamp': timestamp,
        'findings': findingsList,
        'differential_diagnoses': differentialDiagnoses,
        'all_probabilities': {
          for (final p in allProbabilities) p.label: p.value,
        },
        'detections': detections
            .map((d) => ProbabilityModel(label: d.label, value: d.value).toJson())
            .toList(),
        'ai_findings': {
          'primary_diagnosis': primaryDiagnosis,
          'confidence': confidence,
          'severity': severity,
          'clinical_meaning': clinicalMeaning,
        },
      },
    };
  }

  AIAnalysisSuccessModel copyWith({
    InputGateEntity? inputGate,
    String? annotatedImageBase64,
    String? primaryDiagnosis,
    String? confidence,
    String? urgency,
    String? summary,
    List<String>? recommendations,
    String? severity,
    String? clinicalMeaning,
    String? bodyPart,
    String? patientContext,
    String? timestamp,
    List<String>? findingsList,
    List<String>? differentialDiagnoses,
    List<ProbabilityEntity>? allProbabilities,
    List<ProbabilityEntity>? detections,
    int? id,
    String? modality,
    String? scanUrl,
    String? scanBase64,
    String? aiJobId,
    String? aiJobStatus,
    String? patientName,
    String? patientId,
    String? createdAt,
    String? doctorId,
    String? doctorName,
    String? doctorNotes,
    String? doctorReviewDate,
    bool? isReviewed,
  }) {
    return AIAnalysisSuccessModel(
      inputGate: inputGate ?? this.inputGate,
      annotatedImageBase64: annotatedImageBase64 ?? this.annotatedImageBase64,
      primaryDiagnosis: primaryDiagnosis ?? this.primaryDiagnosis,
      confidence: confidence ?? this.confidence,
      urgency: urgency ?? this.urgency,
      summary: summary ?? this.summary,
      recommendations: recommendations ?? this.recommendations,
      severity: severity ?? this.severity,
      clinicalMeaning: clinicalMeaning ?? this.clinicalMeaning,
      bodyPart: bodyPart ?? this.bodyPart,
      patientContext: patientContext ?? this.patientContext,
      timestamp: timestamp ?? this.timestamp,
      findingsList: findingsList ?? this.findingsList,
      differentialDiagnoses:
          differentialDiagnoses ?? this.differentialDiagnoses,
      allProbabilities: allProbabilities ?? this.allProbabilities,
      detections: detections ?? this.detections,
      id: id ?? this.id,
      modality: modality ?? this.modality,
      scanUrl: scanUrl ?? this.scanUrl,
      scanBase64: scanBase64 ?? this.scanBase64,
      aiJobId: aiJobId ?? this.aiJobId,
      aiJobStatus: aiJobStatus ?? this.aiJobStatus,
      patientName: patientName ?? this.patientName,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      doctorReviewDate: doctorReviewDate ?? this.doctorReviewDate,
      isReviewed: isReviewed ?? this.isReviewed,
    );
  }

  static Map<String, dynamic> _asMap(Object? value) =>
      _asNullableMap(value) ?? <String, dynamic>{};

  /// Tolerates a real map (any key type) or a JSON-encoded string, so a
  /// double-encoded `aiAnalysisResult` (or nested object) is still parsed.
  static Map<String, dynamic>? _asNullableMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {
        return null;
      }
    }
    return null;
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

  /// `all_probabilities` is usually a `{ label: value }` object, but tolerate a
  /// list of `{ label, value }` too. Values above 1 are treated as percentages
  /// and normalized into the 0..1 range for the UI bars.
  static List<ProbabilityEntity> _parseProbabilities(Object? raw) {
    double normalize(num value) {
      final v = value.toDouble();
      return v > 1 ? v / 100 : v;
    }

    if (raw is Map) {
      return raw.entries
          .where((e) => e.value is num)
          .map(
            (e) => ProbabilityModel(
              label: e.key.toString(),
              value: normalize(e.value as num),
            ),
          )
          .toList();
    }
    if (raw is List) {
      return raw.whereType<Map>().map((e) {
        final model = ProbabilityModel.fromJson(Map<String, dynamic>.from(e));
        return ProbabilityModel(
          label: model.label,
          value: normalize(model.value),
        );
      }).toList();
    }
    return const [];
  }
}
