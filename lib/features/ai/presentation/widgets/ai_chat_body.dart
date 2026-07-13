import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/data/models/scan_analysis_model.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_chat_provider.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_scan_upload_provider.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_chat_suggested_prompts.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_upload_request_card.dart';
import 'package:cliniq/features/chat/domain/entities/attachment_type.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/presentation/providers/attachment_provider.dart';
import 'package:cliniq/features/chat/presentation/widgets/attachment_picker_sheet.dart';
import 'package:cliniq/features/chat/presentation/widgets/attachment_preview_widget.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_header.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_message_list.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiChatBody extends ConsumerWidget {
  const AiChatBody({
    super.key,
    required this.conversation,
    required this.uploadState,
    required this.showUpload,
  });
  final ChatConversationEntity conversation;
  final AttachmentUploadState uploadState;
  final bool showUpload;

  void _handleAttachmentTap(BuildContext context, WidgetRef ref) {
    AttachmentPickerSheet.show(
      context,
      onTypeSelected: (AttachmentType type) {
        ref.read(attachmentUploadProvider.notifier).pickAttachment(type);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const VerticalGap(18),
        ChatHeader(conversation: conversation).animate().fadeIn(),
        const VerticalGap(8),
        Expanded(
          child: ChatMessageList(
            conversation: conversation,
            onMessageRetry: (messageId) {
              ref.read(aiChatProvider.notifier).retryFailedAi(messageId);
            },
            onUploadAnother: () => _handleAttachmentTap(context, ref),
          ),
        ),
        if (conversation.messages.isEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: AiChatSuggestedPrompts(
              onPromptTapped: (prompt) {
                ref.read(aiChatProvider.notifier).sendMessage(prompt);
              },
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.08),
          ),
        if (showUpload)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ).copyWith(bottom: 12.h),
            child: AiUploadRequestCard(
              onUploadTap: () => _handleAttachmentTap(context, ref),
            ).animate().fadeIn().slideY(begin: 0.1),
          ),
        if (uploadState.hasAttachment)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: AttachmentPreviewWidget(
              fileName: uploadState.fileName ?? '',
              filePath: uploadState.localFilePath!,
              isUploading: uploadState.isUploading,
              fileSize: uploadState.fileSize,
              onRemove: () => ref
                  .read(attachmentUploadProvider.notifier)
                  .removeAttachment(),
            ),
          ),
        ChatInputField(
          bottomSpacing: 28,
          onMessageSubmitted: (text) async {
            if (uploadState.hasAttachment) {
              final filePath = uploadState.localFilePath;
              final modality = uploadState.selectedModality;
              final attachmentName = uploadState.fileName;
              final attachmentSize = uploadState.fileSize;
              if (filePath == null || modality == null) return;

              final patientId = ref.read(currentUserProvider)?.id;
              if (patientId == null) return;

              final file = File(filePath);
              final bytes = await file.readAsBytes();
              final base64 = base64Encode(bytes);

              final ts = DateTime.now();
              final sentAt =
                  '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}';
              final userMsgId = 'scan-user-${ts.microsecondsSinceEpoch}';
              final loadingId = 'scan-loading-${ts.microsecondsSinceEpoch}';

              final notifier = ref.read(aiChatProvider.notifier);

              notifier.addMessage(
                ChatMessageEntity(
                  id: userMsgId,
                  content: '',
                  sentAt: sentAt,
                  sender: ChatMessageSender.user,
                  status: ChatMessageStatus.sent,
                  localFilePath: filePath,
                  attachmentName: attachmentName,
                  attachmentSize: attachmentSize,
                ),
              );

              notifier.addMessage(
                ChatMessageEntity(
                  id: loadingId,
                  content: '',
                  sentAt: sentAt,
                  sender: ChatMessageSender.ai,
                  status: ChatMessageStatus.loading,
                ),
              );

              ref.read(attachmentUploadProvider.notifier).resetAfterSend();

              log('AiChatBody: calling analyzeScan...');
              final analysis = await ref
                  .read(aiScanUploadProvider.notifier)
                  .analyzeScan(
                    imageBase64: base64,
                    patientId: patientId,
                    modality: modality,
                  );

              if (analysis != null) {
                if (analysis.isRejected) {
                  log(
                    'AiChatBody: analysis REJECTED — urgency=${analysis.urgency}',
                  );
                  final rejectionJson = jsonEncode({
                    '__type': 'rejected_scan',
                    'summary': analysis.summary,
                    'recommendations': analysis.recommendations,
                  });
                  log('AiChatBody: rejection JSON: $rejectionJson');
                  notifier.updateMessage(
                    loadingId,
                    content: rejectionJson,
                    status: ChatMessageStatus.seen,
                  );
                } else {
                  log(
                    'AiChatBody: analysis returned, id="${analysis.id}"',
                  );
                  final model = analysis is ScanAnalysisModel
                      ? analysis
                      : ScanAnalysisModel(
                          id: analysis.id,
                          findings: analysis.findings,
                          modality: analysis.modality,
                          status: analysis.status,
                          createdAt: analysis.createdAt,
                          imageUrl: analysis.imageUrl,
                          patientId: analysis.patientId,
                          urgency: analysis.urgency,
                          summary: analysis.summary,
                          recommendations: analysis.recommendations,
                          scanBase64: analysis.scanBase64,
                          scanUrl: analysis.scanUrl,
                          annotatedImageBase64:
                              analysis.annotatedImageBase64,
                          primaryDiagnosis: analysis.primaryDiagnosis,
                          confidence: analysis.confidence,
                          severity: analysis.severity,
                          patientContext: analysis.patientContext,
                          bodyPart: analysis.bodyPart,
                          clinicalMeaning: analysis.clinicalMeaning,
                          allProbabilities: analysis.allProbabilities,
                          findingsList: analysis.findingsList,
                          inputGate: analysis.inputGate,
                          aiJobId: analysis.aiJobId,
                        );
                  final jsonMap = model.toJson();
                  jsonMap['__type'] = 'analysis_result';
                  final resultJson = jsonEncode(jsonMap);
                  log(
                    'AiChatBody: storing analysis result JSON (${resultJson.length} chars)',
                  );
                  notifier.updateMessage(
                    loadingId,
                    content: resultJson,
                    status: ChatMessageStatus.seen,
                  );
                }
                if (context.mounted) {
                  Navigator.pushNamed(
                    context,
                    Routes.aiAnalysisResultScreen,
                    arguments: analysis,
                  );
                }
              } else {
                log('AiChatBody: analysis is null');
                final errorState = ref.read(aiScanUploadProvider);
                final errorMsg = errorState is AiScanUploadError
                    ? errorState.message
                    : 'Analysis failed';
                log('AiChatBody: showing error="$errorMsg"');
                notifier.updateMessage(
                  loadingId,
                  content: errorMsg,
                  status: ChatMessageStatus.failed,
                );
              }
            } else {
              ref.read(aiChatProvider.notifier).sendMessage(text);
            }
          },
          onTypingChanged: (_) {},
          onAttachmentTap: () => _handleAttachmentTap(context, ref),
          hasAttachment: uploadState.hasAttachment,
          isSendDisabled: uploadState.isUploading,
        ),
      ],
    );
  }
}
