import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_annotated_image_section.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_info_grid.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_recommendations_section.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_text_section.dart';
import 'package:cliniq/features/ai/presentation/widgets/analysis_section_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAnalysisSuccessBody extends StatelessWidget {
  const AiAnalysisSuccessBody({super.key, required this.analysis});

  final AIAnalysisSuccessEntity analysis;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      children: [
        _buildStatusHeader(context, scheme),
        const VerticalGap(12),
        AiAnalysisAnnotatedImageSection(
          annotatedImageBase64: analysis.annotatedImageBase64,
        ),
        const VerticalGap(12),
        _buildPatientInfo(context),
        const VerticalGap(12),
        _buildAiFindings(context, scheme),
        const VerticalGap(12),
        _buildUrgencyBadge(context, scheme),
        const VerticalGap(12),
        AiAnalysisTextSection(
          title: LocaleKeys.aiScanResultSummary.tr(),
          value: analysis.summary,
          icon: Icons.summarize_rounded,
        ),
        if (analysis.findingsList.isNotEmpty) ...[
          const VerticalGap(12),
          _buildFindingsList(context, scheme),
        ],
        const VerticalGap(12),
        AiAnalysisRecommendationsSection(
          title: LocaleKeys.aiScanResultRecommendations.tr(),
          recommendations: analysis.recommendations,
        ),
        if (analysis.allProbabilities.isNotEmpty) ...[
          const VerticalGap(12),
          _buildProbabilities(context, scheme),
        ],
        const VerticalGap(12),
        _buildInputInfo(context),
      ],
    );
  }

  Widget _buildStatusHeader(BuildContext context, ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.25)),
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
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: scheme.primary,
                  size: 24.sp,
                ),
              ),
              const HorizontalGap(12),
              Expanded(
                child: Text(
                  LocaleKeys.aiScanAnalysisComplete.tr(),
                  style: AppTextStyles.getTextStyle(18).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const VerticalGap(10),
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              _chip(
                context,
                '${LocaleKeys.aiScanResultInputValidation.tr()}: ${LocaleKeys.aiScanResultValidationPassed.tr()}',
                scheme.primary,
              ),
              if (analysis.modality.isNotEmpty)
                _chip(
                  context,
                  analysis.modality,
                  context.textPalette.secondaryColor,
                ),
            ],
          ),
          if (analysis.createdAt.isNotEmpty) ...[
            const VerticalGap(6),
            Text(
              analysis.createdAt,
              style: AppTextStyles.getTextStyle(11).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.getTextStyle(11).copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPatientInfo(BuildContext context) {
    final Map<String, String> items = {};
    if (analysis.patientName.isNotEmpty) {
      items['Name'] = analysis.patientName;
    }
    if (analysis.patientId.isNotEmpty) {
      items['Patient ID'] = analysis.patientId;
    }
    if (analysis.bodyPart.isNotEmpty) {
      items[LocaleKeys.aiScanResultBodyPart.tr()] = analysis.bodyPart;
    }
    if (analysis.patientContext.isNotEmpty) {
      items[LocaleKeys.aiScanResultPatientContext.tr()] =
          analysis.patientContext;
    }
    if (items.isEmpty) return const SizedBox.shrink();

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultClinicalInfo.tr(),
      icon: Icons.person_outline_rounded,
      child: AiAnalysisInfoGrid(items: items),
    );
  }

  Widget _buildAiFindings(BuildContext context, ColorScheme scheme) {
    final hasAny = analysis.primaryDiagnosis.isNotEmpty ||
        analysis.severity.isNotEmpty ||
        analysis.confidence.isNotEmpty ||
        analysis.clinicalMeaning.isNotEmpty;
    if (!hasAny) return const SizedBox.shrink();

    return AnalysisSectionCard(
      title: 'AI Findings',
      icon: Icons.medical_services_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (analysis.primaryDiagnosis.isNotEmpty)
            _findingsRow(
              context,
              scheme,
              LocaleKeys.aiScanResultDiagnosis.tr(),
              analysis.primaryDiagnosis,
            ),
          if (analysis.severity.isNotEmpty)
            _findingsRow(
              context,
              scheme,
              LocaleKeys.aiScanResultSeverity.tr(),
              analysis.severity,
              valueColor: switch (analysis.severity.toUpperCase()) {
                'HIGH' => scheme.error,
                'MEDIUM' => const Color(0xFFFF9800),
                _ => null,
              },
            ),
          if (analysis.confidence.isNotEmpty)
            _findingsRow(
              context,
              scheme,
              LocaleKeys.aiScanResultConfidence.tr(),
              analysis.confidence,
            ),
          if (analysis.clinicalMeaning.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.aiScanResultClinicalMeaning.tr(),
                    style: AppTextStyles.getTextStyle(11).copyWith(
                      color: context.textPalette.secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    analysis.clinicalMeaning,
                    style: AppTextStyles.getTextStyle(13).copyWith(
                      color: context.textPalette.primaryColor,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _findingsRow(
    BuildContext context,
    ColorScheme scheme,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AppTextStyles.getTextStyle(12).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.getTextStyle(13).copyWith(
                color: valueColor ?? context.textPalette.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencyBadge(BuildContext context, ColorScheme scheme) {
    if (analysis.urgency.isEmpty) return const SizedBox.shrink();

    final urgencyColor = switch (analysis.urgency.toUpperCase()) {
      'LOW' => const Color(0xFF4CAF50),
      'MEDIUM' => const Color(0xFFFF9800),
      'HIGH' => const Color(0xFFE53935),
      _ => context.textPalette.secondaryColor,
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: urgencyColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: urgencyColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            switch (analysis.urgency.toUpperCase()) {
              'LOW' => Icons.arrow_downward_rounded,
              'MEDIUM' => Icons.remove_rounded,
              'HIGH' => Icons.arrow_upward_rounded,
              _ => Icons.info_outline_rounded,
            },
            color: urgencyColor,
            size: 20.sp,
          ),
          const HorizontalGap(8),
          Text(
            '${LocaleKeys.aiScanRejectedUrgency.tr()}: ${analysis.urgency.toUpperCase()}',
            style: AppTextStyles.getTextStyle(14).copyWith(
              color: urgencyColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingsList(BuildContext context, ColorScheme scheme) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanFindings.tr(),
      icon: Icons.list_alt_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: analysis.findingsList.map(
          (finding) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u2022',
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const HorizontalGap(8),
                Expanded(
                  child: Text(
                    finding,
                    style: AppTextStyles.getTextStyle(13).copyWith(
                      color: context.textPalette.secondaryColor,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildProbabilities(BuildContext context, ColorScheme scheme) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultProbabilities.tr(),
      icon: Icons.bar_chart_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: analysis.allProbabilities.map(
          (prob) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prob.label,
                      style: AppTextStyles.getTextStyle(12).copyWith(
                        color: context.textPalette.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(prob.value * 100).toStringAsFixed(1)}%',
                      style: AppTextStyles.getTextStyle(12).copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: prob.value.clamp(0.0, 1.0),
                    minHeight: 6.h,
                    backgroundColor: scheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      prob.value > 0.7
                          ? const Color(0xFFE53935)
                          : prob.value > 0.4
                              ? const Color(0xFFFF9800)
                              : scheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildInputInfo(BuildContext context) {
    final gate = analysis.inputGate;

    final Map<String, String> items = {};
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
    items[LocaleKeys.aiScanResultInputValidation.tr()] = gate.passed
        ? LocaleKeys.aiScanResultValidationPassed.tr()
        : LocaleKeys.aiScanResultValidationFailed.tr();
    if (gate.action.isNotEmpty) {
      items[LocaleKeys.aiScanResultAction.tr()] = gate.action;
    }

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultInputValidation.tr(),
      icon: Icons.info_outline_rounded,
      child: AiAnalysisInfoGrid(items: items),
    );
  }
}
