import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatUnreadBadge extends StatelessWidget {
  const ChatUnreadBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: BoxConstraints(minWidth: 22.w, minHeight: 22.w),
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colorScheme.error,
        shape: BoxShape.circle,
      ),
      child: Text(
        count.toString(),
        style: AppTextStyles.getTextStyle(11).copyWith(
          color: context.colorScheme.onError,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
