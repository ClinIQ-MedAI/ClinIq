import 'package:cliniq/features/chat/domain/entities/attachment_entity.dart';
import 'package:cliniq/features/chat/domain/entities/attachment_type.dart';
import 'package:cliniq/features/chat/domain/entities/uploaded_attachment_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:cliniq/core/errors/failures.dart';

abstract class AttachmentRepo {
  Future<Either<Failure, AttachmentEntity>> pickFile(
    AttachmentType attachmentType,
  );

  Future<Either<Failure, UploadedAttachmentEntity>> uploadAttachment({
    required String filePath,
    required String fileName,
  });
}
