class UploadedAttachmentEntity {
  final String id;
  final String url;
  final String fileName;
  final String fileType;
  final String mimeType;
  final int size;

  UploadedAttachmentEntity({
    required this.id,
    required this.url,
    required this.fileName,
    required this.fileType,
    required this.mimeType,
    required this.size,
  });
}
