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
  final String? selectedModality;

  const AttachmentUploadState({
    this.pickedFile,
    this.uploadedFile,
    this.isUploading = false,
    this.error,
    this.selectedModality,
  });

  bool get hasAttachment => pickedFile != null;
  String? get localFilePath => pickedFile?.filePath;
  String? get fileName => pickedFile?.fileName;
  int? get fileSize => pickedFile?.fileSize;

  AttachmentUploadState copyWith({
    AttachmentEntity? pickedFile,
    UploadedAttachmentEntity? uploadedFile,
    bool? isUploading,
    String? error,
    String? selectedModality,
    bool clearPickedFile = false,
    bool clearUploadedFile = false,
    bool clearError = false,
    bool clearModality = false,
  }) {
    return AttachmentUploadState(
      pickedFile: clearPickedFile ? null : (pickedFile ?? this.pickedFile),
      uploadedFile:
          clearUploadedFile ? null : (uploadedFile ?? this.uploadedFile),
      isUploading: isUploading ?? this.isUploading,
      error: clearError ? null : (error ?? this.error),
      selectedModality:
          clearModality ? null : (selectedModality ?? this.selectedModality),
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

  Future<void> pickAttachment(AttachmentType type) async {
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
        state = AttachmentUploadState(
          pickedFile: file,
          selectedModality: type.modalityValue,
        );
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
        state = state.copyWith(isUploading: false, error: failure.message);
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

  Future<UploadedAttachmentEntity?> uploadCurrentFile() async {
    final file = state.pickedFile;
    if (file == null) return null;

    state = state.copyWith(isUploading: true);
    final repo = ref.read(attachmentRepoProvider);
    final result = await repo.uploadAttachment(
      filePath: file.filePath,
      fileName: file.fileName,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isUploading: false, error: failure.message);
        return null;
      },
      (uploaded) {
        state = state.copyWith(
          uploadedFile: uploaded,
          isUploading: false,
          clearError: true,
        );
        return uploaded;
      },
    );
  }

  void retry() {
    uploadCurrentFile();
  }

  void removeAttachment() {
    state = const AttachmentUploadState();
  }

  void resetAfterSend() {
    state = const AttachmentUploadState();
  }

  void clearModality() {
    state = state.copyWith(clearModality: true);
  }
}
