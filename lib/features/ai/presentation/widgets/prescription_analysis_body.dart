import 'dart:convert';

import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_info_grid.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_success_detections.dart';
import 'package:cliniq/features/ai/presentation/widgets/analysis_section_card.dart';
import 'package:cliniq/features/ai/presentation/widgets/medication_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrescriptionAnalysisBody extends StatelessWidget {
  const PrescriptionAnalysisBody({super.key, required this.analysis});

  final PrescriptionAnalysisEntity analysis;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      children: [
        _buildStatusHeader(context),
        const VerticalGap(12),
        _buildScanImage(context),
        const VerticalGap(12),
        _buildStatisticsRow(context),
        if (analysis.primaryDiagnosis.isNotEmpty) ...[
          const VerticalGap(12),
          _buildPrimaryDiagnosis(context),
        ],
        if (analysis.summary.isNotEmpty) ...[
          const VerticalGap(12),
          _buildSummary(context),
        ],
        const VerticalGap(12),
        _buildMedications(context),
        if (analysis.detections.isNotEmpty) ...[
          const VerticalGap(12),
          AiAnalysisSuccessDetections(detections: analysis.detections),
        ],
        if (analysis.aiFindingsNotes.isNotEmpty) ...[
          const VerticalGap(12),
          _buildNotes(context),
        ],
        if (analysis.rawVlmOutput.isNotEmpty) ...[
          const VerticalGap(12),
          _buildRawVlmOutput(context),
        ],
        const VerticalGap(12),
        _buildScanInformation(context),
        const VerticalGap(12),
        _buildInputInfo(context),
      ],
    );
  }

  Widget _buildStatusHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.25),
        ),
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
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: const Color(0xFF4CAF50),
                  size: 24.sp,
                ),
              ),
              const HorizontalGap(12),
              Expanded(
                child: Text(
                  LocaleKeys.aiScanResultPrescriptionAnalysis.tr(),
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
                'PRESCRIPTION',
                const Color(0xFF4CAF50),
              ),
              if (analysis.createdAt.isNotEmpty)
                _chip(
                  context,
                  analysis.createdAt,
                  context.textPalette.secondaryColor,
                ),
            ],
          ),
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
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultOriginalScan.tr(),
      icon: Icons.image_rounded,
      child: InkWell(
        onTap: () => _showFullScreenImage(context),
        borderRadius: BorderRadius.circular(12.r),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: 300.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: analysis.scanBase64.isNotEmpty
                ? Image.memory(
                    base64Decode(analysis.scanBase64),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image_outlined,
                      color: Theme.of(context).colorScheme.error,
                      size: 40.sp,
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      size: 48.sp,
                      color: context.textPalette.secondaryColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    if (analysis.scanBase64.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.memory(
                base64Decode(analysis.scanBase64),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white,
                  size: 48.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsRow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultMedicationOverview.tr(),
      icon: Icons.analytics_rounded,
      child: Row(
        children: [
          _statItem(
            context,
            '${analysis.totalMedications}',
            LocaleKeys.aiScanResultTotal.tr(),
            scheme.primary,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              width: 1,
              height: 40.h,
              color: scheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          _statItem(
            context,
            '${analysis.verifiedMedications}',
            LocaleKeys.aiScanResultVerified.tr(),
            const Color(0xFF4CAF50),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              width: 1,
              height: 40.h,
              color: scheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          _statItem(
            context,
            '${analysis.totalMedications - analysis.verifiedMedications}',
            LocaleKeys.aiScanResultUnverified.tr(),
            const Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _statItem(
    BuildContext context,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.getTextStyle(24).copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTextStyles.getTextStyle(10).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryDiagnosis(BuildContext context) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultPrimaryDiagnosis.tr(),
      icon: Icons.local_hospital_rounded,
      child: Text(
        analysis.primaryDiagnosis,
        style: AppTextStyles.getTextStyle(13).copyWith(
          color: context.textPalette.primaryColor,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultSummary.tr(),
      icon: Icons.summarize_rounded,
      child: Text(
        analysis.summary,
        style: AppTextStyles.getTextStyle(13).copyWith(
          color: context.textPalette.primaryColor,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
      ),
    );
  }

  Widget _buildMedications(BuildContext context) {
    return AnalysisSectionCard(
      title:
          '${LocaleKeys.aiScanFindings.tr()} (${analysis.medications.length})',
      icon: Icons.medication_rounded,
      child: Column(
        children: analysis.medications.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: MedicationCard(
              medication: entry.value,
              index: entry.key,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotes(BuildContext context) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultSummary.tr(),
      icon: Icons.notes_rounded,
      child: Text(
        analysis.aiFindingsNotes,
        style: AppTextStyles.getTextStyle(13).copyWith(
          color: context.textPalette.primaryColor,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
      ),
    );
  }

  Widget _buildRawVlmOutput(BuildContext context) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultRawVlmOutput.tr(),
      icon: Icons.code_rounded,
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: EdgeInsets.only(top: 8.h),
        title: Text(
          LocaleKeys.aiScanTapToReview.tr(),
          style: AppTextStyles.getTextStyle(12).copyWith(
            color: context.textPalette.secondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SelectableText(
              analysis.rawVlmOutput,
              style: AppTextStyles.getTextStyle(11).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
          ),
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
    if (analysis.aiJobId.isNotEmpty) {
      items[LocaleKeys.aiScanResultJobId.tr()] = analysis.aiJobId;
    }
    if (analysis.aiJobStatus.isNotEmpty) {
      items[LocaleKeys.aiScanResultAiJobStatus.tr()] = analysis.aiJobStatus;
    }
    if (analysis.scanUrl.isNotEmpty) {
      items['URL'] = analysis.scanUrl;
    }
    if (analysis.createdAt.isNotEmpty) {
      items[LocaleKeys.aiScanResultCreatedAt.tr()] = analysis.createdAt;
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultScanInformation.tr(),
      icon: Icons.info_outline_rounded,
      child: AiAnalysisInfoGrid(items: items),
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
    if (gate.reason.isNotEmpty) {
      items[LocaleKeys.aiScanResultReason.tr()] = gate.reason;
    }

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultInputValidation.tr(),
      icon: Icons.info_outline_rounded,
      child: AiAnalysisInfoGrid(items: items),
    );
  }
}