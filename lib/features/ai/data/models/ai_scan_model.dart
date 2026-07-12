import 'package:cliniq/features/ai/domain/entities/ai_scan_entity.dart';

class AiScanModel extends AiScanEntity {
  const AiScanModel({
    required super.id,
    required super.url,
    required super.modality,
    required super.status,
    required super.createdAt,
  });

  factory AiScanModel.fromJson(Map<String, dynamic> json) {
    return AiScanModel(
      id: json['id']?.toString() ?? '',
      url: json['url'] as String? ?? '',
      modality: json['modality'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'modality': modality,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory AiScanModel.fromEntity(AiScanEntity entity) {
    return AiScanModel(
      id: entity.id,
      url: entity.url,
      modality: entity.modality,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  AiScanEntity toEntity() {
    return AiScanEntity(
      id: id,
      url: url,
      modality: modality,
      status: status,
      createdAt: createdAt,
    );
  }

  AiScanModel copyWith({
    String? id,
    String? url,
    String? modality,
    String? status,
    String? createdAt,
  }) {
    return AiScanModel(
      id: id ?? this.id,
      url: url ?? this.url,
      modality: modality ?? this.modality,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
