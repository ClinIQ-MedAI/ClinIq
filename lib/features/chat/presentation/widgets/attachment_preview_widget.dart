import 'dart:io';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttachmentPreviewWidget extends StatelessWidget {
  const AttachmentPreviewWidget({
    super.key,
    required this.fileName,
    required this.filePath,
    this.isUploading = false,
    required this.onRemove,
    this.fileSize,
  });

  final String fileName;
  final String filePath;
  final bool isUploading;
  final VoidCallback onRemove;
  final int? fileSize;

  bool get isImage {
    final ext = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(ext);
  }

  bool get isDicom {
    final ext = fileName.split('.').last.toLowerCase();
    return ext == 'dcm';
  }

  IconData get _icon {
    if (isDicom) return Icons.medical_services_rounded;
    if (fileName.endsWith('.pdf')) return Icons.picture_as_pdf_rounded;
    return Icons.insert_drive_file_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = isDicom
        ? context.colorScheme.primary
        : fileName.endsWith('.pdf')
            ? context.colorScheme.error
            : context.colorScheme.primary;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.file(
                File(filePath),
                width: 44.w,
                height: 44.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildIcon(context, iconColor),
              ),
            )
          else
            _buildIcon(context, iconColor),
          const HorizontalGap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fileName,
                  style: AppTextStyles.getTextStyle(13).copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.textPalette.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (fileSize != null) ...[
                  const VerticalGap(2),
                  Text(
                    _formatSize(fileSize!),
                    style: AppTextStyles.getTextStyle(11).copyWith(
                      color: context.textPalette.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (isUploading) ...[
                  const VerticalGap(6),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1200),
                    builder: (context, value, _) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor:
                            context.colorScheme.primary.withValues(alpha: 0.1),
                        color: context.colorScheme.primary,
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(2),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          if (!isUploading)
            InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: context.colorScheme.error,
                  size: 18.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, Color iconColor) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(_icon, color: iconColor, size: 22.sp),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
