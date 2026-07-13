import 'package:cliniq/features/ai/data/models/ai_analysis_rejected_model.dart';
import 'package:cliniq/features/ai/data/models/ai_analysis_success_model.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

abstract final class ScanAnalysisModel {
  static ScanAnalysisEntity fromJson(Map<String, dynamic> json) {
    final analysisJson = _analysisJson(json);
    final inputGate = analysisJson['input_gate'] as Map<String, dynamic>?;
    final passed = inputGate?['passed'] == true;

    if (passed) {
      return AIAnalysisSuccessModel.fromJson(analysisJson);
    }

    return AIAnalysisRejectedModel.fromJson(analysisJson);
  }

  static Map<String, dynamic> toJson(ScanAnalysisEntity analysis) {
    return switch (analysis) {
      AIAnalysisRejectedModel() => analysis.toJson(),
      AIAnalysisSuccessModel() => analysis.toJson(),
      AIAnalysisRejectedEntity() => AIAnalysisRejectedModel.fromEntity(
        analysis,
      ).toJson(),
      AIAnalysisSuccessEntity() => AIAnalysisSuccessModel.fromEntity(
        analysis,
      ).toJson(),
    };
  }

  static Map<String, dynamic> _analysisJson(Map<String, dynamic> json) {
    final wrapped = json['aiAnalysisResult'];
    if (wrapped is Map<String, dynamic>) {
      return wrapped;
    }
    if (wrapped is Map) {
      return Map<String, dynamic>.from(wrapped);
    }
    return json;
  }
}
