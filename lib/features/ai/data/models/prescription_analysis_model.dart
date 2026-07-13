import 'package:cliniq/features/ai/data/models/input_gate_model.dart';
import 'package:cliniq/features/ai/data/models/medication_model.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

class PrescriptionAnalysisModel extends PrescriptionAnalysisEntity {
  const PrescriptionAnalysisModel({
    required super.inputGate,
    required super.scanBase64,
    required super.totalMedications,
    required super.verifiedMedications,
    required super.medications,
    required super.aiFindingsNotes,
    super.modality,
    super.createdAt,
    super.patientName,
    super.patientId,
  });

  factory PrescriptionAnalysisModel.fromJson(Map<String, dynamic> json) {
    final reportData = json['report_data'] as Map<String, dynamic>? ?? {};
    final aiFindings = json['ai_findings'] as Map<String, dynamic>? ?? {};
    final rawMeds = json['medications'] as List<dynamic>? ?? [];

    return PrescriptionAnalysisModel(
      inputGate: InputGateModel.fromJson(
        json['input_gate'] as Map<String, dynamic>?,
      ),
      scanBase64: json['scanBase64'] as String? ?? '',
      totalMedications:
          (reportData['total_medications'] as num? ?? 0).toInt(),
      verifiedMedications:
          (reportData['verified_medications'] as num? ?? 0).toInt(),
      medications: rawMeds
          .map((e) => MedicationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiFindingsNotes: aiFindings['notes'] as String? ?? '',
      modality: json['modality'] as String? ?? '',
      createdAt: json['createdAt'] as String? ??
          json['created_at'] as String? ??
          '',
      patientName: json['patient_name'] as String? ??
          json['patientName'] as String? ??
          '',
      patientId: json['patient_id'] as String? ??
          json['patientId'] as String? ??
          '',
    );
  }

  factory PrescriptionAnalysisModel.fromEntity(
    PrescriptionAnalysisEntity entity,
  ) {
    return PrescriptionAnalysisModel(
      inputGate: entity.inputGate,
      scanBase64: entity.scanBase64,
      totalMedications: entity.totalMedications,
      verifiedMedications: entity.verifiedMedications,
      medications: entity.medications,
      aiFindingsNotes: entity.aiFindingsNotes,
      modality: entity.modality,
      createdAt: entity.createdAt,
      patientName: entity.patientName,
      patientId: entity.patientId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'input_gate': InputGateModel(
        passed: inputGate.passed,
        reason: inputGate.reason,
        action: inputGate.action,
        width: inputGate.width,
        height: inputGate.height,
        aspectRatio: inputGate.aspectRatio,
        intensityStd: inputGate.intensityStd,
        colorSpread: inputGate.colorSpread,
        colorfulFraction: inputGate.colorfulFraction,
      ).toJson(),
      'scanBase64': scanBase64,
      'report_data': {
        'total_medications': totalMedications,
        'verified_medications': verifiedMedications,
      },
      'medications': medications
          .map(
            (m) => MedicationModel(
              drug: m.drug,
              dosage: m.dosage,
              frequency: m.frequency,
              scheduleAr: m.scheduleAr,
              confidenceScore: m.confidenceScore,
              officialMatch: m.officialMatch,
            ).toJson(),
          )
          .toList(),
      'ai_findings': {
        'notes': aiFindingsNotes,
      },
      'modality': modality,
      'createdAt': createdAt,
      'patient_name': patientName,
      'patient_id': patientId,
      '__typename': 'PrescriptionAnalysis',
    };
  }
}
