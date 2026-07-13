import 'dart:io';

import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfMessageBubble extends StatelessWidget {
  const PdfMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  final ChatMessageEntity message;
  final bool isUser;

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get _isUploading =>
      message.status == ChatMessageStatus.sending;

  bool get _isUploaded =>
      message.status == ChatMessageStatus.sent ||
      message.status == ChatMessageStatus.seen ||
      message.status == ChatMessageStatus.delivered;

  Future<void> _openFile(BuildContext context) async {
    final filePath = message.localFilePath;
    if (filePath != null && await File(filePath).exists()) {
      try {
        if (Platform.isWindows) {
          await Process.run('cmd', ['/c', 'start', '', filePath]);
        } else if (Platform.isMacOS) {
          await Process.run('open', [filePath]);
        } else if (Platform.isLinux) {
          await Process.run('xdg-open', [filePath]);
        }
        return;
      } catch (_) {}
    }

    final remoteUrl = message.resolvedAttachmentUrl;
    if (remoteUrl.isNotEmpty) {
      try {
        if (Platform.isWindows) {
          await Process.run('cmd', ['/c', 'start', '', remoteUrl]);
        } else if (Platform.isMacOS) {
          await Process.run('open', [remoteUrl]);
        } else if (Platform.isLinux) {
          await Process.run('xdg-open', [remoteUrl]);
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final textClr = isUser ? scheme.onPrimary : context.textPalette.primaryColor;
    final mutedClr = isUser
        ? scheme.onPrimary.withValues(alpha: 0.65)
        : scheme.onSurface.withValues(alpha: 0.55);

    final failed = message.status == ChatMessageStatus.failed;

    return InkWell(
      onTap: failed ? null : () => _openFile(context),
      borderRadius: BorderRadius.circular(22.r),
      splashColor: scheme.primary.withValues(alpha: 0.08),
      highlightColor: scheme.primary.withValues(alpha: 0.04),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: failed
              ? scheme.errorContainer.withValues(alpha: 0.25)
              : isUser
                  ? scheme.onPrimary.withValues(alpha: 0.08)
                  : scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: failed
                ? scheme.error.withValues(alpha: 0.4)
                : scheme.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pdfIcon(scheme),
                const HorizontalGap(12),
                Expanded(child: _fileInfo(scheme, textClr, mutedClr)),
                const HorizontalGap(8),
                _openButton(scheme),
              ],
            ),
            const VerticalGap(10),
            _statusRow(scheme, mutedClr),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.08, duration: 250.ms).scale(
      begin: const Offset(0.97, 0.97),
      end: const Offset(1, 1),
      duration: 250.ms,
    );
  }

  Widget _pdfIcon(ColorScheme scheme) {
    return Container(
      width: 52.r,
      height: 52.r,
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(
        Icons.picture_as_pdf_rounded,
        size: 30.sp,
        color: const Color(0xFFE53935),
      ),
    );
  }

  Widget _fileInfo(ColorScheme scheme, Color textClr, Color mutedClr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message.attachmentDisplayName,
          style: AppTextStyles.getTextStyle(13).copyWith(
            color: textClr,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (message.attachmentSize != null) ...[
          const VerticalGap(2),
          Text(
            _formatSize(message.attachmentSize!),
            style: AppTextStyles.getTextStyle(11).copyWith(
              color: mutedClr,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _openButton(ColorScheme scheme) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.visibility_rounded,
        size: 18.sp,
        color: scheme.primary,
      ),
    );
  }

  Widget _statusRow(ColorScheme scheme, Color mutedClr) {
    if (_isUploading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14.sp,
            height: 14.sp,
            child: CircularProgressIndicator(
              strokeWidth: 1.8,
              color: scheme.primary,
            ),
          ),
          const HorizontalGap(6),
          Text(
            'Uploading...',
            style: AppTextStyles.getTextStyle(10).copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (_isUploaded) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14.sp,
            color: const Color(0xFF4CAF50),
          ),
          const HorizontalGap(6),
          Text(
            'Uploaded',
            style: AppTextStyles.getTextStyle(10).copyWith(
              color: const Color(0xFF4CAF50),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
