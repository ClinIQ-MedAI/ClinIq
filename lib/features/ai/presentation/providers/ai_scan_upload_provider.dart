import 'dart:async';
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

  Future<ScanAnalysisEntity?> analyzeScan({
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

    final uploadId = uploadResult.fold<String?>((failure) {
      log('AiScanUpload: Upload failed: $failure');
      state = AiScanUploadError(failure.message);
      return null;
    }, (uploaded) => uploaded.id);

    if (uploadId == null) return null;

    log('AiScanUpload: Upload succeeded (id: $uploadId)');
    state = const AiScanFetchingAnalysis();

    final scanId = int.tryParse(uploadId);
    if (scanId == null) {
      state = AiScanUploadError(LocaleKeys.aiScanInvalidId.tr());
      return null;
    }

    // The AI job runs asynchronously on the backend, so the first fetch often
    // returns `aiJobStatus: Pending` with an empty `aiAnalysisResult`. We MUST
    // poll until the job is completed, otherwise every scan is classified as a
    // (blank) success. Only the completed payload has the real input_gate.
    return _pollForCompletedAnalysis(scanId);
  }

  /// Polls the analysis endpoint until the AI job finishes (or a timeout),
  /// then routes the completed response to its result entity.
  Future<ScanAnalysisEntity?> _pollForCompletedAnalysis(int scanId) async {
    const maxAttempts = 30;
    const pollInterval = Duration(seconds: 2);

    final repo = ref.read(aiScanRepoProvider);
    ScanAnalysisEntity? latest;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      final result = await repo.getScanAnalysis(scanId);

      final failure = result.fold((f) => f, (_) => null);
      if (failure != null) {
        log('AiScanUpload: Analysis fetch failed: ${failure.message}');
        state = AiScanUploadError(failure.message);
        return null;
      }

      latest = result.getOrElse(() => throw StateError('unreachable'));
      final status = _jobStatus(latest).trim().toLowerCase();
      log('AiScanUpload: poll #$attempt status="$status" '
          'type=${latest.runtimeType}');

      if (status == 'failed' || status == 'error') {
        // A hard processing failure only. An input-gate REJECTION is NOT a
        // failure here — it comes back as a completed job and is classified by
        // the router (input_gate.passed == false) into the rejected entity.
        state = AiScanUploadError(LocaleKeys.aiScanErrorAnalysis.tr());
        return null;
      }

      // Completed, or the backend didn't report a pending status: the payload
      // is final, so route it now.
      if (!_isPending(status)) {
        log('AiScanUpload: Analysis ready (${latest.runtimeType})');
        state = AiScanUploadCompleted(latest);
        return latest;
      }

      if (attempt < maxAttempts) {
        await Future.delayed(pollInterval);
      }
    }

    // Timed out while still pending.
    log('AiScanUpload: polling timed out (still pending)');
    state = AiScanUploadError(LocaleKeys.aiScanErrorAnalysis.tr());
    return null;
  }

  /// True while the backend is still processing the scan.
  bool _isPending(String status) {
    return const {
      'pending',
      'processing',
      'inprogress',
      'in_progress',
      'in progress',
      'queued',
      'inqueue',
      'running',
      'started',
    }.contains(status);
  }

  String _jobStatus(ScanAnalysisEntity analysis) {
    return switch (analysis) {
      AIAnalysisRejectedEntity(:final aiJobStatus) => aiJobStatus,
      AIAnalysisSuccessEntity(:final aiJobStatus) => aiJobStatus,
      PrescriptionAnalysisEntity(:final aiJobStatus) => aiJobStatus,
    };
  }

  void reset() {
    state = const AiScanUploadInitial();
  }
}
