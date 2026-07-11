import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/widgets/custom_card_section.dart';
import 'package:cliniq/core/widgets/custom_divider.dart';
import 'package:cliniq/core/widgets/custom_switch_tile.dart';
import 'package:cliniq/core/widgets/form_section_header.dart';
import 'package:cliniq/core/widgets/labeled_form_field.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';

class EditMedicalInfoSection extends StatelessWidget {
  const EditMedicalInfoSection({
    super.key,
    required this.ailmentsController,
    required this.allergiesController,
    required this.chronicConditionsController,
    required this.hasDiabetes,
    required this.hasPressureIssues,
    required this.onDiabetesChanged,
    required this.onPressureChanged,
  });

  final TextEditingController ailmentsController;
  final TextEditingController allergiesController;
  final TextEditingController chronicConditionsController;
  final bool hasDiabetes;
  final bool hasPressureIssues;
  final ValueChanged<bool> onDiabetesChanged;
  final ValueChanged<bool> onPressureChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FormSectionHeader(
          title: LocaleKeys.profileUserMedicalInfo,
          icon: Icons.medical_services_outlined,
        ),
        CustomCardSection(
          children: [
            LabeledFormField(
              controller: ailmentsController,
              label: LocaleKeys.profileUserAilments,
              hint: LocaleKeys.profileUserAilments,
              maxLines: 3,
            ),
            const VerticalGap(20),
            LabeledFormField(
              controller: allergiesController,
              label: LocaleKeys.profileUserAllergies,
              hint: LocaleKeys.profileUserAllergiesHint,
            ),
            const VerticalGap(20),
            LabeledFormField(
              controller: chronicConditionsController,
              label: LocaleKeys.profileUserChronicConditions,
              hint: LocaleKeys.profileUserChronicConditionsHint,
            ),
            const CustomDivider(),
            CustomSwitchTile(
              title: LocaleKeys.profileUserDiabetes,
              value: hasDiabetes,
              onChanged: onDiabetesChanged,
            ),
            const CustomDivider(),
            CustomSwitchTile(
              title: LocaleKeys.profileUserPressure,
              value: hasPressureIssues,
              onChanged: onPressureChanged,
            ),
          ],
        ),
      ],
    );
  }
}
