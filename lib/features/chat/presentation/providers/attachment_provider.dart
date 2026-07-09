import 'package:cliniq/features/chat/domain/entities/attachment_entity.dart';
import 'package:cliniq/features/chat/domain/entities/attachment_type.dart';
import 'package:cliniq/features/chat/domain/entities/uploaded_attachment_entity.dart';
import 'package:cliniq/features/chat/presentation/providers/attachment_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttachmentUploadState {
  final AttachmentEntity? pickedFile;
  final UploadedAttachmentEntity? uploadedFile;
  final bool isUploading;
  final String? error;

  const AttachmentUploadState({
    this.pickedFile,
    this.uploadedFile,
    this.isUploading = false,
    this.error,
  });

  bool get hasAttachment => uploadedFile != null;

  AttachmentUploadState copyWith({
    AttachmentEntity? pickedFile,
    UploadedAttachmentEntity? uploadedFile,
    bool? isUploading,
    String? error,
    bool clearPickedFile = false,
    bool clearUploadedFile = false,
    bool clearError = false,
  }) {
    return AttachmentUploadState(
      pickedFile: clearPickedFile ? null : (pickedFile ?? this.pickedFile),
      uploadedFile:
          clearUploadedFile ? null : (uploadedFile ?? this.uploadedFile),
      isUploading: isUploading ?? this.isUploading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final attachmentUploadProvider =
    NotifierProvider<AttachmentUploadNotifier, AttachmentUploadState>(
  AttachmentUploadNotifier.new,
);

class AttachmentUploadNotifier extends Notifier<AttachmentUploadState> {
  @override
  AttachmentUploadState build() => const AttachmentUploadState();

  Future<void> pickFile(AttachmentType type) async {
    state = const AttachmentUploadState(isUploading: true);
    final repo = ref.read(attachmentRepoProvider);
    final result = await repo.pickFile(type);

    result.fold(
      (failure) {
        if (failure.message == 'File selection cancelled') {
          state = const AttachmentUploadState();
        } else {
          state = AttachmentUploadState(error: failure.message);
        }
      },
      (file) {
        state = AttachmentUploadState(pickedFile: file);
        _upload(file);
      },
    );
  }

  Future<void> _upload(AttachmentEntity file) async {
    state = state.copyWith(isUploading: true);
    final repo = ref.read(attachmentRepoProvider);
    final result = await repo.uploadAttachment(
      filePath: file.filePath,
      fileName: file.fileName,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isUploading: false,
          error: failure.message,
        );
      },
      (uploaded) {
        state = state.copyWith(
          uploadedFile: uploaded,
          isUploading: false,
          clearError: true,
        );
      },
    );
  }

  void retry() {
    final picked = state.pickedFile;
    if (picked != null) {
      _upload(picked);
    }
  }

  void removeAttachment() {
    state = const AttachmentUploadState();
  }

  void resetAfterSend() {
    state = const AttachmentUploadState();
  }
}
