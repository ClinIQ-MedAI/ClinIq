import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_chat_provider.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_scan_upload_provider.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_chat_body.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiChatScreen extends ConsumerWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationAsync = ref.watch(aiChatProvider);
    final uploadState = ref.watch(aiScanUploadProvider);
    final showUpload = ref.watch(aiShowUploadRequestProvider);

    return conversationAsync.when(
      data: (conversation) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: ProfileAppBar(title: conversation.title, showBackButton: true),
        body: AiChatBody(
          conversation: conversation,
          uploadState: uploadState,
          showUpload: showUpload,
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: ProfileAppBar(title: LocaleKeys.aiChatTitle),
        body: Center(
          child: Text(LocaleKeys.messagesFailuresUnexpectedError.tr()),
        ),
      ),
      loading: () => Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: ProfileAppBar(title: LocaleKeys.aiChatTitle),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
