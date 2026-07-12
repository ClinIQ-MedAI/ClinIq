import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewConversationButton extends StatelessWidget {
  const NewConversationButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w, bottom: 8.h),
      child: Material(
        color: context.colorScheme.onPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Icon(
              Icons.add_comment_rounded,
              color: context.colorScheme.onPrimary,
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
