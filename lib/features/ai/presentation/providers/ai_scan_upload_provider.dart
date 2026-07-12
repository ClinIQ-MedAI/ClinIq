import 'dart:convert';
import 'dart:io';

import 'package:cliniq/features/ai/domain/entities/ai_scan_entity.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_scan_repo_provider.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiScanUploadState {
  final String? localFilePath;
  final String? fileName;
  final int? fileSize;
  final AiScanEntity? uploadedScan;
  final bool isUploading;
  final String? error;

  const AiScanUploadState({
    this.localFilePath,
    this.fileName,
    this.fileSize,
    this.uploadedScan,
    this.isUploading = false,
    this.error,
  });

  bool get hasAttachment => uploadedScan != null || localFilePath != null;

  AiScanUploadState copyWith({
    String? localFilePath,
    String? fileName,
    int? fileSize,
    AiScanEntity? uploadedScan,
    bool? isUploading,
    String? error,
    bool clearLocalFile = false,
    bool clearUploadedScan = false,
    bool clearError = false,
  }) {
    return AiScanUploadState(
      localFilePath:
          clearLocalFile ? null : (localFilePath ?? this.localFilePath),
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      uploadedScan:
          clearUploadedScan ? null : (uploadedScan ?? this.uploadedScan),
      isUploading: isUploading ?? this.isUploading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final aiScanUploadProvider =
    NotifierProvider<AiScanUploadNotifier, AiScanUploadState>(
  AiScanUploadNotifier.new,
);

class AiScanUploadNotifier extends Notifier<AiScanUploadState> {
  @override
  AiScanUploadState build() => const AiScanUploadState();

  Future<bool> pickFile(bool isScan) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: isScan
          ? ['jpg', 'jpeg', 'png', 'dcm']
          : ['jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.isEmpty) return false;

    final file = result.files.first;
    if (file.path == null) return false;

    state = AiScanUploadState(
      localFilePath: file.path,
      fileName: file.name,
      fileSize: file.size,
    );

    if (!isScan) {
      await _uploadPrescription(file.path!, file.name);
    }

    return true;
  }

  Future<bool> uploadWithModality(String modality) async {
    final current = state;
    if (current.localFilePath == null) return false;
    return _uploadScan(current.localFilePath!, current.fileName!, modality);
  }

  Future<bool> _uploadScan(
      String filePath, String fileName, String modality) async {
    state = state.copyWith(isUploading: true, clearError: true);

    final base64 = await _fileToBase64(filePath);
    if (base64 == null) {
      state = state.copyWith(
        isUploading: false,
        error: 'Failed to read file',
      );
      return false;
    }

    final patientId = _getPatientId();
    if (patientId == null) {
      state = state.copyWith(
        isUploading: false,
        error: 'Patient not found',
      );
      return false;
    }

    final repo = ref.read(aiScanRepoProvider);
    final result = await repo.uploadScan(
      imageBase64: base64,
      patientId: patientId,
      modality: modality,
    );

    var success = false;
    result.fold((failure) {
      state = state.copyWith(isUploading: false, error: failure.message);
    }, (scan) {
      state = state.copyWith(
        uploadedScan: scan,
        isUploading: false,
        clearError: true,
      );
      success = true;
    });
    return success;
  }

  Future<bool> _uploadPrescription(
      String filePath, String fileName) async {
    state = state.copyWith(isUploading: true, clearError: true);

    final base64 = await _fileToBase64(filePath);
    if (base64 == null) {
      state = state.copyWith(
        isUploading: false,
        error: 'Failed to read file',
      );
      return false;
    }

    final patientId = _getPatientId();
    if (patientId == null) {
      state = state.copyWith(
        isUploading: false,
        error: 'Patient not found',
      );
      return false;
    }

    final repo = ref.read(aiScanRepoProvider);
    final result = await repo.uploadPrescription(
      imageBase64: base64,
      patientId: patientId,
    );

    var success = false;
    result.fold((failure) {
      state = state.copyWith(isUploading: false, error: failure.message);
    }, (scan) {
      state = state.copyWith(
        uploadedScan: scan,
        isUploading: false,
        clearError: true,
      );
      success = true;
    });
    return success;
  }

  void retry() {
    final current = state;
    if (current.error != null && current.localFilePath != null) {
      state = state.copyWith(isUploading: true, clearError: true);
    }
  }

  void removeAttachment() {
    state = const AiScanUploadState();
  }

  void resetAfterSend() {
    state = const AiScanUploadState();
  }

  Future<String?> _fileToBase64(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (_) {
      return null;
    }
  }

  String? _getPatientId() {
    return ref.read(currentUserProvider)?.id;
  }
}
