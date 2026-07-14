import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/medication_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicationCard extends StatelessWidget {
  const MedicationCard({super.key, required this.medication, this.index});

  final MedicationEntity medication;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final isOfficial = medication.officialMatch;
    final badgeColor =
        isOfficial ? const Color(0xFF4CAF50) : const Color(0xFFFF9800);
    final badgeLabel = isOfficial
        ? LocaleKeys.aiScanResultOfficial.tr()
        : LocaleKeys.aiScanResultUnofficial.tr();

    final title = medication.drug.isNotEmpty
        ? medication.drug
        : medication.drugExtracted;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index != null)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                '#${index! + 1}',
                style: AppTextStyles.getTextStyle(10).copyWith(
                  color: context.textPalette.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Text(
            title,
            style: AppTextStyles.getTextStyle(16).copyWith(
              color: context.textPalette.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const VerticalGap(8),
          if (medication.drugExtracted.isNotEmpty &&
              medication.drugExtracted != medication.drug)
            _infoRow(
              context,
              LocaleKeys.aiScanResultDrugExtracted.tr(),
              medication.drugExtracted,
            ),
          if (medication.drug.isNotEmpty)
            _infoRow(
              context,
              LocaleKeys.aiScanResultOfficialDrugName.tr(),
              medication.drug,
            ),
          if (medication.dosage.isNotEmpty)
            _infoRow(
              context,
              LocaleKeys.aiScanResultDosage.tr(),
              medication.dosage,
            ),
          if (medication.frequency.isNotEmpty)
            _infoRow(
              context,
              LocaleKeys.aiScanResultFrequency.tr(),
              medication.frequency,
            ),
          if (medication.scheduleAr.isNotEmpty)
            _infoRow(
              context,
              LocaleKeys.aiScanResultSchedule.tr(),
              medication.scheduleAr,
            ),
          if (medication.scheduleSource.isNotEmpty)
            _infoRow(
              context,
              LocaleKeys.aiScanResultScheduleSource.tr(),
              medication.scheduleSource,
            ),
          const VerticalGap(8),
          Row(
            children: [
              _confidenceBadge(context, medication.confidenceScore),
              const HorizontalGap(8),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  badgeLabel,
                  style: AppTextStyles.getTextStyle(10).copyWith(
                    color: badgeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: AppTextStyles.getTextStyle(11).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.getTextStyle(12).copyWith(
                color: context.textPalette.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _confidenceBadge(BuildContext context, double score) {
    final pct = (score * 100).toStringAsFixed(0);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: score > 0.7
            ? const Color(0xFF4CAF50).withValues(alpha: 0.12)
            : const Color(0xFFFF9800).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        '$pct% ${LocaleKeys.aiScanResultConfidenceLabel.tr()}',
        style: AppTextStyles.getTextStyle(10).copyWith(
          color: score > 0.7
              ? const Color(0xFF4CAF50)
              : const Color(0xFFFF9800),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
