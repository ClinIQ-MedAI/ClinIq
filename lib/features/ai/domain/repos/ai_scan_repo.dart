import 'package:cliniq/features/ai/domain/entities/ai_scan_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:cliniq/core/errors/failures.dart';

abstract class AiScanRepo {
  Future<Either<Failure, AiScanEntity>> uploadScan({
    required String imageBase64,
    required String patientId,
    required String modality,
  });

  Future<Either<Failure, AiScanEntity>> uploadPrescription({
    required String imageBase64,
    required String patientId,
  });
}
