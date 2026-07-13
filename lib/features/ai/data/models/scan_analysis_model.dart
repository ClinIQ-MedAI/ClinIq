import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';

class ScanAnalysisModel extends ScanAnalysisEntity {
  const ScanAnalysisModel({
    required super.id,
    super.findings,
    super.modality,
    super.status,
    super.createdAt,
    super.imageUrl,
    super.patientId,
  });

  factory ScanAnalysisModel.fromJson(Map<String, dynamic> json) {
    return ScanAnalysisModel(
      id: json['id']?.toString() ?? '',
      findings:
          json['findings'] as String? ?? json['report'] as String? ?? '',
      modality: json['modality'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String? ?? '',
      patientId:
          json['patientId']?.toString() ?? json['patient_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (findings.isNotEmpty) 'findings': findings,
        if (modality.isNotEmpty) 'modality': modality,
        if (status.isNotEmpty) 'status': status,
        if (createdAt.isNotEmpty) 'createdAt': createdAt,
        if (imageUrl.isNotEmpty) 'imageUrl': imageUrl,
        if (patientId.isNotEmpty) 'patientId': patientId,
      };

  ScanAnalysisEntity copyWith({
    String? id,
    String? findings,
    String? modality,
    String? status,
    String? createdAt,
    String? imageUrl,
    String? patientId,
  }) {
    return ScanAnalysisEntity(
      id: id ?? this.id,
      findings: findings ?? this.findings,
      modality: modality ?? this.modality,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      patientId: patientId ?? this.patientId,
    );
  }
}
