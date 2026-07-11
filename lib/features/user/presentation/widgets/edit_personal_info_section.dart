import 'package:cliniq/core/constants/dropdown_options.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/widgets/birth_date_pick_widget.dart';
import 'package:cliniq/core/widgets/custom_card_section.dart';
import 'package:cliniq/core/widgets/form_section_header.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/labeled_dropdown_form_field.dart';
import 'package:cliniq/core/widgets/labeled_form_field.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';

class EditPersonalInfoSection extends StatelessWidget {
  const EditPersonalInfoSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.mobileController,
    required this.onGenderChanged,
    required this.onDateOfBirthChanged,
    this.gender,
    this.dateOfBirth,
  });

  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<DateTime> onDateOfBirthChanged;
  final String? gender;
  final String? dateOfBirth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FormSectionHeader(
          title: LocaleKeys.profileUserPersonalInfo,
          icon: Icons.person_outline_rounded,
        ),
        CustomCardSection(
          children: [
            Row(
              children: [
                Expanded(
                  child: LabeledFormField(
                    controller: firstNameController,
                    label: LocaleKeys.signupUserFirstName,
                    hint: LocaleKeys.signupUserFirstNameHint,
                  ),
                ),
                const HorizontalGap(16),
                Expanded(
                  child: LabeledFormField(
                    controller: lastNameController,
                    label: LocaleKeys.signupUserLastName,
                    hint: LocaleKeys.signupUserLastNameHint,
                  ),
                ),
              ],
            ),
            const VerticalGap(20),
            LabeledFormField(
              controller: emailController,
              label: LocaleKeys.profileUserEmail,
              hint: LocaleKeys.signupUserEmailHint,
              keyboardType: TextInputType.emailAddress,
            ),
            const VerticalGap(20),
            LabeledFormField(
              controller: mobileController,
              label: LocaleKeys.profileUserMobile,
              hint: LocaleKeys.signupUserPhoneHint,
              keyboardType: TextInputType.phone,
            ),
            const VerticalGap(20),
            LabeledDropdownFormField(
              title: LocaleKeys.profileUserGender,
              hintText: LocaleKeys.profileUserGenderHint,
              items: DropdownOptions.genderOptions,
              selectedValue: gender,
              onChanged: onGenderChanged,
              prefixIcon: Icon(
                Icons.wc_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const VerticalGap(20),
            BirthDatePickWidget(
              onDateSelected: onDateOfBirthChanged,
              icon: Icons.calendar_month_rounded,
              initialDateText: dateOfBirth,
            ),
          ],
        ),
      ],
    );
  }
}
