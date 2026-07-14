import 'dart:convert';

import 'package:cliniq/features/ai/data/models/input_gate_model.dart';
import 'package:cliniq/features/ai/data/models/medication_model.dart';
import 'package:cliniq/features/ai/data/models/probability_model.dart';
import 'package:cliniq/features/ai/domain/entities/medication_entity.dart';
import 'package:cliniq/features/ai/domain/entities/probability_entity.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

class PrescriptionAnalysisModel extends PrescriptionAnalysisEntity {
  const PrescriptionAnalysisModel({
    required super.inputGate,
    super.id,
    super.scanUrl,
    super.scanBase64,
    super.aiJobId,
    super.aiJobStatus,
    super.doctorId,
    super.doctorName,
    super.doctorNotes,
    super.doctorReviewDate,
    super.isReviewed,
    super.success,
    super.imageType,
    super.detections,
    super.primaryDiagnosis,
    super.rawVlmOutput,
    super.rawMedications,
    required super.totalMedications,
    required super.verifiedMedications,
    required super.medications,
    required super.aiFindingsNotes,
    super.modality,
    super.createdAt,
    super.patientName,
    super.patientId,
  });

  /// Parses the ORIGINAL (top-level) prescription response. Top-level fields
  /// are read directly, while analysis fields live inside `aiAnalysisResult`.
  factory PrescriptionAnalysisModel.fromJson(Map<String, dynamic> json) {
    // Analysis fields live inside `aiAnalysisResult` when wrapped, or at the
    // top level when the backend returns a flat response.
    final result = _asNullableMap(json['aiAnalysisResult']) ?? json;
    final aiFindings = _asMap(result['ai_findings']);
    final reportData = _asMap(result['report_data']);

    final medications = _parseMedications(reportData['medications']);
    final rawMedications = _parseRawMedications(
      aiFindings['medications'],
      aiFindings['raw_vlm_output'],
    );

    return PrescriptionAnalysisModel(
      id: (json['id'] as num? ?? 0).toInt(),
      patientId: json['patientId'] as String? ?? json['patient_id'] as String? ?? '',
      patientName:
          json['patientName'] as String? ?? json['patient_name'] as String? ?? '',
      modality: json['modality'] as String? ?? '',
      scanUrl: json['scanUrl'] as String? ?? json['scan_url'] as String? ?? '',
      scanBase64:
          json['scanBase64'] as String? ?? json['scan_base64'] as String? ?? '',
      aiJobId: json['aiJobId'] as String? ?? json['ai_job_id'] as String? ?? '',
      aiJobStatus:
          json['aiJobStatus'] as String? ?? json['ai_job_status'] as String? ?? '',
      doctorId: json['doctorId']?.toString() ?? json['doctor_id']?.toString() ?? '',
      doctorName:
          json['doctorName'] as String? ?? json['doctor_name'] as String? ?? '',
      doctorNotes:
          json['doctorNotes'] as String? ?? json['doctor_notes'] as String? ?? '',
      doctorReviewDate: json['doctorReviewDate'] as String? ??
          json['doctor_review_date'] as String? ??
          '',
      isReviewed:
          json['isReviewed'] == true || json['is_reviewed'] == true,
      createdAt:
          json['createdAt'] as String? ?? json['created_at'] as String? ?? '',
      success: result['success'] == true,
      imageType: result['image_type'] as String? ?? '',
      detections: _parseDetections(result['detections']),
      inputGate: InputGateModel.fromJson(_asNullableMap(result['input_gate'])),
      primaryDiagnosis: aiFindings['primary_diagnosis'] as String? ?? '',
      aiFindingsNotes: aiFindings['notes'] as String? ?? '',
      rawVlmOutput: aiFindings['raw_vlm_output'] as String? ?? '',
      rawMedications: rawMedications,
      totalMedications: (reportData['total_medications'] as num? ?? 0).toInt(),
      verifiedMedications:
          (reportData['verified_medications'] as num? ?? 0).toInt(),
      medications: medications,
    );
  }

  factory PrescriptionAnalysisModel.fromEntity(
    PrescriptionAnalysisEntity entity,
  ) {
    return PrescriptionAnalysisModel(
      inputGate: entity.inputGate,
      id: entity.id,
      scanUrl: entity.scanUrl,
      scanBase64: entity.scanBase64,
      aiJobId: entity.aiJobId,
      aiJobStatus: entity.aiJobStatus,
      doctorId: entity.doctorId,
      doctorName: entity.doctorName,
      doctorNotes: entity.doctorNotes,
      doctorReviewDate: entity.doctorReviewDate,
      isReviewed: entity.isReviewed,
      success: entity.success,
      imageType: entity.imageType,
      detections: entity.detections,
      primaryDiagnosis: entity.primaryDiagnosis,
      rawVlmOutput: entity.rawVlmOutput,
      rawMedications: entity.rawMedications,
      totalMedications: entity.totalMedications,
      verifiedMedications: entity.verifiedMedications,
      medications: entity.medications,
      aiFindingsNotes: entity.aiFindingsNotes,
      modality: entity.modality,
      createdAt: entity.createdAt,
      patientName: entity.patientName,
      patientId: entity.patientId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'modality': modality,
      'scanUrl': scanUrl,
      'scanBase64': scanBase64,
      'aiJobId': aiJobId,
      'aiJobStatus': aiJobStatus,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorNotes': doctorNotes,
      'doctorReviewDate': doctorReviewDate,
      'isReviewed': isReviewed,
      'createdAt': createdAt,
      'aiAnalysisResult': {
        'success': success,
        'image_type': imageType,
        'detections': detections
            .map((d) => ProbabilityModel(label: d.label, value: d.value).toJson())
            .toList(),
        'input_gate': InputGateModel(
          passed: inputGate.passed,
          reason: inputGate.reason,
          action: inputGate.action,
          width: inputGate.width,
          height: inputGate.height,
          aspectRatio: inputGate.aspectRatio,
          intensityStd: inputGate.intensityStd,
          colorSpread: inputGate.colorSpread,
          colorfulFraction: inputGate.colorfulFraction,
        ).toJson(),
        'ai_findings': {
          'primary_diagnosis': primaryDiagnosis,
          'notes': aiFindingsNotes,
          'raw_vlm_output': rawVlmOutput,
          'medications':
              rawMedications.map((m) => MedicationModel.fromEntity(m).toJson()).toList(),
        },
        'report_data': {
          'total_medications': totalMedications,
          'verified_medications': verifiedMedications,
          'medications':
              medications.map((m) => MedicationModel.fromEntity(m).toJson()).toList(),
        },
      },
      '__typename': 'PrescriptionAnalysis',
    };
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

  static List<MedicationEntity> _parseMedications(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => MedicationModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Builds the raw VLM medication list from the structured array when present,
  /// otherwise decodes the [rawVlmOutput] JSON string so the UI never renders
  /// raw JSON text.
  static List<MedicationEntity> _parseRawMedications(
    Object? structured,
    Object? rawVlmOutput,
  ) {
    if (structured is List && structured.isNotEmpty) {
      return _parseMedications(structured);
    }
    if (rawVlmOutput is String && rawVlmOutput.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(rawVlmOutput);
        if (decoded is List) return _parseMedications(decoded);
        if (decoded is Map && decoded['medications'] is List) {
          return _parseMedications(decoded['medications']);
        }
      } catch (_) {
        return const [];
      }
    }
    return const [];
  }

  static List<ProbabilityEntity> _parseDetections(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => ProbabilityModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
