import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessageStatusIcon extends StatelessWidget {
  const ChatMessageStatusIcon({super.key, required this.status});

  final ChatMessageStatus status;

  @override
  Widget build(BuildContext context) {
    final icon = switch (status) {
      ChatMessageStatus.sending => Icons.schedule_rounded,
      ChatMessageStatus.sent => Icons.done_rounded,
      ChatMessageStatus.delivered => Icons.done_all_rounded,
      ChatMessageStatus.seen => Icons.done_all_rounded,
      ChatMessageStatus.failed => Icons.error_outline_rounded,
    };

    return Icon(
      icon,
      size: 14.sp,
      color: context.colorScheme.onPrimary.withValues(
        alpha: status == ChatMessageStatus.seen ? 0.95 : 0.7,
      ),
    );
  }
}
