import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';

sealed class ScanAnalysisEntity {
  const ScanAnalysisEntity({
    required this.inputGate,
    required this.urgency,
    required this.summary,
    required this.recommendations,
  });

  final InputGateEntity inputGate;
  final String urgency;
  final String summary;
  final List<String> recommendations;
}

class AIAnalysisRejectedEntity extends ScanAnalysisEntity {
  const AIAnalysisRejectedEntity({
    required this.inputRejected,
    required super.inputGate,
    required super.urgency,
    required super.summary,
    required super.recommendations,
  });

  final bool inputRejected;
}

class AIAnalysisSuccessEntity extends ScanAnalysisEntity {
  const AIAnalysisSuccessEntity({
    required super.inputGate,
    required this.annotatedImageBase64,
    required super.urgency,
    required super.summary,
    required super.recommendations,
    required this.primaryDiagnosis,
    required this.confidence,
  });

  final String annotatedImageBase64;
  final String primaryDiagnosis;
  final String confidence;
}
