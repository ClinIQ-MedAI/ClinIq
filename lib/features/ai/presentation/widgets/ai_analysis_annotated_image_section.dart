import 'dart:convert';

import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAnalysisAnnotatedImageSection extends StatelessWidget {
  const AiAnalysisAnnotatedImageSection({
    super.key,
    required this.annotatedImageBase64,
  });

  final String annotatedImageBase64;

  @override
  Widget build(BuildContext context) {
    if (annotatedImageBase64.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.aiScanResultAiAnnotation.tr(),
            style: AppTextStyles.getTextStyle(14).copyWith(
              color: context.textPalette.primaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const VerticalGap(12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Image.memory(
              base64Decode(annotatedImageBase64),
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.broken_image_outlined,
                color: context.colorScheme.error,
                size: 40.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
