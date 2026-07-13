import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';
import 'package:cliniq/features/ai/domain/entities/probability_entity.dart';

class ScanAnalysisEntity {
  final String id;
  final String findings;
  final String modality;
  final String status;
  final String createdAt;
  final String imageUrl;
  final String patientId;
  final String urgency;
  final String summary;
  final List<String> recommendations;
  final String scanBase64;
  final String scanUrl;
  final String annotatedImageBase64;
  final String primaryDiagnosis;
  final double confidence;
  final String severity;
  final String patientContext;
  final String bodyPart;
  final String clinicalMeaning;
  final List<ProbabilityEntity> allProbabilities;
  final List<String> findingsList;
  final InputGateEntity inputGate;
  final String aiJobId;

  const ScanAnalysisEntity({
    required this.id,
    this.findings = '',
    this.modality = '',
    this.status = '',
    this.createdAt = '',
    this.imageUrl = '',
    this.patientId = '',
    this.urgency = '',
    this.summary = '',
    this.recommendations = const [],
    this.scanBase64 = '',
    this.scanUrl = '',
    this.annotatedImageBase64 = '',
    this.primaryDiagnosis = '',
    this.confidence = 0,
    this.severity = '',
    this.patientContext = '',
    this.bodyPart = '',
    this.clinicalMeaning = '',
    this.allProbabilities = const [],
    this.findingsList = const [],
    this.inputGate = const InputGateEntity(passed: true),
    this.aiJobId = '',
  });

  bool get isRejected => urgency.toUpperCase() == 'REJECTED';
  bool get isPassed => inputGate.passed;

  String? get displayImageBase64 =>
      scanBase64.isNotEmpty ? scanBase64 : null;
  String? get displayImageUrl => scanUrl.isNotEmpty ? scanUrl : null;
  String? get displayAnnotatedBase64 =>
      annotatedImageBase64.isNotEmpty ? annotatedImageBase64 : null;
}
