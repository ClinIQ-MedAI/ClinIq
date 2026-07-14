import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_info_grid.dart';
import 'package:cliniq/features/ai/presentation/widgets/analysis_section_card.dart';
import 'package:cliniq/features/ai/presentation/widgets/medication_card.dart';
import 'package:cliniq/features/ai/presentation/widgets/prescription_raw_vlm_section.dart';
import 'package:cliniq/features/ai/presentation/widgets/scan_image_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrescriptionAnalysisBody extends StatelessWidget {
  const PrescriptionAnalysisBody({super.key, required this.analysis});

  final PrescriptionAnalysisEntity analysis;

  static const Color _accent = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      children: [
        _buildStatusHeader(context, scheme),
        const VerticalGap(12),
        _buildScanImage(context),
        if (analysis.primaryDiagnosis.isNotEmpty) ...[
          const VerticalGap(12),
          _buildPrimaryDiagnosis(context, scheme),
        ],
        const VerticalGap(12),
        _buildStatisticsRow(context),
        if (analysis.medications.isNotEmpty) ...[
          const VerticalGap(12),
          _buildMedications(context),
        ],
        const VerticalGap(12),
        PrescriptionRawVlmSection(medications: analysis.rawMedications),
        if (analysis.aiFindingsNotes.isNotEmpty) ...[
          const VerticalGap(12),
          _buildNotes(context),
        ],
        const VerticalGap(12),
        _buildScanInformation(context),
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
        border: Border.all(color: _accent.withValues(alpha: 0.25)),
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
                  color: _accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: _accent,
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
              if (analysis.modality.isNotEmpty)
                _chip(context, analysis.modality, _accent),
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
        style: AppTextStyles.getTextStyle(
          11,
        ).copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildScanImage(BuildContext context) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultUploadedPrescription.tr(),
      icon: Icons.image_rounded,
      child: ScanImageView(
        base64: analysis.scanBase64,
        url: analysis.scanUrl,
      ),
    );
  }

  Widget _buildPrimaryDiagnosis(BuildContext context, ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_accent.withValues(alpha: 0.08), scheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: _accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.medical_services_outlined,
              color: _accent,
              size: 22.sp,
            ),
          ),
          const HorizontalGap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.aiScanResultPrimaryDiagnosis.tr(),
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

  Widget _buildStatisticsRow(BuildContext context) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultMedicationOverview.tr(),
      icon: Icons.analytics_rounded,
      child: Row(
        children: [
          _statItem(
            context,
            '${analysis.totalMedications}',
            LocaleKeys.aiScanResultTotal.tr(),
            context.colorScheme.primary,
          ),
          _divider(context),
          _statItem(
            context,
            '${analysis.verifiedMedications}',
            LocaleKeys.aiScanResultVerified.tr(),
            _accent,
          ),
          _divider(context),
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

  Widget _divider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        width: 1,
        height: 40.h,
        color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
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
            style: AppTextStyles.getTextStyle(
              24,
            ).copyWith(color: color, fontWeight: FontWeight.w800),
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

  Widget _buildMedications(BuildContext context) {
    return AnalysisSectionCard(
      title:
          '${LocaleKeys.aiScanResultMedications.tr()} (${analysis.medications.length})',
      icon: Icons.medication_rounded,
      child: Column(
        children: analysis.medications.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: MedicationCard(medication: entry.value, index: entry.key),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotes(BuildContext context) {
    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultAiNotes.tr(),
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
    if (analysis.imageType.isNotEmpty) {
      items[LocaleKeys.aiScanResultImageType.tr()] = analysis.imageType;
    }
    if (analysis.aiJobStatus.isNotEmpty) {
      items[LocaleKeys.aiScanResultAiJobStatus.tr()] = analysis.aiJobStatus;
    }
    if (analysis.aiJobId.isNotEmpty) {
      items[LocaleKeys.aiScanResultAiJobId.tr()] = analysis.aiJobId;
    }
    if (analysis.createdAt.isNotEmpty) {
      items[LocaleKeys.aiScanResultCreatedAt.tr()] = analysis.createdAt;
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
    if (gate.colorSpread > 0) {
      items[LocaleKeys.aiScanResultColorSpread.tr()] =
          gate.colorSpread.toStringAsFixed(2);
    }
    if (gate.intensityStd > 0) {
      items[LocaleKeys.aiScanResultIntensityStd.tr()] =
          gate.intensityStd.toStringAsFixed(2);
    }
    if (gate.colorfulFraction > 0) {
      items[LocaleKeys.aiScanResultColorfulFraction.tr()] =
          gate.colorfulFraction.toStringAsFixed(3);
    }
    items[LocaleKeys.aiScanResultInputValidation.tr()] = gate.passed
        ? LocaleKeys.aiScanResultPassed.tr()
        : LocaleKeys.aiScanResultFailed.tr();
    if (gate.action.isNotEmpty) {
      items[LocaleKeys.aiScanResultAction.tr()] = gate.action;
    }

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultImageQuality.tr(),
      icon: Icons.info_outline_rounded,
      child: AiAnalysisInfoGrid(items: items),
    );
  }
}
