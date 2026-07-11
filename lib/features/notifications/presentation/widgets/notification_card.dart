import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationEntity notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: isUnread
                ? context.colorScheme.primary.withValues(alpha: 0.06)
                : context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isUnread
                  ? context.colorScheme.primary.withValues(alpha: 0.12)
                  : context.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isUnread)
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              if (isUnread) HorizontalGap(12.w),
              if (!isUnread) SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: AppTextStyles.getTextStyle(14).copyWith(
                        fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                        color: context.textPalette.primaryColor,
                      ),
                    ),
                    const VerticalGap(4),
                    Text(
                      notification.body,
                      style: AppTextStyles.getTextStyle(12).copyWith(
                        color: context.textPalette.secondaryColor,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const VerticalGap(8),
                    Text(
                      notification.createdAt,
                      style: AppTextStyles.getTextStyle(11).copyWith(
                        color: context.textPalette.secondaryColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isUnread)
                Container(
                  margin: EdgeInsets.only(left: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    LocaleKeys.notificationsNew.tr(),
                    style: AppTextStyles.getTextStyle(10).copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms),
      ),
    );
  }
}

class HorizontalGap extends StatelessWidget {
  const HorizontalGap(this.width, {super.key});
  final double width;
  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
