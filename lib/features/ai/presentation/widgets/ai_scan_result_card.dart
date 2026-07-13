import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class AiScanResultCard extends StatelessWidget {
  const AiScanResultCard({super.key, required this.analysis});

  final ScanAnalysisEntity analysis;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.aiScanAnalysisTitle.tr(),
            style: AppTextStyles.getTextStyle(
              22,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          const VerticalGap(8),
          _infoRow(
            context,
            LocaleKeys.aiScanStatus.tr(),
            analysis is AIAnalysisRejectedEntity
                ? LocaleKeys.aiScanResultFailed.tr()
                : LocaleKeys.aiScanResultPassed.tr(),
          ),
          const VerticalGap(20),
          Text(
            LocaleKeys.aiScanResultSummary.tr(),
            style: AppTextStyles.getTextStyle(
              16,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          const VerticalGap(8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: context.colorScheme.outlineVariant.withValues(
                  alpha: 0.3,
                ),
              ),
            ),
            child: Text(
              analysis.summary.isNotEmpty
                  ? analysis.summary
                  : LocaleKeys.aiScanNoFindings.tr(),
              style: AppTextStyles.getTextStyle(14).copyWith(height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: AppTextStyles.getTextStyle(
            13,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          value.isNotEmpty ? value : '-',
          style: AppTextStyles.getTextStyle(13),
        ),
      ],
    );
  }
}
