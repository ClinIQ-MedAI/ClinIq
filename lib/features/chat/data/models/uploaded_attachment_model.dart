import 'package:cliniq/features/chat/domain/entities/uploaded_attachment_entity.dart';

class UploadedAttachmentModel extends UploadedAttachmentEntity {
  UploadedAttachmentModel({
    required super.id,
    required super.url,
    required super.fileName,
    required super.fileType,
    required super.mimeType,
    required super.size,
  });

  factory UploadedAttachmentModel.fromJson(Map<String, dynamic> json) {
    return UploadedAttachmentModel(
      id: json['id']?.toString() ?? '',
      url: json['url'] as String? ?? '',
      fileName: json['fileName'] as String? ?? json['name'] as String? ?? '',
      fileType: json['fileType'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? json['mime'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'fileName': fileName,
      'fileType': fileType,
      'mimeType': mimeType,
      'size': size,
    };
  }

  factory UploadedAttachmentModel.fromEntity(UploadedAttachmentEntity entity) {
    return UploadedAttachmentModel(
      id: entity.id,
      url: entity.url,
      fileName: entity.fileName,
      fileType: entity.fileType,
      mimeType: entity.mimeType,
      size: entity.size,
    );
  }

  UploadedAttachmentEntity toEntity() {
    return UploadedAttachmentEntity(
      id: id,
      url: url,
      fileName: fileName,
      fileType: fileType,
      mimeType: mimeType,
      size: size,
    );
  }

  UploadedAttachmentModel copyWith({
    String? id,
    String? url,
    String? fileName,
    String? fileType,
    String? mimeType,
    int? size,
  }) {
    return UploadedAttachmentModel(
      id: id ?? this.id,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
    );
  }
}
