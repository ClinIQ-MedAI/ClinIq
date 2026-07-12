import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiChatSuggestedPrompts extends StatelessWidget {
  const AiChatSuggestedPrompts({super.key, required this.onPromptTapped});

  final ValueChanged<String> onPromptTapped;

  static const _prompts = [
    LocaleKeys.aiChatPromptHeadache,
    LocaleKeys.aiChatPromptAnalyzeScan,
    LocaleKeys.aiChatPromptExplainPrescription,
    LocaleKeys.aiChatPromptToothPain,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Text(
            LocaleKeys.aiChatSuggestedPromptsTitle.tr(),
            style: AppTextStyles.getTextStyle(13).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const VerticalGap(12),
          ...List.generate(_prompts.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _PromptChip(
                label: _prompts[index],
                onTap: () => onPromptTapped(_prompts[index].tr()),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: context.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: context.colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.arrow_outward_rounded,
              size: 16.sp,
              color: context.colorScheme.primary,
            ),
            const HorizontalGap(12),
            Expanded(
              child: Text(
                label.tr(),
                style: AppTextStyles.getTextStyle(13).copyWith(
                  color: context.textPalette.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
