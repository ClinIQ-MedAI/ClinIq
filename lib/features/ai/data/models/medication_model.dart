import 'package:cliniq/features/ai/domain/entities/medication_entity.dart';

class MedicationModel extends MedicationEntity {
  const MedicationModel({
    required super.drug,
    required super.dosage,
    required super.frequency,
    required super.scheduleAr,
    required super.confidenceScore,
    required super.officialMatch,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      drug: json['drug'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      scheduleAr: json['schedule_ar'] as String? ??
          json['scheduleAr'] as String? ??
          '',
      confidenceScore:
          (json['confidence_score'] as num? ?? json['confidenceScore'] as num? ?? 0)
              .toDouble(),
      officialMatch: json['official_match'] == true ||
          json['officialMatch'] == true,
    );
  }

  factory MedicationModel.fromEntity(MedicationEntity entity) {
    return MedicationModel(
      drug: entity.drug,
      dosage: entity.dosage,
      frequency: entity.frequency,
      scheduleAr: entity.scheduleAr,
      confidenceScore: entity.confidenceScore,
      officialMatch: entity.officialMatch,
    );
  }

  Map<String, dynamic> toJson() => {
        'drug': drug,
        'dosage': dosage,
        'frequency': frequency,
        'schedule_ar': scheduleAr,
        'confidence_score': confidenceScore,
        'official_match': officialMatch,
      };
}
