import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_header_style_1.dart';
import 'package:flutter/material.dart';

class ChatHeaderBuilder extends StatelessWidget {
  const ChatHeaderBuilder({super.key, required this.conversation});

  final ChatConversationEntity conversation;

  @override
  Widget build(BuildContext context) {
    return ChatHeaderStyle1(conversation: conversation);
  }
}
