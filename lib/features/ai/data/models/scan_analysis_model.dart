import 'dart:developer';

import 'package:cliniq/features/ai/data/models/ai_analysis_rejected_model.dart';
import 'package:cliniq/features/ai/data/models/ai_analysis_success_model.dart';
import 'package:cliniq/features/ai/data/models/input_gate_model.dart';
import 'package:cliniq/features/ai/data/models/prescription_analysis_model.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

abstract final class ScanAnalysisModel {
  static ScanAnalysisEntity fromJson(Map<String, dynamic> json) {
    final resolved = _resolveJson(json);
    final modality = _findInJson(resolved, 'modality') as String? ?? '';
    final urgency = _findInJson(resolved, 'urgency') as String? ?? '';

    final inputGateMap =
        _findInJson(resolved, 'input_gate') as Map<String, dynamic>?;
    final inputGateModel = InputGateModel.fromJson(inputGateMap);

    log('========================================');
    log('[ScanAnalysisModel] modality=$modality');
    log('[ScanAnalysisModel] input_gate.passed=${inputGateModel.passed}');
    log('[ScanAnalysisModel] input_gate.action=${inputGateModel.action}');
    log('[ScanAnalysisModel] urgency=$urgency');
    log('[ScanAnalysisModel] resolved keys: ${resolved.keys}');
    log('========================================');

    if (inputGateModel.passed) {
      if (modality == 'PRESCRIPTION') {
        return PrescriptionAnalysisModel.fromJson(resolved);
      }
      return AIAnalysisSuccessModel.fromJson(resolved);
    }

    return AIAnalysisRejectedModel.fromJson(resolved);
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

  /// Resolves the JSON response into the best map for analysis parsing.
  ///
  /// Handles three common API response shapes:
  ///   1. Response inside `data` → `aiAnalysisResult` wrapper
  ///   2. Direct `aiAnalysisResult` wrapper
  ///   3. Flat response (no wrapper)
  static Map<String, dynamic> _resolveJson(Map<String, dynamic> json) {
    final unwrapped = _unwrapData(json);
    final wrapped = unwrapped['aiAnalysisResult'];
    if (wrapped is Map<String, dynamic> || wrapped is Map) {
      return wrapped is Map<String, dynamic>
          ? wrapped
          : Map<String, dynamic>.from(wrapped as Map);
    }
    return unwrapped;
  }

  /// Unwraps a top-level `data` key when present, so downstream logic
  /// can access fields like `input_gate`, `modality` directly.
  static Map<String, dynamic> _unwrapData(Map<String, dynamic> json) {
    if (!json.containsKey('data')) return json;
    final data = json['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return json;
  }

  /// Searches for a [key] by checking multiple common nesting locations:
  ///   - top level of [map]
  ///   - inside `aiAnalysisResult`
  ///   - recursively if value is itself a nested map
  static Object? _findInJson(Map<String, dynamic> map, String key) {
    if (map.containsKey(key)) return map[key];
    final wrapped = map['aiAnalysisResult'];
    if (wrapped is Map<String, dynamic> && wrapped.containsKey(key)) {
      return wrapped[key];
    }
    if (wrapped is Map && wrapped.containsKey(key)) {
      return wrapped[key];
    }
    return null;
  }
}
