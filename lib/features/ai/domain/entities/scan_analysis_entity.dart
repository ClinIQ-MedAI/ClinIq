import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';
import 'package:cliniq/features/ai/domain/entities/medication_entity.dart';
import 'package:cliniq/features/ai/domain/entities/probability_entity.dart';

sealed class ScanAnalysisEntity {
  const ScanAnalysisEntity({
    required this.inputGate,
    this.urgency = '',
    this.summary = '',
    this.recommendations = const [],
    this.modality = '',
    this.createdAt = '',
    this.patientName = '',
    this.patientId = '',
  });

  final InputGateEntity inputGate;
  final String urgency;
  final String summary;
  final List<String> recommendations;
  final String modality;
  final String createdAt;
  final String patientName;
  final String patientId;
}

class AIAnalysisRejectedEntity extends ScanAnalysisEntity {
  const AIAnalysisRejectedEntity({
    required this.inputRejected,
    required super.inputGate,
    required super.urgency,
    required super.summary,
    required super.recommendations,
    this.scanBase64 = '',
    this.scanUrl = '',
    this.aiJobStatus = '',
    super.modality,
    super.createdAt,
    super.patientName,
    super.patientId,
  });

  final bool inputRejected;
  final String scanBase64;
  final String scanUrl;
  final String aiJobStatus;
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
    this.severity = '',
    this.clinicalMeaning = '',
    this.bodyPart = '',
    this.patientContext = '',
    this.findingsList = const [],
    this.allProbabilities = const [],
    super.modality,
    super.createdAt,
    super.patientName,
    super.patientId,
  });

  final String annotatedImageBase64;
  final String primaryDiagnosis;
  final String confidence;
  final String severity;
  final String clinicalMeaning;
  final String bodyPart;
  final String patientContext;
  final List<String> findingsList;
  final List<ProbabilityEntity> allProbabilities;
}

class PrescriptionAnalysisEntity extends ScanAnalysisEntity {
  final String scanBase64;
  final int totalMedications;
  final int verifiedMedications;
  final List<MedicationEntity> medications;
  final String aiFindingsNotes;

  const PrescriptionAnalysisEntity({
    required super.inputGate,
    required this.scanBase64,
    required this.totalMedications,
    required this.verifiedMedications,
    required this.medications,
    required this.aiFindingsNotes,
    super.modality,
    super.createdAt,
    super.patientName,
    super.patientId,
  });
}
