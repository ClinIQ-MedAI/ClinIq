import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatLoadingState extends StatelessWidget {
  const ChatLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = context.colorScheme.onSurface.withValues(alpha: 0.05);

    return SafeArea(
      child: Column(
        children: [
          // Header Skeleton
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: shimmerColor),
                ),
                const HorizontalGap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14.h, width: 120.w, color: shimmerColor),
                      const VerticalGap(6),
                      Container(height: 10.h, width: 80.w, color: shimmerColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: context.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          // Messages Skeleton
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(24.w),
              itemCount: 4,
              itemBuilder: (context, index) {
                final isUser = index % 2 == 0;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: isUser ? 200.w : 150.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                        bottomLeft: Radius.circular(isUser ? 24.r : 8.r),
                        bottomRight: Radius.circular(isUser ? 8.r : 24.r),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ).animate(onPlay: (controller) => controller.repeat()).shimmer(
            duration: 1500.ms,
            color: context.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
    );
  }
}
