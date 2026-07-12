import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiUploadRequestCard extends StatelessWidget {
  const AiUploadRequestCard({super.key, required this.onUploadTap});

  final VoidCallback onUploadTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: context.colorScheme.secondary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.colorScheme.secondary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_upload_rounded,
                  color: context.colorScheme.secondary,
                  size: 22.sp,
                ),
              ),
              const HorizontalGap(12),
              Expanded(
                child: Text(
                  LocaleKeys.aiChatUploadRequestTitle.tr(),
                  style: AppTextStyles.getTextStyle(15).copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.textPalette.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const VerticalGap(10),
          Text(
            LocaleKeys.aiChatUploadRequestDescription.tr(),
            style: AppTextStyles.getTextStyle(13).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const VerticalGap(16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onUploadTap,
              icon: Icon(Icons.add_rounded, size: 18.sp),
              label: Text(LocaleKeys.aiChatUploadRequestButton.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.secondary,
                foregroundColor: context.colorScheme.onSecondary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
