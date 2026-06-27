import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({super.key, required this.type, this.size = 48});

  final ChatType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isAi = type == ChatType.ai;

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color:
            (isAi ? context.colorScheme.secondary : context.colorScheme.primary)
                .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color:
              (isAi
                      ? context.colorScheme.secondary
                      : context.colorScheme.primary)
                  .withValues(alpha: 0.18),
        ),
      ),
      child: Icon(
        isAi ? Icons.auto_awesome_rounded : Icons.medical_services_rounded,
        color: isAi
            ? context.colorScheme.secondary
            : context.colorScheme.primary,
        size: (size * 0.5).sp,
      ),
    );
  }
}
