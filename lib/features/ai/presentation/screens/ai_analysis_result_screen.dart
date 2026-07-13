import 'dart:convert';

import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/analysis_section_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAnalysisResultScreen extends StatelessWidget {
  const AiAnalysisResultScreen({super.key, required this.analysis});

  final ScanAnalysisEntity analysis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(LocaleKeys.aiScanAnalysisTitle.tr()),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
        children: [
          if (!analysis.isPassed) _rejectedBanner(context),
          if (analysis.displayImageBase64 != null ||
              analysis.displayImageUrl != null)
            _scanImageSection(context).animate().fadeIn().slideY(begin: 0.04),
          if (analysis.displayAnnotatedBase64 != null)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: _annotatedImageSection(context)
                  .animate()
                  .fadeIn()
                  .slideY(begin: 0.04),
            ),
          if (analysis.isPassed) ...[
            if (analysis.primaryDiagnosis.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: _diagnosisSection(context)
                    .animate()
                    .fadeIn()
                    .slideY(begin: 0.04),
              ),
            if (analysis.summary.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: _summarySection(context)
                    .animate()
                    .fadeIn()
                    .slideY(begin: 0.04),
              ),
            if (analysis.patientContext.isNotEmpty ||
                analysis.modality.isNotEmpty ||
                analysis.bodyPart.isNotEmpty ||
                analysis.clinicalMeaning.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: _clinicalInfoSection(context)
                    .animate()
                    .fadeIn()
                    .slideY(begin: 0.04),
              ),
            if (analysis.confidence > 0 || analysis.severity.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: _metricsSection(context)
                    .animate()
                    .fadeIn()
                    .slideY(begin: 0.04),
              ),
            if (analysis.allProbabilities.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: _probabilitiesSection(context)
                    .animate()
                    .fadeIn()
                    .slideY(begin: 0.04),
              ),
            if (analysis.findingsList.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: _findingsSection(context)
                    .animate()
                    .fadeIn()
                    .slideY(begin: 0.04),
              ),
            if (analysis.recommendations.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: _recommendationsSection(context)
                    .animate()
                    .fadeIn()
                    .slideY(begin: 0.04),
              ),
          ],
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: _validationSection(context)
                .animate()
                .fadeIn()
                .slideY(begin: 0.04),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: _metadataSection(context)
                .animate()
                .fadeIn()
                .slideY(begin: 0.04),
          ),
        ],
      ),
    );
  }

  Widget _rejectedBanner(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = const Color(0xFFE6A817);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: _isDark(scheme) ? const Color(0xFF2A2410) : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _isDark(scheme) ? const Color(0xFF4A3E1A) : const Color(0xFFF0D78C),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.warning_amber_rounded, size: 40.sp, color: accent),
          const VerticalGap(10),
          Text(
            LocaleKeys.aiScanRejectedTitle.tr(),
            style: AppTextStyles.getTextStyle(17).copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (analysis.inputGate.reason.isNotEmpty) ...[
            const VerticalGap(8),
            Text(
              analysis.inputGate.reason,
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(13).copyWith(
                color: scheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
          if (analysis.inputGate.action.isNotEmpty) ...[
            const VerticalGap(4),
            Text(
              analysis.inputGate.action,
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(12).copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (analysis.summary.isNotEmpty) ...[
            const VerticalGap(12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                analysis.summary,
                style: AppTextStyles.getTextStyle(11).copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _scanImageSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base64 = analysis.displayImageBase64;
    final url = analysis.displayImageUrl;

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultOriginalScan.tr(),
      icon: Icons.image_outlined,
      subtitle: LocaleKeys.aiScanResultUploadedImage.tr(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: base64 != null
            ? Image.memory(
                base64Decode(base64),
                fit: BoxFit.contain,
                width: double.infinity,
                errorBuilder: (_, __, ___) => _imageError(scheme),
              )
            : Image.network(
                url!,
                fit: BoxFit.contain,
                width: double.infinity,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : _imageLoading(scheme),
                errorBuilder: (_, __, ___) => _imageError(scheme),
              ),
      ),
    );
  }

  Widget _annotatedImageSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultAiAnnotation.tr(),
      icon: Icons.auto_fix_high_outlined,
      subtitle: LocaleKeys.aiScanResultDetectedRegions.tr(),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          LocaleKeys.aiScanResultAnnotated.tr(),
          style: AppTextStyles.getTextStyle(9).copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Image.memory(
          base64Decode(analysis.displayAnnotatedBase64!),
          fit: BoxFit.contain,
          width: double.infinity,
          errorBuilder: (_, __, ___) => _imageError(scheme),
        ),
      ),
    );
  }

  Widget _diagnosisSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultDiagnosis.tr(),
      icon: Icons.medical_information_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            analysis.primaryDiagnosis,
            style: AppTextStyles.getTextStyle(22).copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const VerticalGap(8),
          Row(
            children: [
              if (analysis.confidence > 0) ...[
                _badge(
                  context,
                  '${LocaleKeys.aiScanResultConfidence.tr()} ${analysis.confidence.toStringAsFixed(0)}%',
                  scheme.primary,
                ),
                const HorizontalGap(6),
              ],
              if (analysis.severity.isNotEmpty)
                _badge(
                  context,
                  analysis.severity,
                  _severityColor(analysis.severity),
                ),
              if (analysis.urgency.isNotEmpty &&
                  analysis.urgency.toUpperCase() != 'NORMAL') ...[
                const HorizontalGap(6),
                _badge(
                  context,
                  analysis.urgency,
                  _urgencyColor(analysis.urgency),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _summarySection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultSummary.tr(),
      icon: Icons.article_outlined,
      child: Text(
        analysis.summary,
        style: AppTextStyles.getTextStyle(13).copyWith(
          color: scheme.onSurface.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _clinicalInfoSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final rows = <Widget>[];
    if (analysis.patientContext.isNotEmpty) {
      rows.add(_infoRow(
        scheme,
        Icons.person_outline,
        LocaleKeys.aiScanResultPatientContext.tr(),
        analysis.patientContext,
      ));
    }
    if (analysis.modality.isNotEmpty) {
      rows.add(_infoRow(
        scheme,
        Icons.view_in_ar_outlined,
        LocaleKeys.aiScanModality.tr(),
        analysis.modality,
      ));
    }
    if (analysis.bodyPart.isNotEmpty) {
      rows.add(_infoRow(
        scheme,
        Icons.accessibility_new_outlined,
        LocaleKeys.aiScanResultBodyPart.tr(),
        analysis.bodyPart,
      ));
    }
    if (analysis.clinicalMeaning.isNotEmpty) {
      rows.add(_infoRow(
        scheme,
        Icons.psychology_outlined,
        LocaleKeys.aiScanResultClinicalMeaning.tr(),
        analysis.clinicalMeaning,
      ));
    }

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultClinicalInfo.tr(),
      icon: Icons.info_outline,
      child: Column(children: rows),
    );
  }

  Widget _infoRow(
    ColorScheme scheme,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.sp, color: scheme.primary.withValues(alpha: 0.6)),
          const HorizontalGap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.getTextStyle(10).copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AppTextStyles.getTextStyle(13).copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricsSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultMetrics.tr(),
      icon: Icons.analytics_outlined,
      child: Row(
        children: [
          if (analysis.confidence > 0)
            Expanded(child: _confidenceCircle(context, scheme)),
          if (analysis.severity.isNotEmpty) ...[
            const HorizontalGap(16),
            Expanded(child: _severityCard(context, scheme)),
          ],
          if (analysis.urgency.isNotEmpty &&
              analysis.urgency.toUpperCase() != 'NORMAL') ...[
            const HorizontalGap(16),
            Expanded(child: _urgencyCard(context, scheme)),
          ],
        ],
      ),
    );
  }

  Widget _confidenceCircle(BuildContext context, ColorScheme scheme) {
    final pct = (analysis.confidence / 100).clamp(0.0, 1.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 72.r,
          height: 72.r,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72.r,
                height: 72.r,
                child: CircularProgressIndicator(
                  value: pct,
                  strokeWidth: 6.r,
                  backgroundColor: scheme.surfaceContainerHigh,
                  color: _confidenceColor(analysis.confidence),
                ),
              ),
              Text(
                '${analysis.confidence.toStringAsFixed(0)}%',
                style: AppTextStyles.getTextStyle(16).copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const VerticalGap(6),
        Text(
          LocaleKeys.aiScanResultConfidence.tr(),
          style: AppTextStyles.getTextStyle(10).copyWith(
            color: scheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _severityCard(BuildContext context, ColorScheme scheme) {
    final color = _severityColor(analysis.severity);
    return _metricMiniCard(
      scheme: scheme,
      label: LocaleKeys.aiScanResultSeverity.tr(),
      value: analysis.severity,
      color: color,
    );
  }

  Widget _urgencyCard(BuildContext context, ColorScheme scheme) {
    final color = _urgencyColor(analysis.urgency);
    return _metricMiniCard(
      scheme: scheme,
      label: LocaleKeys.aiScanStatus.tr(),
      value: analysis.urgency,
      color: color,
    );
  }

  Widget _metricMiniCard({
    required ColorScheme scheme,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.getTextStyle(18).copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const VerticalGap(4),
          Text(
            label,
            style: AppTextStyles.getTextStyle(10).copyWith(
              color: scheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _probabilitiesSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sorted = List.of(analysis.allProbabilities)
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxVal = sorted.isNotEmpty ? sorted.first.value : 1.0;

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultProbabilities.tr(),
      icon: Icons.bar_chart_outlined,
      child: Column(
        children: sorted.map((p) {
          final isTop = p == sorted.first;
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _probabilityBar(
              scheme: scheme,
              label: p.label,
              value: p.value,
              maxValue: maxVal,
              isHighlighted: isTop,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _probabilityBar({
    required ColorScheme scheme,
    required String label,
    required double value,
    required double maxValue,
    bool isHighlighted = false,
  }) {
    final fraction = maxValue > 0 ? value / maxValue : 0.0;
    final barColor = isHighlighted ? scheme.primary : scheme.primary.withValues(alpha: 0.35);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.getTextStyle(11).copyWith(
                color: isHighlighted
                    ? scheme.onSurface
                    : scheme.onSurface.withValues(alpha: 0.6),
                fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            Text(
              '${value.toStringAsFixed(2)}%',
              style: AppTextStyles.getTextStyle(11).copyWith(
                color: isHighlighted
                    ? scheme.primary
                    : scheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const VerticalGap(4),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: fraction),
          duration: 800.ms,
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 6.h,
                backgroundColor: scheme.surfaceContainerHigh,
                color: barColor,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _findingsSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanFindings.tr(),
      icon: Icons.checklist_outlined,
      child: Column(
        children: analysis.findingsList.map((f) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 18.sp,
                  color: const Color(0xFF4CAF50),
                ),
                const HorizontalGap(8),
                Expanded(
                  child: Text(
                    f,
                    style: AppTextStyles.getTextStyle(12).copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
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

  Widget _recommendationsSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultRecommendations.tr(),
      icon: Icons.lightbulb_outline,
      child: Column(
        children: List.generate(analysis.recommendations.length, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18.r,
                  height: 18.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: AppTextStyles.getTextStyle(10).copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const HorizontalGap(8),
                Expanded(
                  child: Text(
                    analysis.recommendations[i],
                    style: AppTextStyles.getTextStyle(12).copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _validationSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gate = analysis.inputGate;
    final passed = gate.passed;

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultInputValidation.tr(),
      icon: passed ? Icons.verified_outlined : Icons.gpp_bad_outlined,
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: passed
              ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
              : const Color(0xFFE53935).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          passed
              ? LocaleKeys.aiScanResultPassed.tr()
              : LocaleKeys.aiScanResultFailed.tr(),
          style: AppTextStyles.getTextStyle(9).copyWith(
            color: passed ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (passed) ...[
            Icon(Icons.check_circle_rounded,
                size: 36.sp, color: const Color(0xFF4CAF50)),
            const VerticalGap(6),
            Text(
              LocaleKeys.aiScanResultValidationPassed.tr(),
              style: AppTextStyles.getTextStyle(13).copyWith(
                color: const Color(0xFF4CAF50),
                fontWeight: FontWeight.w600,
              ),
            ),
            const VerticalGap(12),
          ] else ...[
            Icon(Icons.warning_rounded,
                size: 36.sp, color: const Color(0xFFE53935)),
            const VerticalGap(6),
            Text(
              LocaleKeys.aiScanResultValidationFailed.tr(),
              style: AppTextStyles.getTextStyle(13).copyWith(
                color: const Color(0xFFE53935),
                fontWeight: FontWeight.w600,
              ),
            ),
            if (gate.reason.isNotEmpty) ...[
              const VerticalGap(8),
              _validationMetricRow(
                scheme,
                LocaleKeys.aiScanRejectedReason.tr(),
                gate.reason,
              ),
            ],
            if (gate.action.isNotEmpty) ...[
              const VerticalGap(4),
              _validationMetricRow(
                scheme,
                LocaleKeys.aiScanResultAction.tr(),
                gate.action,
              ),
            ],
            const VerticalGap(12),
          ],
          _validationMetricsGrid(scheme, gate),
        ],
      ),
    );
  }

  Widget _validationMetricsGrid(ColorScheme scheme, dynamic gate) {
    final metrics = [
      ('${LocaleKeys.aiScanResultWidth.tr()}', '${gate.width.toStringAsFixed(1)} px'),
      ('${LocaleKeys.aiScanResultHeight.tr()}', '${gate.height.toStringAsFixed(1)} px'),
      ('${LocaleKeys.aiScanResultAspectRatio.tr()}', gate.aspectRatio.toStringAsFixed(2)),
      ('${LocaleKeys.aiScanResultIntensityStd.tr()}', gate.intensityStd.toStringAsFixed(2)),
      ('${LocaleKeys.aiScanResultColorSpread.tr()}', gate.colorSpread.toStringAsFixed(3)),
      ('${LocaleKeys.aiScanResultColorfulFraction.tr()}', gate.colorfulFraction.toStringAsFixed(3)),
    ];

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: metrics.map((m) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                m.$2,
                style: AppTextStyles.getTextStyle(13).copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                m.$1,
                style: AppTextStyles.getTextStyle(9).copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _validationMetricRow(ColorScheme scheme, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70.w,
          child: Text(
            label,
            style: AppTextStyles.getTextStyle(10).copyWith(
              color: scheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.getTextStyle(12).copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _metadataSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final rows = <Widget>[
      _metaRow(scheme, LocaleKeys.aiScanResultAnalysisId.tr(), analysis.id),
      if (analysis.aiJobId.isNotEmpty)
        _metaRow(scheme, LocaleKeys.aiScanResultJobId.tr(), analysis.aiJobId),
      _metaRow(scheme, LocaleKeys.aiScanStatus.tr(), analysis.status),
      if (analysis.createdAt.isNotEmpty)
        _metaRow(scheme, LocaleKeys.aiScanResultCreatedAt.tr(), analysis.createdAt),
    ];

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultMetadata.tr(),
      icon: Icons.info_outline,
      child: Column(children: rows),
    );
  }

  Widget _metaRow(ColorScheme scheme, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.getTextStyle(11).copyWith(
              color: scheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.getTextStyle(11).copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(BuildContext context, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        text,
        style: AppTextStyles.getTextStyle(11).copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _imageLoading(ColorScheme scheme) {
    return Container(
      height: 200.h,
      color: scheme.surfaceContainerHigh,
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2.5, color: scheme.primary),
      ),
    );
  }

  Widget _imageError(ColorScheme scheme) {
    return Container(
      height: 200.h,
      color: scheme.surfaceContainerHigh,
      child: Center(
        child: Icon(Icons.broken_image_outlined, size: 36.sp,
            color: scheme.onSurface.withValues(alpha: 0.3)),
      ),
    );
  }

  Color _severityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'LOW':
        return const Color(0xFF4CAF50);
      case 'MEDIUM':
        return const Color(0xFFE6A817);
      case 'HIGH':
        return const Color(0xFFE53935);
      case 'CRITICAL':
        return const Color(0xFFB71C1C);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  Color _urgencyColor(String urgency) {
    switch (urgency.toUpperCase()) {
      case 'NORMAL':
        return const Color(0xFF4CAF50);
      case 'URGENT':
        return const Color(0xFFE6A817);
      case 'REJECTED':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  Color _confidenceColor(double confidence) {
    if (confidence >= 80) return const Color(0xFF4CAF50);
    if (confidence >= 60) return const Color(0xFFE6A817);
    return const Color(0xFFE53935);
  }

  bool _isDark(ColorScheme scheme) => scheme.brightness == Brightness.dark;
}
