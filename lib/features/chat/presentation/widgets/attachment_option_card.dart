import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/chat/domain/entities/attachment_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttachmentOptionCard extends StatelessWidget {
  const AttachmentOptionCard({
    super.key,
    required this.type,
    required this.onTap,
  });

  final AttachmentType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: context.colorScheme.primary.withValues(alpha: 0.08),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                type.icon,
                color: context.colorScheme.primary,
                size: 26.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              type.titleKey.tr(),
              style: AppTextStyles.getTextStyle(12).copyWith(
                fontWeight: FontWeight.w700,
                color: context.textPalette.primaryColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              type.descriptionKey.tr(),
              style: AppTextStyles.getTextStyle(9).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
