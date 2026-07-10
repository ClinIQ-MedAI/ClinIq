import 'package:cliniq/core/helpers/image_source_resolver.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullScreenImageViewer extends StatefulWidget {
  const FullScreenImageViewer({super.key, required this.message});

  final ChatMessageEntity message;

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  final TransformationController _transformController =
      TransformationController();
  double _dragOffset = 0;
  bool _dismissing = false;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _onScaleEnd(ScaleEndDetails details) {
    final scale = _transformController.value.getMaxScaleOnAxis();
    if (scale < 1) {
      _transformController.value = Matrix4.identity();
    }
  }

  void _onDoubleTap() {
    final scale = _transformController.value.getMaxScaleOnAxis();
    if (scale > 1.1) {
      _transformController.value = Matrix4.identity();
    } else {
      _transformController.value = Matrix4.diagonal3Values(3, 3, 3);
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
      if (_dragOffset > 0) _dismissing = true;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_dragOffset > 150) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _dragOffset = 0;
        _dismissing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Scaffold(
      backgroundColor: _dismissing
          ? Colors.black.withValues(
              alpha: (1 - (_dragOffset / 300)).clamp(0, 1))
          : Colors.black,
      body: GestureDetector(
        onDoubleTap: _onDoubleTap,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: _dismissing
                ? (Matrix4.diagonal3Values(
                        1 - (_dragOffset / 1200).clamp(0, 0.3),
                        1 - (_dragOffset / 1200).clamp(0, 0.3),
                        1)
                  ..setTranslationRaw(0, _dragOffset, 0))
                : Matrix4.identity(),
            child: Hero(
              tag: 'chat-image-${widget.message.id}',
              child: InteractiveViewer(
                transformationController: _transformController,
                maxScale: 5,
                minScale: 1,
                onInteractionEnd: _onScaleEnd,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: buildImageWidget(
                    url: widget.message.resolvedAttachmentUrl,
                    localFilePath: widget.message.localFilePath,
                    fit: BoxFit.contain,
                    placeholderBuilder: (_, __) => Center(
                      child: CircularProgressIndicator(color: scheme.primary),
                    ),
                    errorBuilder: (_, __, ___) => _errorPlaceholder(scheme),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorPlaceholder(ColorScheme scheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image_outlined, size: 48.sp, color: Colors.white54),
        SizedBox(height: 12.h),
        Text(
          'Unable to load image',
          style: AppTextStyles.getTextStyle(14).copyWith(
            color: Colors.white54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
