import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_message_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FileMessageBubble extends StatelessWidget {
  const FileMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  final ChatMessageEntity message;
  final bool isUser;

  IconData get _fileIcon {
    if (message.attachmentUrl == null) return Icons.insert_drive_file_rounded;
    final ext = message.attachmentName?.split('.').last.toLowerCase() ??
        message.attachmentUrl!.split('.').last.toLowerCase();
    if (ext == 'dcm') return Icons.medical_services_rounded;
    if (ext == 'pdf') return Icons.picture_as_pdf_rounded;
    return Icons.insert_drive_file_rounded;
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final failed = message.status == ChatMessageStatus.failed;
    final textClr = isUser ? scheme.onPrimary : scheme.onSurface;
    final mutedClr = isUser
        ? scheme.onPrimary.withValues(alpha: 0.6)
        : scheme.onSurface.withValues(alpha: 0.6);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: failed
            ? scheme.errorContainer.withValues(alpha: 0.3)
            : isUser
                ? scheme.onPrimary.withValues(alpha: 0.08)
                : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14.r),
        border: failed
            ? Border.all(
                color: scheme.error.withValues(alpha: 0.5),
                width: 1.2,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                failed ? Icons.error_outline_rounded : _fileIcon,
                size: 28.sp,
                color: failed
                    ? scheme.error
                    : (isUser ? scheme.onPrimary : scheme.primary),
              ),
              const HorizontalGap(10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.attachmentDisplayName,
                      style: AppTextStyles.getTextStyle(12).copyWith(
                        color: failed ? scheme.error : textClr,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (message.attachmentSize != null) ...[
                      const VerticalGap(2),
                      Text(
                        _formatSize(message.attachmentSize!),
                        style: AppTextStyles.getTextStyle(10).copyWith(
                          color: failed
                              ? scheme.error.withValues(alpha: 0.7)
                              : mutedClr,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const VerticalGap(6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.sentAt,
                style: AppTextStyles.getTextStyle(10).copyWith(
                  color: failed
                      ? scheme.error.withValues(alpha: 0.7)
                      : mutedClr,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isUser) ...[
                const HorizontalGap(4),
                ChatMessageStatusIcon(status: message.status),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
