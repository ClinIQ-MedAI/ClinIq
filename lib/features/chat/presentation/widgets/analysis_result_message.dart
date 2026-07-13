import 'dart:convert';

import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/data/models/scan_analysis_model.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalysisResultMessage extends StatelessWidget {
  const AnalysisResultMessage({super.key, required this.message});

  final ChatMessageEntity message;

  ScanAnalysisEntity? get _analysis {
    try {
      final data = jsonDecode(message.content);
      if (data is! Map) return null;
      return ScanAnalysisModel.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysis = _analysis;
    if (analysis == null) return const SizedBox.shrink();

    return switch (analysis) {
      AIAnalysisRejectedEntity() => _RejectedCard(analysis: analysis)
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.06, duration: 300.ms),
      AIAnalysisSuccessEntity() => _SuccessCard(analysis: analysis)
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.06, duration: 300.ms),
      PrescriptionAnalysisEntity() => _PrescriptionCard(analysis: analysis)
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.06, duration: 300.ms),
    };
  }
}

class _RejectedCard extends StatelessWidget {
  const _RejectedCard({required this.analysis});
  final AIAnalysisRejectedEntity analysis;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return InkWell(
      onTap: () => _openReport(context),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2410) : const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark ? const Color(0xFF4A3E1A) : const Color(0xFFF0D78C),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 22.sp, color: const Color(0xFFE6A817)),
                const HorizontalGap(8),
                Expanded(
                  child: Text(
                    LocaleKeys.aiScanRejectedTitle.tr(),
                    style: AppTextStyles.getTextStyle(15).copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (analysis.summary.isNotEmpty) ...[
              const VerticalGap(10),
              Text(
                analysis.summary,
                style: AppTextStyles.getTextStyle(12).copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (analysis.inputGate.reason.isNotEmpty) ...[
              const VerticalGap(8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6A817).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  analysis.inputGate.reason,
                  style: AppTextStyles.getTextStyle(11).copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
            const VerticalGap(12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _openReport(context),
                icon: Icon(Icons.open_in_new_rounded, size: 16.sp),
                label: Text(
                  LocaleKeys.aiScanViewFullReport.tr(),
                  style: AppTextStyles.getTextStyle(13).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openReport(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.aiAnalysisResultScreen,
      arguments: analysis,
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.analysis});
  final AIAnalysisSuccessEntity analysis;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return InkWell(
      onTap: () => _openReport(context),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: _bgColor(scheme),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: _borderColor(scheme), width: 1),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _headerRow(scheme),
            const VerticalGap(12),
            _summaryRow(scheme),
            const VerticalGap(12),
            _chipsRow(scheme),
            if (analysis.primaryDiagnosis.isNotEmpty) ...[
              const VerticalGap(12),
              _diagnosisPreview(scheme),
            ],
            const VerticalGap(16),
            _viewReportButton(context, scheme),
            const VerticalGap(6),
            _footerCaption(scheme),
          ],
        ),
      ),
    );
  }

  void _openReport(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.aiAnalysisResultScreen,
      arguments: analysis,
    );
  }

  Widget _headerRow(ColorScheme scheme) {
    return Row(
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: 22.sp,
            color: const Color(0xFF4CAF50),
          ),
        ),
        const HorizontalGap(10),
        Expanded(
          child: Text(
            LocaleKeys.aiScanAnalysisComplete.tr(),
            style: AppTextStyles.getTextStyle(
              15,
            ).copyWith(color: scheme.onSurface, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(ColorScheme scheme) {
    return Text(
      LocaleKeys.aiScanAnalyzedSuccessfully.tr(),
      style: AppTextStyles.getTextStyle(12).copyWith(
        color: scheme.onSurface.withValues(alpha: 0.65),
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }

  Widget _chipsRow(ColorScheme scheme) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 6.h,
      children: [
        if (analysis.urgency.isNotEmpty)
          _chip(scheme, analysis.urgency.toUpperCase(), _urgencyColor(scheme)),
      ],
    );
  }

  Color _urgencyColor(ColorScheme scheme) {
    switch (analysis.urgency.toUpperCase()) {
      case 'LOW':
        return const Color(0xFF4CAF50);
      case 'MEDIUM':
        return const Color(0xFFFF9800);
      case 'HIGH':
        return const Color(0xFFE53935);
      default:
        return scheme.onSurface.withValues(alpha: 0.5);
    }
  }

  Widget _chip(ColorScheme scheme, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.getTextStyle(10).copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _diagnosisPreview(ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        analysis.primaryDiagnosis,
        style: AppTextStyles.getTextStyle(11).copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _viewReportButton(BuildContext context, ColorScheme scheme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => _openReport(context),
        icon: Icon(Icons.open_in_new_rounded, size: 16.sp),
        label: Text(
          LocaleKeys.aiScanViewFullReport.tr(),
          style: AppTextStyles.getTextStyle(
            13,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _footerCaption(ColorScheme scheme) {
    return Center(
      child: Text(
        LocaleKeys.aiScanTapToReview.tr(),
        style: AppTextStyles.getTextStyle(9).copyWith(
          color: scheme.onSurface.withValues(alpha: 0.35),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _bgColor(ColorScheme scheme) => scheme.brightness == Brightness.dark
      ? const Color(0xFF1A2E1A)
      : const Color(0xFFF1F9F1);

  Color _borderColor(ColorScheme scheme) => scheme.brightness == Brightness.dark
      ? const Color(0xFF2D4A2D)
      : const Color(0xFFC8E6C9);
}

class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard({required this.analysis});
  final PrescriptionAnalysisEntity analysis;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return InkWell(
      onTap: () => _openReport(context),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: _bgColor(scheme),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: _borderColor(scheme), width: 1),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _headerRow(scheme),
            const VerticalGap(12),
            _summaryRow(scheme),
            const VerticalGap(16),
            _viewReportButton(context, scheme),
            const VerticalGap(6),
            _footerCaption(scheme),
          ],
        ),
      ),
    );
  }

  void _openReport(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.aiAnalysisResultScreen,
      arguments: analysis,
    );
  }

  Widget _headerRow(ColorScheme scheme) {
    return Row(
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.medication_rounded,
            size: 22.sp,
            color: const Color(0xFF4CAF50),
          ),
        ),
        const HorizontalGap(10),
        Expanded(
          child: Text(
            'Prescription Analysis',
            style: AppTextStyles.getTextStyle(
              15,
            ).copyWith(color: scheme.onSurface, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(ColorScheme scheme) {
    final total = analysis.totalMedications;
    final verified = analysis.verifiedMedications;
    return Text(
      '$total medications detected ($verified verified)',
      style: AppTextStyles.getTextStyle(12).copyWith(
        color: scheme.onSurface.withValues(alpha: 0.65),
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }

  Widget _viewReportButton(BuildContext context, ColorScheme scheme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => _openReport(context),
        icon: Icon(Icons.open_in_new_rounded, size: 16.sp),
        label: Text(
          LocaleKeys.aiScanViewFullReport.tr(),
          style: AppTextStyles.getTextStyle(
            13,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _footerCaption(ColorScheme scheme) {
    return Center(
      child: Text(
        LocaleKeys.aiScanTapToReview.tr(),
        style: AppTextStyles.getTextStyle(9).copyWith(
          color: scheme.onSurface.withValues(alpha: 0.35),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _bgColor(ColorScheme scheme) => scheme.brightness == Brightness.dark
      ? const Color(0xFF1A2E1A)
      : const Color(0xFFF1F9F1);

  Color _borderColor(ColorScheme scheme) => scheme.brightness == Brightness.dark
      ? const Color(0xFF2D4A2D)
      : const Color(0xFFC8E6C9);
}
