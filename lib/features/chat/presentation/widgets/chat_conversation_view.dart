import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_conversation_provider.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_conversation_body.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_loading_state.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatConversationView extends ConsumerWidget {
  const ChatConversationView({
    super.key,
    required this.type,
    this.showBackButton = true,
  });

  final ChatType type;
  final bool showBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ChatConversationRequest.byType(type);
    final conversationAsync = ref.watch(chatConversationProvider(request));

    return conversationAsync.when(
      data: (conversation) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: ProfileAppBar(
          title: conversation.title,
          showBackButton: showBackButton,
        ),
        body: ChatConversationBody(
          conversation: conversation,
          onMessageSubmitted: ref
              .read(chatConversationProvider(request).notifier)
              .sendMessage,
          onTypingChanged: ref
              .read(chatConversationProvider(request).notifier)
              .updateTypingStatus,
          inputBottomSpacing: 28,
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Center(
          child: Text(LocaleKeys.messagesFailuresUnexpectedError.tr()),
        ),
      ),
      loading: () => Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: const ChatLoadingState(),
      ),
    );
  }
}
