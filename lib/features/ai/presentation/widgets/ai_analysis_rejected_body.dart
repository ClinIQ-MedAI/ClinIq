import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_info_grid.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_recommendations_section.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_text_section.dart';
import 'package:cliniq/features/ai/presentation/widgets/analysis_section_card.dart';
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
        _buildScanInfo(context),
        const VerticalGap(12),
        AiAnalysisTextSection(
          title: LocaleKeys.aiScanResultSummary.tr(),
          value: analysis.summary,
          icon: Icons.info_outline_rounded,
        ),
        const VerticalGap(12),
        AiAnalysisRecommendationsSection(
          title: LocaleKeys.aiScanResultRecommendations.tr(),
          recommendations: analysis.recommendations,
        ),
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
          if (analysis.inputGate.reason.isNotEmpty) ...[
            const VerticalGap(10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: scheme.error.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                analysis.inputGate.reason,
                style: AppTextStyles.getTextStyle(12).copyWith(
                  color: context.textPalette.secondaryColor,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScanInfo(BuildContext context) {
    final Map<String, String> items = {};
    if (analysis.patientName.isNotEmpty) {
      items['Name'] = analysis.patientName;
    }
    if (analysis.patientId.isNotEmpty) {
      items['Patient ID'] = analysis.patientId;
    }
    if (analysis.modality.isNotEmpty) {
      items[LocaleKeys.aiScanModality.tr()] = analysis.modality;
    }
    if (analysis.createdAt.isNotEmpty) {
      items[LocaleKeys.aiScanResultCreatedAt.tr()] = analysis.createdAt;
    }
    if (analysis.urgency.isNotEmpty) {
      items[LocaleKeys.aiScanRejectedUrgency.tr()] = analysis.urgency;
    }
    if (items.isEmpty) return const SizedBox.shrink();

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultMetadata.tr(),
      icon: Icons.description_outlined,
      child: AiAnalysisInfoGrid(items: items),
    );
  }

  Widget _buildInputDetails(BuildContext context) {
    final gate = analysis.inputGate;

    final Map<String, String> items = {};
    if (gate.action.isNotEmpty) {
      items[LocaleKeys.aiScanResultAction.tr()] = gate.action;
    }
    if (gate.width > 0) {
      items[LocaleKeys.aiScanResultWidth.tr()] = '${gate.width}px';
    }
    if (gate.height > 0) {
      items[LocaleKeys.aiScanResultHeight.tr()] = '${gate.height}px';
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
      title: LocaleKeys.aiScanResultInputValidation.tr(),
      icon: Icons.tune_rounded,
      child: AiAnalysisInfoGrid(items: items),
    );
  }
}
