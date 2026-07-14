class MedicationEntity {
  final String drugExtracted;
  final String drug;
  final String dosage;
  final String frequency;
  final String scheduleAr;
  final String scheduleSource;
  final double confidenceScore;
  final bool officialMatch;

  const MedicationEntity({
    this.drugExtracted = '',
    required this.drug,
    required this.dosage,
    required this.frequency,
    required this.scheduleAr,
    this.scheduleSource = '',
    required this.confidenceScore,
    required this.officialMatch,
  });
}
