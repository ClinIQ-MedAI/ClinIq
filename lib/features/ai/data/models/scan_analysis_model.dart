import 'dart:developer';

import 'package:cliniq/features/ai/data/models/ai_analysis_rejected_model.dart';
import 'package:cliniq/features/ai/data/models/ai_analysis_success_model.dart';
import 'package:cliniq/features/ai/data/models/input_gate_model.dart';
import 'package:cliniq/features/ai/data/models/prescription_analysis_model.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

abstract final class ScanAnalysisModel {
  static ScanAnalysisEntity fromJson(Map<String, dynamic> json) {
    final analysisJson = _analysisJson(json);
    final inputGateModel = InputGateModel.fromJson(
      analysisJson['input_gate'] as Map<String, dynamic>?,
    );

    log(
      '[ScanAnalysisModel] input_gate keys: ${analysisJson['input_gate'].runtimeType}',
    );
    log(
      '[ScanAnalysisModel] resolved passed=${inputGateModel.passed}',
    );

    if (inputGateModel.passed) {
      final modality = analysisJson['modality'] as String? ?? '';
      if (modality == 'PRESCRIPTION') {
        return PrescriptionAnalysisModel.fromJson(analysisJson);
      }
      return AIAnalysisSuccessModel.fromJson(analysisJson);
    }

    return AIAnalysisRejectedModel.fromJson(analysisJson);
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

  /// Returns the best map to use for analysis parsing.
  ///
  /// 1. If `json` has an `aiAnalysisResult` wrapper and that wrapper
  ///    contains `input_gate`, returns the wrapper content.
  /// 2. If the wrapper exists but has no `input_gate`, checks the outer
  ///    `json` for `input_gate` as a fallback.
  /// 3. Otherwise returns `json` as-is.
  static Map<String, dynamic> _analysisJson(Map<String, dynamic> json) {
    final wrapped = json['aiAnalysisResult'];
    if (wrapped is Map<String, dynamic> || wrapped is Map) {
      final inner = wrapped is Map<String, dynamic>
          ? wrapped
          : Map<String, dynamic>.from(wrapped as Map);
      if (inner.containsKey('input_gate')) {
        return inner;
      }
      if (json.containsKey('input_gate')) {
        return json;
      }
      return inner;
    }
    return json;
  }
}
