import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_info_grid.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_success_detections.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_text_section.dart';
import 'package:cliniq/features/ai/presentation/widgets/analysis_section_card.dart';
import 'package:cliniq/features/ai/presentation/widgets/scan_image_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAnalysisRejectedBody extends StatelessWidget {
  const AiAnalysisRejectedBody({super.key, required this.analysis});

  final AIAnalysisRejectedEntity analysis;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      children: [
        _buildWarningHeader(context, scheme),
        const VerticalGap(12),
        _buildScanImage(context),
        const VerticalGap(12),
        _buildValidationErrorCard(context, scheme),
        const VerticalGap(12),
        _buildScanInformation(context),
        const VerticalGap(12),
        AiAnalysisTextSection(
          title: LocaleKeys.aiScanResultSummary.tr(),
          value: analysis.summary,
          icon: Icons.info_outline_rounded,
        ),
        if (analysis.recommendations.isNotEmpty) ...[
          const VerticalGap(12),
          _buildRecommendations(context, scheme),
        ],
        if (analysis.detections.isNotEmpty) ...[
          const VerticalGap(12),
          AiAnalysisSuccessDetections(detections: analysis.detections),
        ],
        const VerticalGap(12),
        _buildInputDetails(context),
      ],
    );
  }

  Widget _buildWarningHeader(BuildContext context, ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: scheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: scheme.error.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: scheme.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: scheme.error,
                  size: 24.sp,
                ),
              ),
              const HorizontalGap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.aiScanRejectedTitle.tr(),
                      style: AppTextStyles.getTextStyle(18).copyWith(
                        color: context.textPalette.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      LocaleKeys.aiScanResultValidationFailed.tr(),
                      style: AppTextStyles.getTextStyle(12).copyWith(
                        color: scheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (analysis.modality.isNotEmpty || analysis.urgency.isNotEmpty) ...[
            const VerticalGap(10),
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                if (analysis.modality.isNotEmpty)
                  _chip(
                    Icon(Icons.camera_alt_rounded, size: 12.sp),
                    analysis.modality,
                    context.textPalette.secondaryColor,
                    context,
                  ),
                if (analysis.urgency.isNotEmpty)
                  _chip(
                    Icon(Icons.priority_high_rounded, size: 12.sp),
                    '${LocaleKeys.aiScanRejectedUrgency.tr()}: ${analysis.urgency.toUpperCase()}',
                    scheme.error,
                    context,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(Icon icon, String label, Color color, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(data: IconThemeData(color: color, size: 12.sp), child: icon),
          const HorizontalGap(4),
          Text(
            label,
            style: AppTextStyles.getTextStyle(11).copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanImage(BuildContext context) {
    if (analysis.scanUrl.isEmpty && analysis.scanBase64.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultOriginalScan.tr(),
      icon: Icons.image_rounded,
      child: ScanImageView(
        base64: analysis.scanBase64,
        url: analysis.scanUrl,
      ),
    );
  }

  Widget _buildValidationErrorCard(BuildContext context, ColorScheme scheme) {
    if (analysis.inputGate.reason.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: scheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: scheme.error.withValues(alpha: 0.35), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: scheme.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.gpp_bad_rounded,
                  color: scheme.error,
                  size: 20.sp,
                ),
              ),
              const HorizontalGap(10),
              Expanded(
                child: Text(
                  LocaleKeys.aiScanResultValidationError.tr(),
                  style: AppTextStyles.getTextStyle(15).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const VerticalGap(12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: scheme.error.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: scheme.error.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Text(
              analysis.inputGate.reason,
              style: AppTextStyles.getTextStyle(13).copyWith(
                color: context.textPalette.primaryColor,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          if (analysis.inputGate.action.isNotEmpty) ...[
            const VerticalGap(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.auto_fix_high_rounded,
                  size: 16.sp,
                  color: context.textPalette.secondaryColor,
                ),
                const HorizontalGap(8),
                Expanded(
                  child: Text(
                    '${LocaleKeys.aiScanResultAction.tr()}: ${analysis.inputGate.action}',
                    style: AppTextStyles.getTextStyle(12).copyWith(
                      color: context.textPalette.secondaryColor,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScanInformation(BuildContext context) {
    final Map<String, String> items = {};
    if (analysis.patientName.isNotEmpty) {
      items[LocaleKeys.aiScanResultPatientName.tr()] = analysis.patientName;
    }
    if (analysis.patientId.isNotEmpty) {
      items[LocaleKeys.aiScanResultPatientId.tr()] = analysis.patientId;
    }
    if (analysis.modality.isNotEmpty) {
      items[LocaleKeys.aiScanModality.tr()] = analysis.modality;
    }
    if (analysis.createdAt.isNotEmpty) {
      items[LocaleKeys.aiScanResultCreatedAt.tr()] = analysis.createdAt;
    }
    if (analysis.aiJobStatus.isNotEmpty) {
      items[LocaleKeys.aiScanResultAiJobStatus.tr()] = analysis.aiJobStatus;
    }
    if (items.isEmpty) return const SizedBox.shrink();

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultScanInformation.tr(),
      icon: Icons.description_outlined,
      child: AiAnalysisInfoGrid(items: items),
    );
  }

  Widget _buildRecommendations(BuildContext context, ColorScheme scheme) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultRecommendations.tr(),
      icon: Icons.lightbulb_outline_rounded,
      child: Column(
        children: analysis.recommendations.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final recommendation = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24.r,
                  height: 24.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '$index',
                    style: AppTextStyles.getTextStyle(12).copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const HorizontalGap(10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      recommendation,
                      style: AppTextStyles.getTextStyle(13).copyWith(
                        color: context.textPalette.secondaryColor,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputDetails(BuildContext context) {
    final gate = analysis.inputGate;

    final Map<String, String> items = {};
    if (gate.width > 0) {
      items[LocaleKeys.aiScanResultWidth.tr()] = '${gate.width.toInt()}px';
    }
    if (gate.height > 0) {
      items[LocaleKeys.aiScanResultHeight.tr()] = '${gate.height.toInt()}px';
    }
    if (gate.aspectRatio > 0) {
      items[LocaleKeys.aiScanResultAspectRatio.tr()] =
          gate.aspectRatio.toStringAsFixed(2);
    }
    if (gate.intensityStd > 0) {
      items[LocaleKeys.aiScanResultIntensityStd.tr()] =
          gate.intensityStd.toStringAsFixed(4);
    }
    if (gate.colorSpread > 0) {
      items[LocaleKeys.aiScanResultColorSpread.tr()] =
          gate.colorSpread.toStringAsFixed(4);
    }
    if (gate.colorfulFraction > 0) {
      items[LocaleKeys.aiScanResultColorfulFraction.tr()] =
          gate.colorfulFraction.toStringAsFixed(4);
    }

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultImageQuality.tr(),
      icon: Icons.tune_rounded,
      child: AiAnalysisInfoGrid(items: items),
    );
  }
}
