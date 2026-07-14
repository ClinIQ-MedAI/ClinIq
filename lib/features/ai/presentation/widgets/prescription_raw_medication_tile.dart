import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/medication_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A compact, expandable tile representing a single medication detected in the
/// raw VLM output.
class PrescriptionRawMedicationTile extends StatelessWidget {
  const PrescriptionRawMedicationTile({
    super.key,
    required this.medication,
    required this.index,
  });

  final MedicationEntity medication;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final title = medication.drugExtracted.isNotEmpty
        ? medication.drugExtracted
        : medication.drug;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(),
          tilePadding: EdgeInsets.symmetric(horizontal: 12.w),
          childrenPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: Container(
            width: 28.r,
            height: 28.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${index + 1}',
              style: AppTextStyles.getTextStyle(12).copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          title: Text(
            '${LocaleKeys.aiScanResultMedication.tr()} ${index + 1}',
            style: AppTextStyles.getTextStyle(11).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: title.isEmpty
              ? null
              : Text(
                  title,
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
          children: [
            if (medication.dosage.isNotEmpty)
              _row(context, LocaleKeys.aiScanResultDosage.tr(),
                  medication.dosage),
            if (medication.frequency.isNotEmpty)
              _row(context, LocaleKeys.aiScanResultFrequency.tr(),
                  medication.frequency),
            if (medication.scheduleAr.isNotEmpty)
              _row(context, LocaleKeys.aiScanResultSchedule.tr(),
                  medication.scheduleAr),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.getTextStyle(11).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const VerticalGap(2),
          Text(
            value,
            style: AppTextStyles.getTextStyle(13).copyWith(
              color: context.textPalette.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
