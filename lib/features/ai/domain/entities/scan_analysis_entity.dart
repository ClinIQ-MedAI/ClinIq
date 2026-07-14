import 'package:cliniq/features/ai/domain/entities/input_gate_entity.dart';
import 'package:cliniq/features/ai/domain/entities/medication_entity.dart';
import 'package:cliniq/features/ai/domain/entities/probability_entity.dart';

/// Sealed union of the three fully independent AI scan result types.
///
/// It intentionally carries **no data of its own** — it exists only so the
/// repository can return a single type and the presentation layer can switch
/// exhaustively. Every field lives on the concrete variant that owns it, so
/// there are no shared/generic nullable fields.
sealed class ScanAnalysisEntity {
  const ScanAnalysisEntity();
}

class AIAnalysisRejectedEntity extends ScanAnalysisEntity {
  const AIAnalysisRejectedEntity({
    required this.inputGate,
    this.inputRejected = true,
    this.urgency = '',
    this.summary = '',
    this.recommendations = const [],
    this.detections = const [],
    this.modality = '',
    this.scanUrl = '',
    this.scanBase64 = '',
    this.aiJobStatus = '',
    this.patientName = '',
    this.patientId = '',
    this.createdAt = '',
  });

  final InputGateEntity inputGate;
  final bool inputRejected;
  final String urgency;
  final String summary;
  final List<String> recommendations;
  final List<ProbabilityEntity> detections;
  final String modality;
  final String scanUrl;
  final String scanBase64;
  final String aiJobStatus;
  final String patientName;
  final String patientId;
  final String createdAt;
}

class AIAnalysisSuccessEntity extends ScanAnalysisEntity {
  const AIAnalysisSuccessEntity({
    required this.inputGate,
    required this.annotatedImageBase64,
    required this.primaryDiagnosis,
    required this.confidence,
    this.urgency = '',
    this.summary = '',
    this.recommendations = const [],
    this.severity = '',
    this.clinicalMeaning = '',
    this.bodyPart = '',
    this.patientContext = '',
    this.timestamp = '',
    this.findingsList = const [],
    this.differentialDiagnoses = const [],
    this.allProbabilities = const [],
    this.detections = const [],
    this.id = 0,
    this.modality = '',
    this.scanUrl = '',
    this.scanBase64 = '',
    this.aiJobId = '',
    this.aiJobStatus = '',
    this.patientName = '',
    this.patientId = '',
    this.createdAt = '',
    this.doctorId = '',
    this.doctorName = '',
    this.doctorNotes = '',
    this.doctorReviewDate = '',
    this.isReviewed = false,
  });

  final InputGateEntity inputGate;
  final String annotatedImageBase64;
  final String primaryDiagnosis;
  final String confidence;
  final String urgency;
  final String summary;
  final List<String> recommendations;
  final String severity;
  final String clinicalMeaning;
  final String bodyPart;
  final String patientContext;
  final String timestamp;
  final List<String> findingsList;
  final List<String> differentialDiagnoses;
  final List<ProbabilityEntity> allProbabilities;
  final List<ProbabilityEntity> detections;
  final int id;
  final String modality;
  final String scanUrl;
  final String scanBase64;
  final String aiJobId;
  final String aiJobStatus;
  final String patientName;
  final String patientId;
  final String createdAt;
  final String doctorId;
  final String doctorName;
  final String doctorNotes;
  final String doctorReviewDate;
  final bool isReviewed;
}

class PrescriptionAnalysisEntity extends ScanAnalysisEntity {
  const PrescriptionAnalysisEntity({
    required this.inputGate,
    required this.totalMedications,
    required this.verifiedMedications,
    required this.medications,
    required this.aiFindingsNotes,
    this.id = 0,
    this.modality = '',
    this.scanUrl = '',
    this.scanBase64 = '',
    this.aiJobId = '',
    this.aiJobStatus = '',
    this.doctorId = '',
    this.doctorName = '',
    this.doctorNotes = '',
    this.doctorReviewDate = '',
    this.isReviewed = false,
    this.success = false,
    this.imageType = '',
    this.detections = const [],
    this.primaryDiagnosis = '',
    this.rawVlmOutput = '',
    this.rawMedications = const [],
    this.patientName = '',
    this.patientId = '',
    this.createdAt = '',
  });

  final InputGateEntity inputGate;
  final int totalMedications;
  final int verifiedMedications;
  final List<MedicationEntity> medications;
  final String aiFindingsNotes;
  final int id;
  final String modality;
  final String scanUrl;
  final String scanBase64;
  final String aiJobId;
  final String aiJobStatus;
  final String doctorId;
  final String doctorName;
  final String doctorNotes;
  final String doctorReviewDate;
  final bool isReviewed;
  final bool success;
  final String imageType;
  final List<ProbabilityEntity> detections;
  final String primaryDiagnosis;
  final String rawVlmOutput;
  final List<MedicationEntity> rawMedications;
  final String patientName;
  final String patientId;
  final String createdAt;
}
