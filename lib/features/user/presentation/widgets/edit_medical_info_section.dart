import 'dart:developer';

import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/widgets/custom_card_section.dart';
import 'package:cliniq/core/widgets/form_section_header.dart';
import 'package:cliniq/core/widgets/labeled_form_field.dart';
import 'package:flutter/material.dart';

class EditMedicalInfoSection extends StatelessWidget {
  const EditMedicalInfoSection({super.key, required this.ailmentsController});

  final TextEditingController ailmentsController;

  @override
  Widget build(BuildContext context) {
    log(ailmentsController.text.toString());
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
          ],
        ),
      ],
    );
  }
}
