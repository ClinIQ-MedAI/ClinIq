import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_info_grid.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_success_detections.dart';
import 'package:cliniq/features/ai/presentation/widgets/analysis_section_card.dart';
import 'package:cliniq/features/ai/presentation/widgets/scan_image_view.dart';
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
        _buildHeader(context, scheme),
        const VerticalGap(12),
        _buildScanImage(context),
        const VerticalGap(12),
        _buildSummary(context),
        const VerticalGap(12),
        _buildPrimaryDiagnosis(context, scheme),
        if (analysis.confidence.isNotEmpty) ...[
          const VerticalGap(12),
          _buildConfidence(context, scheme),
        ],
        if (analysis.severity.isNotEmpty) ...[
          const VerticalGap(12),
          _buildSeverity(context, scheme),
        ],
        if (analysis.clinicalMeaning.isNotEmpty) ...[
          const VerticalGap(12),
          _buildClinicalMeaning(context),
        ],
        if (analysis.findingsList.isNotEmpty) ...[
          const VerticalGap(12),
          _buildFindingsList(context, scheme),
        ],
        if (analysis.differentialDiagnoses.isNotEmpty) ...[
          const VerticalGap(12),
          _buildDifferentialDiagnoses(context, scheme),
        ],
        if (analysis.recommendations.isNotEmpty) ...[
          const VerticalGap(12),
          _buildRecommendations(context),
        ],
        if (analysis.urgency.isNotEmpty) ...[
          const VerticalGap(12),
          _buildUrgencyBadge(context, scheme),
        ],
        if (analysis.annotatedImageBase64.isNotEmpty) ...[
          const VerticalGap(12),
          _buildAnnotatedImage(context),
        ],
        if (analysis.detections.isNotEmpty) ...[
          const VerticalGap(12),
          AiAnalysisSuccessDetections(detections: analysis.detections),
        ],
        const VerticalGap(12),
        _buildScanInformation(context),
        const VerticalGap(12),
        _buildInputInfo(context),
        if (analysis.allProbabilities.isNotEmpty) ...[
          const VerticalGap(12),
          _buildProbabilities(context, scheme),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme scheme) {
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
              if (analysis.urgency.isNotEmpty)
                _chip(
                  context,
                  '${LocaleKeys.aiScanRejectedUrgency.tr()}: ${analysis.urgency.toUpperCase()}',
                  switch (analysis.urgency.toUpperCase()) {
                    'LOW' => const Color(0xFF4CAF50),
                    'MEDIUM' => const Color(0xFFFF9800),
                    'HIGH' => const Color(0xFFE53935),
                    _ => context.textPalette.secondaryColor,
                  },
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

  Widget _buildScanImage(BuildContext context) {
    final hasScan = analysis.scanBase64.isNotEmpty ||
        analysis.scanUrl.isNotEmpty;
    if (!hasScan) return const SizedBox.shrink();

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
            LocaleKeys.aiScanResultOriginalScan.tr(),
            style: AppTextStyles.getTextStyle(14).copyWith(
              color: context.textPalette.primaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const VerticalGap(12),
          ScanImageView(
            base64: analysis.scanBase64,
            url: analysis.scanUrl,
          ),
          const VerticalGap(8),
          Center(
            child: Text(
              LocaleKeys.aiScanResultUploadedImage.tr(),
              style: AppTextStyles.getTextStyle(11).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    if (analysis.summary.isEmpty) return const SizedBox.shrink();

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
          Row(
            children: [
              Icon(
                Icons.summarize_rounded,
                color: context.colorScheme.primary,
                size: 18.sp,
              ),
              const HorizontalGap(8),
              Expanded(
                child: Text(
                  LocaleKeys.aiScanResultSummary.tr(),
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const VerticalGap(10),
          Text(
            analysis.summary,
            style: AppTextStyles.getTextStyle(13).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryDiagnosis(BuildContext context, ColorScheme scheme) {
    if (analysis.primaryDiagnosis.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.08),
            scheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.medical_services_outlined,
              color: scheme.primary,
              size: 22.sp,
            ),
          ),
          const HorizontalGap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.aiScanResultDiagnosis.tr(),
                  style: AppTextStyles.getTextStyle(11).copyWith(
                    color: context.textPalette.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  analysis.primaryDiagnosis,
                  style: AppTextStyles.getTextStyle(16).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidence(BuildContext context, ColorScheme scheme) {
    final parsed = _parseConfidence(analysis.confidence);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64.r,
            height: 64.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: parsed,
                  strokeWidth: 6.w,
                  backgroundColor: scheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    parsed > 0.7
                        ? const Color(0xFF4CAF50)
                        : parsed > 0.4
                            ? const Color(0xFFFF9800)
                            : scheme.error,
                  ),
                ),
                Text(
                  '${(parsed * 100).round()}%',
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const HorizontalGap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.aiScanResultConfidence.tr(),
                  style: AppTextStyles.getTextStyle(11).copyWith(
                    color: context.textPalette.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  analysis.confidence,
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _parseConfidence(String confidence) {
    final trimmed = confidence.trim();
    if (trimmed.endsWith('%')) {
      final numStr = trimmed.substring(0, trimmed.length - 1).trim();
      final v = double.tryParse(numStr);
      if (v != null) return v.clamp(0, 100) / 100;
    }
    final v = double.tryParse(trimmed);
    if (v != null) {
      if (v > 1) return v.clamp(0, 100) / 100;
      return v.clamp(0, 1);
    }
    return 0;
  }

  Widget _buildSeverity(BuildContext context, ColorScheme scheme) {
    final severityColor = switch (analysis.severity.toUpperCase()) {
      'HIGH' => scheme.error,
      'MEDIUM' => const Color(0xFFFF9800),
      'LOW' => const Color(0xFF4CAF50),
      _ => context.textPalette.secondaryColor,
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: severityColor,
              size: 22.sp,
            ),
          ),
          const HorizontalGap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.aiScanResultSeverity.tr(),
                  style: AppTextStyles.getTextStyle(11).copyWith(
                    color: context.textPalette.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  analysis.severity.toUpperCase(),
                  style: AppTextStyles.getTextStyle(16).copyWith(
                    color: severityColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalMeaning(BuildContext context) {
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
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: context.colorScheme.primary,
                size: 18.sp,
              ),
              const HorizontalGap(8),
              Expanded(
                child: Text(
                  LocaleKeys.aiScanResultClinicalMeaning.tr(),
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const VerticalGap(10),
          Text(
            analysis.clinicalMeaning,
            style: AppTextStyles.getTextStyle(13).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w500,
              height: 1.5,
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

  Widget _buildDifferentialDiagnoses(BuildContext context, ColorScheme scheme) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultDifferentialDiagnoses.tr(),
      icon: Icons.account_tree_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: analysis.differentialDiagnoses.map(
          (diagnosis) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const HorizontalGap(8),
                Expanded(
                  child: Text(
                    diagnosis,
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

  Widget _buildRecommendations(BuildContext context) {
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
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: context.colorScheme.primary,
                size: 18.sp,
              ),
              const HorizontalGap(8),
              Expanded(
                child: Text(
                  LocaleKeys.aiScanResultRecommendations.tr(),
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const VerticalGap(12),
          ...analysis.recommendations.asMap().entries.map(
            (entry) {
              final index = entry.key + 1;
              final recommendation = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          '$index',
                          style: AppTextStyles.getTextStyle(12).copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const HorizontalGap(8),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: AppTextStyles.getTextStyle(13).copyWith(
                          color: context.textPalette.secondaryColor,
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencyBadge(BuildContext context, ColorScheme scheme) {
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
        border: Border.all(
          color: urgencyColor.withValues(alpha: 0.3),
          width: 1,
        ),
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

  Widget _buildAnnotatedImage(BuildContext context) {
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
          ScanImageView(base64: analysis.annotatedImageBase64),
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
      items[LocaleKeys.aiScanResultBodyPart.tr()] = analysis.modality;
    }
    if (analysis.createdAt.isNotEmpty) {
      items[LocaleKeys.aiScanResultCreatedAt.tr()] = analysis.createdAt;
    }
    if (analysis.aiJobStatus.isNotEmpty) {
      items[LocaleKeys.aiScanResultAiJobStatus.tr()] = analysis.aiJobStatus;
    }
    if (analysis.aiJobId.isNotEmpty) {
      items[LocaleKeys.aiScanResultAiJobId.tr()] = analysis.aiJobId;
    }
    if (analysis.bodyPart.isNotEmpty) {
      items[LocaleKeys.aiScanResultBodyPart.tr()] = analysis.bodyPart;
    }
    if (analysis.patientContext.isNotEmpty) {
      items[LocaleKeys.aiScanResultPatientContext.tr()] =
          analysis.patientContext;
    }
    if (analysis.timestamp.isNotEmpty) {
      items[LocaleKeys.aiScanResultTimestamp.tr()] = analysis.timestamp;
    }
    if (analysis.doctorName.isNotEmpty) {
      items[LocaleKeys.aiScanResultDoctorName.tr()] = analysis.doctorName;
    }
    if (analysis.doctorNotes.isNotEmpty) {
      items[LocaleKeys.aiScanResultDoctorNotes.tr()] = analysis.doctorNotes;
    }
    if (analysis.doctorReviewDate.isNotEmpty) {
      items[LocaleKeys.aiScanResultDoctorReviewDate.tr()] =
          analysis.doctorReviewDate;
    }
    if (analysis.isReviewed) {
      items[LocaleKeys.aiScanResultReviewed.tr()] =
          LocaleKeys.aiScanResultYes.tr();
    }
    if (items.isEmpty) return const SizedBox.shrink();

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultScanInformation.tr(),
      icon: Icons.person_outline_rounded,
      child: AiAnalysisInfoGrid(items: items),
    );
  }

  Widget _buildInputInfo(BuildContext context) {
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
          gate.intensityStd.toStringAsFixed(2);
    }
    if (gate.colorSpread > 0) {
      items[LocaleKeys.aiScanResultColorSpread.tr()] =
          gate.colorSpread.toStringAsFixed(2);
    }
    if (gate.colorfulFraction > 0) {
      items[LocaleKeys.aiScanResultColorfulFraction.tr()] =
          gate.colorfulFraction.toStringAsFixed(3);
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

  Widget _buildProbabilities(BuildContext context, ColorScheme scheme) {
    final sorted = List.of(analysis.allProbabilities)
      ..sort((a, b) => b.value.compareTo(a.value));

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultProbabilities.tr(),
      icon: Icons.bar_chart_rounded,
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        initiallyExpanded: sorted.length <= 3,
        childrenPadding: EdgeInsets.only(top: 8.h),
        title: Text(
          '${sorted.length} ${LocaleKeys.aiScanResultMetrics.tr()}',
          style: AppTextStyles.getTextStyle(12).copyWith(
            color: context.textPalette.secondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: sorted.map(
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
                    const VerticalGap(4),
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
}