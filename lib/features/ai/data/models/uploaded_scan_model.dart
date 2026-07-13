import 'package:cliniq/features/ai/domain/entities/uploaded_scan_entity.dart';

class UploadedScanModel extends UploadedScanEntity {
  const UploadedScanModel({
    required super.id,
    super.url,
  });

  factory UploadedScanModel.fromJson(Map<String, dynamic> json) {
    return UploadedScanModel(
      id: json['id']?.toString() ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (url.isNotEmpty) 'url': url,
      };

  UploadedScanEntity copyWith({
    String? id,
    String? url,
  }) {
    return UploadedScanEntity(
      id: id ?? this.id,
      url: url ?? this.url,
    );
  }
}
