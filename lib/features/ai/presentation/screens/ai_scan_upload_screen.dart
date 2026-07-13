import 'dart:convert';
import 'dart:io';

import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_scan_upload_provider.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_scan_upload_body.dart';
import 'package:cliniq/features/chat/domain/entities/attachment_type.dart';
import 'package:cliniq/features/chat/presentation/widgets/attachment_picker_sheet.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

class AiScanUploadScreen extends ConsumerWidget {
  const AiScanUploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.aiScanAnalysisTitle.tr()),
        centerTitle: true,
      ),
      body: const AiScanUploadBody(),
      floatingActionButton: _buildFloatingButton(context, ref),
    );
  }

  Widget? _buildFloatingButton(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiScanUploadProvider);

    if (state is AiScanUploadInitial) {
      return FloatingActionButton.extended(
        onPressed: () => _pickModality(context, ref),
        icon: const Icon(Icons.add_photo_alternate_rounded),
        label: Text(LocaleKeys.aiChatAttachmentScan.tr()),
      );
    }

    return null;
  }

  void _pickModality(BuildContext context, WidgetRef ref) {
    AttachmentPickerSheet.show(
      context,
      onTypeSelected: (AttachmentType type) {
        final modality = type.modalityValue;
        if (modality == null) return;
        _pickFile(context, ref, modality, type.extensions);
      },
    );
  }

  Future<void> _pickFile(
    BuildContext context,
    WidgetRef ref,
    String modality,
    List<String> extensions,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
    );

    if (result == null || result.files.isEmpty) return;
    final path = result.files.first.path;
    if (path == null) return;

    final file = File(path);
    final bytes = await file.readAsBytes();
    final base64 = base64Encode(bytes);
    final patientId = ref.read(currentUserProvider)?.id;

    if (patientId == null) return;

    ref.read(aiScanUploadProvider.notifier).analyzeScan(
          imageBase64: base64,
          patientId: patientId,
          modality: modality,
        );
  }
}
