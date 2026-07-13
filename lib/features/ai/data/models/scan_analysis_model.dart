import 'dart:developer';

import 'package:cliniq/features/ai/data/models/ai_analysis_rejected_model.dart';
import 'package:cliniq/features/ai/data/models/ai_analysis_success_model.dart';
import 'package:cliniq/features/ai/data/models/prescription_analysis_model.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

abstract final class ScanAnalysisModel {
  static ScanAnalysisEntity fromJson(Map<String, dynamic> json) {
    final analysisJson = _analysisJson(json);
    final inputGate = analysisJson['input_gate'] as Map<String, dynamic>?;
    final rawPassed = inputGate?['passed'];
    final passed = _isTruthy(rawPassed);

    log('[ScanAnalysisModel] passed_raw=$rawPassed (${rawPassed.runtimeType}) resolved=$passed');

    if (passed) {
      final modality = analysisJson['modality'] as String? ?? '';
      if (modality == 'PRESCRIPTION') {
        return PrescriptionAnalysisModel.fromJson(analysisJson);
      }
      return AIAnalysisSuccessModel.fromJson(analysisJson);
    }

    return AIAnalysisRejectedModel.fromJson(analysisJson);
  }

  /// Returns `true` for [bool] `true`, [int] `1`, or [String] `"true"`.
  static bool _isTruthy(Object? value) {
    return value == true || value == 1 || value == 'true';
  }

  static Map<String, dynamic> toJson(ScanAnalysisEntity analysis) {
    return switch (analysis) {
      AIAnalysisRejectedModel() => analysis.toJson(),
      AIAnalysisSuccessModel() => analysis.toJson(),
      PrescriptionAnalysisModel() => analysis.toJson(),
      AIAnalysisRejectedEntity() => AIAnalysisRejectedModel.fromEntity(
        analysis,
      ).toJson(),
      AIAnalysisSuccessEntity() => AIAnalysisSuccessModel.fromEntity(
        analysis,
      ).toJson(),
      PrescriptionAnalysisEntity() => PrescriptionAnalysisModel.fromEntity(
        analysis,
      ).toJson(),
    };
  }

  /// Unwraps a top-level `aiAnalysisResult` key **only** when the inner map
  /// contains an `input_gate` field.  Otherwise returns the original map so
  /// that `input_gate` at the top level is never lost.
  static Map<String, dynamic> _analysisJson(Map<String, dynamic> json) {
    final wrapped = json['aiAnalysisResult'];
    if (wrapped is Map<String, dynamic> || wrapped is Map) {
      final inner = wrapped is Map<String, dynamic>
          ? wrapped
          : Map<String, dynamic>.from(wrapped as Map);
      if (inner.containsKey('input_gate')) {
        return inner;
      }
    }
    return json;
  }
}
