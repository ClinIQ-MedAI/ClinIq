import 'dart:convert';
import 'dart:developer';

import 'package:cliniq/features/ai/data/models/ai_analysis_rejected_model.dart';
import 'package:cliniq/features/ai/data/models/ai_analysis_success_model.dart';
import 'package:cliniq/features/ai/data/models/prescription_analysis_model.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

/// Thin dispatcher that picks the correct, fully independent parser for the
/// three response shapes the backend returns. It does **not** parse anything
/// itself — each model reads the ORIGINAL response directly.
abstract final class ScanAnalysisModel {
  static ScanAnalysisEntity fromJson(Map<String, dynamic> json) {
    final entity = _route(json);
    _logDiagnostics(json, entity); // TEMPORARY: remove after runtime verification.
    return entity;
  }

  static ScanAnalysisEntity _route(Map<String, dynamic> json) {
    // 1) Prescription is detected ONLY from the TOP-LEVEL `modality` and is
    //    parsed straight from the original response.
    if (json['modality'] == 'PRESCRIPTION') {
      return PrescriptionAnalysisModel.fromJson(json);
    }

    // 2) Otherwise inspect `input_gate.passed`. The backend returns the gate
    //    either inside `aiAnalysisResult` or (sometimes) flat at the top level,
    //    so we look in both places.
    //    - passed is explicitly false  -> rejected
    //    - input_gate missing / passed missing / passed true -> success
    if (_isRejected(json)) {
      return AIAnalysisRejectedModel.fromJson(json);
    }

    return AIAnalysisSuccessModel.fromJson(json);
  }

  /// A response is rejected ONLY when an `input_gate` is present and its
  /// `passed` flag resolves to false. Missing gate or missing flag => success.
  static bool _isRejected(Map<String, dynamic> json) {
    final gate = _locateInputGate(json);
    if (gate == null || !gate.containsKey('passed')) return false;
    return _resolvesFalse(gate['passed']);
  }

  /// Deep-searches the response tree for `input_gate`, regardless of whether it
  /// is wrapped in `aiAnalysisResult`, flat at the top level, or nested inside
  /// a JSON-encoded string. This makes routing immune to the backend's exact
  /// nesting/encoding of the gate.
  static Map<String, dynamic>? _locateInputGate(Object? node, [int depth = 0]) {
    if (depth > 8) return null;
    final map = coerceMap(node);
    if (map != null) {
      for (final key in const ['input_gate', 'inputGate']) {
        if (map.containsKey(key)) {
          final gate = coerceMap(map[key]);
          if (gate != null) return gate;
        }
      }
      for (final value in map.values) {
        final found = _locateInputGate(value, depth + 1);
        if (found != null) return found;
      }
      return null;
    }
    if (node is List) {
      for (final item in node) {
        final found = _locateInputGate(item, depth + 1);
        if (found != null) return found;
      }
    }
    return null;
  }

  /// Treats only an explicit false value (bool `false`, `"false"`, `0`) as a
  /// failed gate. `null` or anything truthy is NOT a rejection.
  static bool _resolvesFalse(Object? passed) {
    if (passed is bool) return passed == false;
    if (passed is num) return passed == 0;
    if (passed is String) {
      final v = passed.trim().toLowerCase();
      return v == 'false' || v == '0';
    }
    return false;
  }

  /// Coerces a value into a `Map<String, dynamic>`, tolerating both a real map
  /// (of any key type) and a JSON-encoded string (double-encoded payloads).
  /// Returns null when the value is neither.
  static Map<String, dynamic>? coerceMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String) {
      // Only attempt to decode strings that actually look like a JSON object,
      // so base64 image blobs are never fed to jsonDecode.
      final trimmed = value.trim();
      if (trimmed.startsWith('{')) {
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is Map) return Map<String, dynamic>.from(decoded);
        } catch (_) {
          return null;
        }
      }
    }
    return null;
  }

  static Map<String, dynamic> toJson(ScanAnalysisEntity analysis) {
    return switch (analysis) {
      AIAnalysisRejectedModel() => analysis.toJson(),
      AIAnalysisSuccessModel() => analysis.toJson(),
      PrescriptionAnalysisModel() => analysis.toJson(),
      AIAnalysisRejectedEntity() =>
        AIAnalysisRejectedModel.fromEntity(analysis).toJson(),
      AIAnalysisSuccessEntity() =>
        AIAnalysisSuccessModel.fromEntity(analysis).toJson(),
      PrescriptionAnalysisEntity() =>
        PrescriptionAnalysisModel.fromEntity(analysis).toJson(),
    };
  }

  /// TEMPORARY runtime diagnostics — prints the exact shape the backend sent
  /// and the entity we routed to. Remove once real responses are confirmed.
  static void _logDiagnostics(
    Map<String, dynamic> json,
    ScanAnalysisEntity entity,
  ) {
    final rawResult = json['aiAnalysisResult'];
    final result = coerceMap(rawResult);
    final gate = _locateInputGate(json);
    final passed = gate != null && gate.containsKey('passed')
        ? gate['passed']
        : null;
    log(
      '\n[ScanAnalysisModel] ─── AI Scan Routing ───\n'
      '  containsKey(aiAnalysisResult): ${json.containsKey('aiAnalysisResult')}\n'
      '  aiAnalysisResult runtimeType : ${rawResult.runtimeType}\n'
      '  aiAnalysisResult -> Map?     : ${result != null}\n'
      '  Response Shape               : ${result != null ? 'Wrapped (aiAnalysisResult)' : 'Flat (top-level)'}\n'
      '  Top Modality                 : ${json['modality']}\n'
      '  Found input_gate             : ${gate != null}\n'
      '  passed                       : $passed (${passed.runtimeType})\n'
      '  Routing                      : ${entity.runtimeType}\n'
      '  ────────────────────────────────────',
    );
  }
}
