import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/domain/entities/uploaded_scan_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:cliniq/core/errors/failures.dart';

abstract class AiScanRepo {
  Future<Either<Failure, UploadedScanEntity>> uploadScan({
    required String imageBase64,
    required String patientId,
    required String modality,
  });

  Future<Either<Failure, ScanAnalysisEntity>> getScanAnalysis(int id);
}
