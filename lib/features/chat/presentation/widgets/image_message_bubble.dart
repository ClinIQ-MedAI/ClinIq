import 'package:cliniq/core/helpers/image_source_resolver.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cliniq/features/chat/presentation/widgets/full_screen_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageMessageBubble extends StatelessWidget {
  const ImageMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  final ChatMessageEntity message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final failed = message.status == ChatMessageStatus.failed;

    return GestureDetector(
      onTap: failed ? null : () => _openViewer(context),
      child: Hero(
        tag: 'chat-image-${message.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: SizedBox(
            width: 240.w,
            child: buildImageWidget(
              url: message.resolvedAttachmentUrl,
              localFilePath: message.localFilePath,
              fit: BoxFit.cover,
              placeholderBuilder: (_, __) => _placeholder(scheme),
              errorBuilder: (_, __, ___) => _errorPlaceholder(scheme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme scheme) {
    return Container(
      height: 200.h,
      color: scheme.surfaceContainerHigh,
      child: Center(
        child: CircularProgressIndicator(
          color: scheme.primary,
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _errorPlaceholder(ColorScheme scheme) {
    return Container(
      height: 200.h,
      color: scheme.surfaceContainerHigh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 36.sp,
            color: scheme.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(height: 6.h),
          Text(
            'Unable to load image',
            style: AppTextStyles.getTextStyle(11).copyWith(
              color: scheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _openViewer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullScreenImageViewer(
          message: message,
        ),
      ),
    );
  }
}
