import 'dart:convert';

import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_info_grid.dart';
import 'package:cliniq/features/ai/presentation/widgets/analysis_section_card.dart';
import 'package:cliniq/features/ai/presentation/widgets/medication_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrescriptionAnalysisBody extends StatelessWidget {
  const PrescriptionAnalysisBody({super.key, required this.analysis});

  final PrescriptionAnalysisEntity analysis;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      children: [
        _buildStatusHeader(context, scheme),
        const VerticalGap(12),
        _buildScanImage(context),
        const VerticalGap(12),
        _buildStatisticsRow(context),
        if (analysis.summary.isNotEmpty) ...[
          const VerticalGap(12),
          _buildSummary(context),
        ],
        const VerticalGap(12),
        _buildMedications(context),
        if (analysis.aiFindingsNotes.isNotEmpty) ...[
          const VerticalGap(12),
          _buildNotes(context),
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
                  'Prescription Analysis',
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
      title: 'Uploaded Prescription',
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
              color: context.colorScheme.surfaceContainerHighest,
            ),
            child: analysis.scanBase64.isNotEmpty
                ? Image.memory(
                    base64Decode(analysis.scanBase64),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image_outlined,
                      color: context.colorScheme.error,
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
    return AnalysisSectionCard(
      title: 'Medication Overview',
      icon: Icons.analytics_rounded,
      child: Row(
        children: [
          _statItem(
            context,
            '${analysis.totalMedications}',
            'Total',
            context.colorScheme.primary,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              width: 1,
              height: 40.h,
              color: context.colorScheme.outlineVariant
                  .withValues(alpha: 0.3),
            ),
          ),
          _statItem(
            context,
            '${analysis.verifiedMedications}',
            'Verified',
            const Color(0xFF4CAF50),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              width: 1,
              height: 40.h,
              color: context.colorScheme.outlineVariant
                  .withValues(alpha: 0.3),
            ),
          ),
          _statItem(
            context,
            '${analysis.totalMedications - analysis.verifiedMedications}',
            'Unverified',
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

  Widget _buildSummary(BuildContext context) {
    return AnalysisSectionCard(
      title: 'Summary',
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
      title: 'Medications (${analysis.medications.length})',
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
      title: 'AI Notes',
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

  Widget _buildInputInfo(BuildContext context) {
    final gate = analysis.inputGate;
    final Map<String, String> items = {};
    if (gate.width > 0) {
      items['Width'] = '${gate.width}px';
    }
    if (gate.height > 0) {
      items['Height'] = '${gate.height}px';
    }
    if (gate.aspectRatio > 0) {
      items['Aspect Ratio'] = gate.aspectRatio.toStringAsFixed(2);
    }
    items['Validation'] = gate.passed ? 'Passed' : 'Failed';
    if (gate.action.isNotEmpty) {
      items['Action'] = gate.action;
    }
    if (gate.intensityStd > 0) {
      items['Intensity Std'] = gate.intensityStd.toStringAsFixed(2);
    }
    if (gate.colorSpread > 0) {
      items['Color Spread'] = gate.colorSpread.toStringAsFixed(2);
    }
    if (gate.colorfulFraction > 0) {
      items['Colorful Fraction'] = gate.colorfulFraction.toStringAsFixed(2);
    }

    return AnalysisSectionCard(
      title: 'Input Validation',
      icon: Icons.info_outline_rounded,
      child: AiAnalysisInfoGrid(items: items),
    );
  }
}
