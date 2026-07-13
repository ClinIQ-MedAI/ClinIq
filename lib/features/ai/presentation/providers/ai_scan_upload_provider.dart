import 'dart:developer';

import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_scan_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

sealed class AiScanUploadState {
  const AiScanUploadState();
}

class AiScanUploadInitial extends AiScanUploadState {
  const AiScanUploadInitial();
}

class AiScanUploadingImage extends AiScanUploadState {
  const AiScanUploadingImage();
}

class AiScanFetchingAnalysis extends AiScanUploadState {
  const AiScanFetchingAnalysis();
}

class AiScanUploadCompleted extends AiScanUploadState {
  final ScanAnalysisEntity analysis;
  const AiScanUploadCompleted(this.analysis);
}

class AiScanUploadError extends AiScanUploadState {
  final String message;
  const AiScanUploadError(this.message);
}

final aiScanUploadProvider =
    NotifierProvider<AiScanUploadNotifier, AiScanUploadState>(
  AiScanUploadNotifier.new,
);

class AiScanUploadNotifier extends Notifier<AiScanUploadState> {
  @override
  AiScanUploadState build() {
    return const AiScanUploadInitial();
  }

  Future<void> analyzeScan({
    required String imageBase64,
    required String patientId,
    required String modality,
  }) async {
    state = const AiScanUploadingImage();

    final repo = ref.read(aiScanRepoProvider);

    final uploadResult = await repo.uploadScan(
      imageBase64: imageBase64,
      patientId: patientId,
      modality: modality,
    );

    final uploadId = uploadResult.fold<String?>(
      (failure) {
        log('AiScanUpload: Upload failed: $failure');
        state = AiScanUploadError(failure.message);
        return null;
      },
      (uploaded) => uploaded.id,
    );

    if (uploadId == null) return;

    log('AiScanUpload: Upload succeeded (id: $uploadId)');
    state = const AiScanFetchingAnalysis();

    final scanId = int.tryParse(uploadId);
    if (scanId == null) {
      state = AiScanUploadError(LocaleKeys.aiScanInvalidId.tr());
      return;
    }

    final analysisResult = await repo.getScanAnalysis(scanId);

    analysisResult.fold(
      (failure) {
        log('AiScanUpload: Analysis failed: $failure');
        state = AiScanUploadError(failure.message);
      },
      (analysis) {
        log('AiScanUpload: Analysis completed (id: ${analysis.id})');
        state = AiScanUploadCompleted(analysis);
      },
    );
  }

  void reset() {
    state = const AiScanUploadInitial();
  }
}
