import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorActionButtons extends StatelessWidget {
  const DoctorActionButtons({
    super.key,
    required this.onViewProfile,
    required this.onChat,
  });

  final VoidCallback onViewProfile;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onViewProfile,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              side: BorderSide(
                color: scheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              LocaleKeys.homeViewProfile.tr(),
              style: AppTextStyles.getTextStyle(13).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: FilledButton.icon(
            onPressed: onChat,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: Text(
              LocaleKeys.homeStartChat.tr(),
              style: AppTextStyles.getTextStyle(13).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
