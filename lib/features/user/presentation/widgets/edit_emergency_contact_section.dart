import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/widgets/custom_card_section.dart';
import 'package:cliniq/core/widgets/form_section_header.dart';
import 'package:cliniq/core/widgets/labeled_form_field.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';

class EditEmergencyContactSection extends StatelessWidget {
  const EditEmergencyContactSection({
    super.key,
    required this.emergencyNameController,
    required this.emergencyPhoneController,
  });

  final TextEditingController emergencyNameController;
  final TextEditingController emergencyPhoneController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FormSectionHeader(
          title: LocaleKeys.profileUserEmergencySection,
          icon: Icons.contact_emergency_rounded,
        ),
        CustomCardSection(
          children: [
            LabeledFormField(
              controller: emergencyNameController,
              label: LocaleKeys.profileUserEmergencyContactName,
              hint: LocaleKeys.profileUserEmergencyContactNameHint,
            ),
            const VerticalGap(20),
            LabeledFormField(
              controller: emergencyPhoneController,
              label: LocaleKeys.profileUserEmergencyContactPhone,
              hint: LocaleKeys.profileUserEmergencyContactPhoneHint,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ],
    );
  }
}
