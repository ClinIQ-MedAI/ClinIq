import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_chat_provider.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_conversation_body.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_loading_state.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiChatScreen extends ConsumerWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationAsync = ref.watch(aiChatProvider);

    return conversationAsync.when(
      data: (conversation) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: ProfileAppBar(
          title: conversation.title,
          showBackButton: true,
        ),
        body: ChatConversationBody(
          conversation: conversation,
          onMessageSubmitted: ref.read(aiChatProvider.notifier).sendMessage,
          onTypingChanged: (_) {},
          inputBottomSpacing: 28,
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: const ProfileAppBar(title: LocaleKeys.chatAiTitle),
        body: Center(
          child: Text(LocaleKeys.messagesFailuresUnexpectedError.tr()),
        ),
      ),
      loading: () => Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: const ProfileAppBar(title: LocaleKeys.chatAiTitle),
        body: const ChatLoadingState(),
      ),
    );
  }
}
