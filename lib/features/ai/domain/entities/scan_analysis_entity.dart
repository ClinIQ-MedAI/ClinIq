class ScanAnalysisEntity {
  final String id;
  final String findings;
  final String modality;
  final String status;
  final String createdAt;
  final String imageUrl;
  final String patientId;

  const ScanAnalysisEntity({
    required this.id,
    this.findings = '',
    this.modality = '',
    this.status = '',
    this.createdAt = '',
    this.imageUrl = '',
    this.patientId = '',
  });
}
