import 'dart:convert';

import 'package:cliniq/features/ai/data/models/input_gate_model.dart';
import 'package:cliniq/features/ai/data/models/probability_model.dart';
import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';
import 'package:cliniq/features/ai/domain/entities/probability_entity.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

class AIAnalysisRejectedModel extends AIAnalysisRejectedEntity {
  const AIAnalysisRejectedModel({
    required super.inputGate,
    super.inputRejected,
    super.urgency,
    super.summary,
    super.recommendations,
    super.detections,
    super.modality,
    super.scanUrl,
    super.scanBase64,
    super.aiJobStatus,
    super.patientName,
    super.patientId,
    super.createdAt,
  });

  /// Parses the ORIGINAL (top-level) rejected response. Top-level fields are
  /// read directly, while analysis fields live inside `aiAnalysisResult`.
  factory AIAnalysisRejectedModel.fromJson(Map<String, dynamic> json) {
    // Analysis fields live inside `aiAnalysisResult` when wrapped, or at the
    // top level when the backend returns a flat response.
    final result = _asNullableMap(json['aiAnalysisResult']) ?? json;

    return AIAnalysisRejectedModel(
      // Top level.
      modality: json['modality'] as String? ?? '',
      scanUrl: json['scanUrl'] as String? ?? '',
      scanBase64: json['scanBase64'] as String? ?? '',
      aiJobStatus: json['aiJobStatus'] as String? ?? '',
      patientName: json['patientName'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      // aiAnalysisResult.
      inputRejected: result['input_rejected'] as bool? ?? true,
      inputGate: InputGateModel.fromJson(_asNullableMap(result['input_gate'])),
      urgency: result['urgency'] as String? ?? '',
      summary: result['summary'] as String? ?? '',
      recommendations: (result['recommendations'] as List<dynamic>? ?? [])
          .map((recommendation) => recommendation.toString())
          .toList(),
      detections: _parseDetections(result['detections']),
    );
  }

  factory AIAnalysisRejectedModel.fromEntity(AIAnalysisRejectedEntity entity) {
    return AIAnalysisRejectedModel(
      inputGate: entity.inputGate,
      inputRejected: entity.inputRejected,
      urgency: entity.urgency,
      summary: entity.summary,
      recommendations: entity.recommendations,
      detections: entity.detections,
      modality: entity.modality,
      scanUrl: entity.scanUrl,
      scanBase64: entity.scanBase64,
      aiJobStatus: entity.aiJobStatus,
      patientName: entity.patientName,
      patientId: entity.patientId,
      createdAt: entity.createdAt,
    );
  }

  /// Serializes back to the ORIGINAL response shape (top-level fields plus an
  /// `aiAnalysisResult` wrapper) so a round-trip re-parses identically.
  Map<String, dynamic> toJson() {
    return {
      'modality': modality,
      'scanUrl': scanUrl,
      'scanBase64': scanBase64,
      'aiJobStatus': aiJobStatus,
      'patientName': patientName,
      'patientId': patientId,
      'createdAt': createdAt,
      'aiAnalysisResult': {
        'input_rejected': inputRejected,
        'input_gate': _inputGateToJson(inputGate),
        'urgency': urgency,
        'summary': summary,
        'recommendations': recommendations,
        'detections': detections
            .map((d) => ProbabilityModel(label: d.label, value: d.value).toJson())
            .toList(),
      },
    };
  }

  AIAnalysisRejectedModel copyWith({
    InputGateEntity? inputGate,
    bool? inputRejected,
    String? urgency,
    String? summary,
    List<String>? recommendations,
    List<ProbabilityEntity>? detections,
    String? modality,
    String? scanUrl,
    String? scanBase64,
    String? aiJobStatus,
    String? patientName,
    String? patientId,
    String? createdAt,
  }) {
    return AIAnalysisRejectedModel(
      inputGate: inputGate ?? this.inputGate,
      inputRejected: inputRejected ?? this.inputRejected,
      urgency: urgency ?? this.urgency,
      summary: summary ?? this.summary,
      recommendations: recommendations ?? this.recommendations,
      detections: detections ?? this.detections,
      modality: modality ?? this.modality,
      scanUrl: scanUrl ?? this.scanUrl,
      scanBase64: scanBase64 ?? this.scanBase64,
      aiJobStatus: aiJobStatus ?? this.aiJobStatus,
      patientName: patientName ?? this.patientName,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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

  static List<ProbabilityEntity> _parseDetections(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => ProbabilityModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
