import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatIconButton extends StatelessWidget {
  const ChatIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(18.r),
      child: Opacity(
        opacity: onPressed != null ? 1.0 : 0.4,
        child: Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: isPrimary
                ? context.colorScheme.primary
                : context.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Icon(
            icon,
            color: isPrimary
                ? context.colorScheme.onPrimary
                : context.colorScheme.primary,
            size: 21.sp,
          ),
        ),
      ),
    );
  }
}
