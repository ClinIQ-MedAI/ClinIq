import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/medication_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/analysis_section_card.dart';
import 'package:cliniq/features/ai/presentation/widgets/prescription_raw_medication_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the model's `raw_vlm_output` as structured UI (one tile per detected
/// medication) instead of exposing raw JSON to the user.
class PrescriptionRawVlmSection extends StatelessWidget {
  const PrescriptionRawVlmSection({super.key, required this.medications});

  final List<MedicationEntity> medications;

  @override
  Widget build(BuildContext context) {
    if (medications.isEmpty) return const SizedBox.shrink();

    return AnalysisSectionCard(
      title: LocaleKeys.aiScanResultRawVlmOutput.tr(),
      icon: Icons.document_scanner_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.aiScanResultDetectedMedications.tr(),
            style: AppTextStyles.getTextStyle(12).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const VerticalGap(10),
          ...medications.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: PrescriptionRawMedicationTile(
                medication: entry.value,
                index: entry.key,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
