import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_header.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatConversationBody extends StatelessWidget {
  const ChatConversationBody({
    super.key,
    required this.conversation,
    this.inputBottomSpacing = 16,
  });

  final ChatConversationEntity conversation;
  final double inputBottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VerticalGap(18),
        ChatHeader(
          conversation: conversation,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.1),
        const VerticalGap(8),
        Expanded(child: ChatMessageList(conversation: conversation)),
        ChatInputField(bottomSpacing: inputBottomSpacing),
      ],
    );
  }
}
