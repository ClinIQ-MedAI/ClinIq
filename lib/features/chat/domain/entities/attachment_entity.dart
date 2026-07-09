class AttachmentEntity {
  final String filePath;
  final String fileName;
  final String extension;
  final int? fileSize;

  AttachmentEntity({
    required this.filePath,
    required this.fileName,
    required this.extension,
    this.fileSize,
  });
}
