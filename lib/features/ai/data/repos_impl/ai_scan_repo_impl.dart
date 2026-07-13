import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/repos/base_repo/base_repo_impl.dart';
import 'package:cliniq/features/ai/data/models/scan_analysis_model.dart';
import 'package:cliniq/features/ai/data/models/uploaded_scan_model.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/domain/entities/uploaded_scan_entity.dart';
import 'package:cliniq/features/ai/domain/repos/ai_scan_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:cliniq/core/errors/failures.dart';

class AiScanRepoImpl extends BaseRepoImpl implements AiScanRepo {
  AiScanRepoImpl({required super.api});

  @override
  Future<Either<Failure, UploadedScanEntity>> uploadScan({
    required String imageBase64,
    required String patientId,
    required String modality,
  }) {
    return handleApi(() async {
      final response = await api.post(
        EndPoints.aiScanUpload,
        data: {
          'imageBase64': imageBase64,
          'imageUrl': null,
          'modality': modality,
          'patientId': patientId,
        },
      );
      return UploadedScanModel.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<Either<Failure, ScanAnalysisEntity>> getScanAnalysis(int id) {
    return handleApi(() async {
      final response = await api.get(EndPoints.getScanAnalysis(id));
      return ScanAnalysisModel.fromJson(response as Map<String, dynamic>);
    });
  }
}
