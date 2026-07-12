import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiChatAttachmentPicker extends StatelessWidget {
  const AiChatAttachmentPicker({
    super.key,
    required this.onScanSelected,
    required this.onPrescriptionSelected,
  });

  final VoidCallback onScanSelected;
  final VoidCallback onPrescriptionSelected;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onScanSelected,
    required VoidCallback onPrescriptionSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: context.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) => AiChatAttachmentPicker(
        onScanSelected: () {
          Navigator.pop(context);
          onScanSelected();
        },
        onPrescriptionSelected: () {
          Navigator.pop(context);
          onPrescriptionSelected();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          const VerticalGap(24),
          Text(
            LocaleKeys.aiChatAttachmentPickerTitle.tr(),
            style: AppTextStyles.getTextStyle(20).copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPalette.primaryColor,
              letterSpacing: -0.5,
            ),
          ),
          const VerticalGap(24),
          Row(
            children: [
              Expanded(
                child: _AttachmentOption(
                  icon: Icons.medical_services_rounded,
                  title: LocaleKeys.aiChatAttachmentScan.tr(),
                  onTap: onScanSelected,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _AttachmentOption(
                  icon: Icons.description_rounded,
                  title: LocaleKeys.aiChatAttachmentPrescription.tr(),
                  onTap: onPrescriptionSelected,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  const _AttachmentOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
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
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 12.w),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: context.colorScheme.primary,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: AppTextStyles.getTextStyle(14).copyWith(
                fontWeight: FontWeight.w700,
                color: context.textPalette.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
