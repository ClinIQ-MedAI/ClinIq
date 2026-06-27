import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_conversation_provider.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_header.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_loading_state.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_message_list.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatConversationView extends ConsumerWidget {
  const ChatConversationView({super.key, required this.type});

  final ChatType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationAsync = ref.watch(chatConversationProvider(type));

    return conversationAsync.when(
      data: (conversation) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: ProfileAppBar(title: conversation.title, showBackButton: false),
        body: Column(
          children: [
            const VerticalGap(18),
            ChatHeader(
              conversation: conversation,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.1),
            const VerticalGap(8),
            Expanded(child: ChatMessageList(conversation: conversation)),
            const ChatInputField(),
          ],
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
