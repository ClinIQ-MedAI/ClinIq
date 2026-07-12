import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/repos/base_repo/base_repo_impl.dart';
import 'package:cliniq/features/ai/data/models/ai_scan_model.dart';
import 'package:cliniq/features/ai/domain/entities/ai_scan_entity.dart';
import 'package:cliniq/features/ai/domain/repos/ai_scan_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:cliniq/core/errors/failures.dart';

class AiScanRepoImpl extends BaseRepoImpl implements AiScanRepo {
  AiScanRepoImpl({required super.api});

  @override
  Future<Either<Failure, AiScanEntity>> uploadScan({
    required String imageBase64,
    required String patientId,
    required String modality,
  }) {
    return handleApi(() async {
      final response = await api.post(
        EndPoints.aiScanUpload,
        data: {
          'imageBase64': imageBase64,
          'patientId': patientId,
          'modality': modality,
        },
      );
      final data = response is Map<String, dynamic> &&
              response.containsKey('data') &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response as Map<String, dynamic>;
      return AiScanModel.fromJson(data);
    });
  }

  @override
  Future<Either<Failure, AiScanEntity>> uploadPrescription({
    required String imageBase64,
    required String patientId,
  }) {
    return handleApi(() async {
      final response = await api.post(
        EndPoints.aiPrescriptionUpload,
        data: {
          'imageBase64': imageBase64,
          'patientId': patientId,
        },
      );
      final data = response is Map<String, dynamic> &&
              response.containsKey('data') &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response as Map<String, dynamic>;
      return AiScanModel.fromJson(data);
    });
  }
}
