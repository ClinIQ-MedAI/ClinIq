class MedicationEntity {
  final String drug;
  final String dosage;
  final String frequency;
  final String scheduleAr;
  final double confidenceScore;
  final bool officialMatch;

  const MedicationEntity({
    required this.drug,
    required this.dosage,
    required this.frequency,
    required this.scheduleAr,
    required this.confidenceScore,
    required this.officialMatch,
  });
}
