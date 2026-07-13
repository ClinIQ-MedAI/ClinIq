import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/probability_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/analysis_section_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAnalysisSuccessDetections extends StatelessWidget {
  const AiAnalysisSuccessDetections({
    super.key,
    required this.detections,
    this.isExpandable = true,
  });

  final List<ProbabilityEntity> detections;
  final bool isExpandable;

  @override
  Widget build(BuildContext context) {
    if (detections.isEmpty) return const SizedBox.shrink();

    final sorted = List.of(detections)
      ..sort((a, b) => b.value.compareTo(a.value));
    final scheme = context.colorScheme;

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultDetections.tr(),
      icon: Icons.radar_rounded,
      child: isExpandable && sorted.length > 3
          ? ExpansionTile(
              tilePadding: EdgeInsets.zero,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              initiallyExpanded: false,
              childrenPadding: EdgeInsets.only(top: 8.h),
              title: Text(
                '${sorted.length} ${LocaleKeys.aiScanResultMetrics.tr()}',
                style: AppTextStyles.getTextStyle(12).copyWith(
                  color: context.textPalette.secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              children: sorted.map((d) => _detectionRow(d, scheme, context)).toList(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sorted.map((d) => _detectionRow(d, scheme, context)).toList(),
            ),
    );
  }

  Widget _detectionRow(
    ProbabilityEntity detection,
    ColorScheme scheme,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  detection.label,
                  style: AppTextStyles.getTextStyle(13).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const HorizontalGap(8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '${(detection.value * 100).toStringAsFixed(1)}%',
                  style: AppTextStyles.getTextStyle(12).copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const VerticalGap(4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: detection.value.clamp(0.0, 1.0),
              minHeight: 5.h,
              backgroundColor: scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                detection.value > 0.7
                    ? const Color(0xFFE53935)
                    : detection.value > 0.4
                        ? const Color(0xFFFF9800)
                        : scheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}