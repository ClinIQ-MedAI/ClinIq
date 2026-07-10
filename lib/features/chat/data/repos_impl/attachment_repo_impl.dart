import 'dart:io';
import 'package:cliniq/core/api/api_consumer.dart';
import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/features/chat/data/models/uploaded_attachment_model.dart';
import 'package:cliniq/features/chat/domain/entities/attachment_entity.dart';
import 'package:cliniq/features/chat/domain/entities/attachment_type.dart';
import 'package:cliniq/features/chat/domain/entities/uploaded_attachment_entity.dart';
import 'package:cliniq/features/chat/domain/repos/attachment_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';

class AttachmentRepoImpl implements AttachmentRepo {
  AttachmentRepoImpl({required this.api});

  final ApiConsumer api;

  @override
  Future<Either<Failure, AttachmentEntity>> pickFile(
    AttachmentType attachmentType,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: attachmentType.extensions,
      );

      if (result == null || result.files.isEmpty) {
        return Left(CustomFailure(message: 'File selection cancelled'));
      }

      final file = result.files.first;
      if (file.path == null) {
        return Left(CustomFailure(message: 'File path not available'));
      }

      return Right(AttachmentEntity(
        filePath: file.path!,
        fileName: file.name,
        extension: file.extension ?? '',
        fileSize: file.size,
      ));
    } catch (e) {
      return Left(CustomFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UploadedAttachmentEntity>> uploadAttachment({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final response = await api.post(
        EndPoints.uploadAttachment,
        data: {
          'file': File(filePath),
          'fileName': fileName,
        },
        isFromData: true,
      );

      final Map<String, dynamic> data;
      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
        data = response['data'];
      } else if (response is Map<String, dynamic> && response.containsKey('id') && response.containsKey('url')) {
        data = response;
      } else {
        return Left(CustomFailure(message: 'Unexpected upload response format'));
      }

      final uploaded = UploadedAttachmentModel.fromJson(data);
      return Right(uploaded);
    } catch (e) {
      return Left(CustomFailure(message: e.toString()));
    }
  }
}
