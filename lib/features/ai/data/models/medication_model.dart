import 'package:cliniq/features/ai/domain/entities/medication_entity.dart';

class MedicationModel extends MedicationEntity {
  const MedicationModel({
    super.drugExtracted,
    required super.drug,
    required super.dosage,
    required super.frequency,
    required super.scheduleAr,
    super.scheduleSource,
    required super.confidenceScore,
    required super.officialMatch,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      drugExtracted: json['drug_extracted'] as String? ??
          json['drugExtracted'] as String? ??
          '',
      drug: json['drug'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      scheduleAr: json['schedule_ar'] as String? ??
          json['scheduleAr'] as String? ??
          '',
      scheduleSource: json['schedule_source'] as String? ??
          json['scheduleSource'] as String? ??
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
      drugExtracted: entity.drugExtracted,
      drug: entity.drug,
      dosage: entity.dosage,
      frequency: entity.frequency,
      scheduleAr: entity.scheduleAr,
      scheduleSource: entity.scheduleSource,
      confidenceScore: entity.confidenceScore,
      officialMatch: entity.officialMatch,
    );
  }

  Map<String, dynamic> toJson() => {
        'drug_extracted': drugExtracted,
        'drug': drug,
        'dosage': dosage,
        'frequency': frequency,
        'schedule_ar': scheduleAr,
        'schedule_source': scheduleSource,
        'confidence_score': confidenceScore,
        'official_match': officialMatch,
      };

  MedicationModel copyWith({
    String? drugExtracted,
    String? drug,
    String? dosage,
    String? frequency,
    String? scheduleAr,
    String? scheduleSource,
    double? confidenceScore,
    bool? officialMatch,
  }) {
    return MedicationModel(
      drugExtracted: drugExtracted ?? this.drugExtracted,
      drug: drug ?? this.drug,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      scheduleAr: scheduleAr ?? this.scheduleAr,
      scheduleSource: scheduleSource ?? this.scheduleSource,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      officialMatch: officialMatch ?? this.officialMatch,
    );
  }
}
