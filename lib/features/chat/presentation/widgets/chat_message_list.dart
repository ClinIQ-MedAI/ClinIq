import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_date_separator.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_empty_state.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key, required this.conversation});

  final ChatConversationEntity conversation;

  @override
  Widget build(BuildContext context) {
    if (conversation.messages.isEmpty) {
      return ChatEmptyState(conversation: conversation);
    }

    return ListView.separated(
      reverse: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 24.h),
      itemCount: conversation.messages.length + 1,
      separatorBuilder: (context, index) => const VerticalGap(14),
      itemBuilder: (context, index) {
        if (index == conversation.messages.length) {
          return const Center(
            child: ChatDateSeparator(title: LocaleKeys.chatToday),
          );
        }

        final message =
            conversation.messages[conversation.messages.length - index - 1];

        return ChatMessageBubble(
          message: message,
        ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.08);
      },
    );
  }
}
