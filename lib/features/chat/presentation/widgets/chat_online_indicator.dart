import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatOnlineIndicator extends StatelessWidget {
  const ChatOnlineIndicator({super.key, required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    if (!isOnline) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 13.w,
      height: 13.w,
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        shape: BoxShape.circle,
        border: Border.all(color: context.colorScheme.surface, width: 2.w),
      ),
    );
  }
}
