import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/user/domain/entities/user_profile_entity.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_info_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalInfoSection extends StatelessWidget {
  const MedicalInfoSection({super.key, required this.user});

  final UserProfileEntity user;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    void addRow(String title, String? value, IconData icon, {Color? iconColor}) {
      if (value == null || value.isEmpty) return;
      if (rows.isNotEmpty) {
        rows.add(const Divider(height: 32, thickness: 1, color: Color(0xFFF1F5F9)));
      }
      rows.add(ProfileInfoRow(
        title: title,
        value: value,
        icon: icon,
        iconColor: iconColor,
      ));
    }

    void addSwitchRow(String title, bool? value, IconData icon, {Color? iconColor}) {
      if (value == null || !value) return;
      addRow(title, 'Yes', icon, iconColor: iconColor);
    }

    addRow(LocaleKeys.profileUserHeight, user.height, Icons.height);
    addRow(LocaleKeys.profileUserWeight, user.weight, Icons.monitor_weight_outlined);
    addRow(LocaleKeys.profileUserBloodGroup, user.bloodGroup, Icons.bloodtype_rounded,
        iconColor: Colors.redAccent);
    addRow(LocaleKeys.profileUserAilments, user.ailments, Icons.health_and_safety_rounded,
        iconColor: Colors.orangeAccent);
    addSwitchRow(LocaleKeys.profileUserDiabetes, user.hasDiabetes, Icons.monitor_heart_rounded);
    addSwitchRow(LocaleKeys.profileUserPressure, user.hasPressureIssues, Icons.favorite_border_rounded);
    addRow(LocaleKeys.profileUserAllergies, user.allergies, Icons.warning_amber_rounded);
    addRow(LocaleKeys.profileUserChronicConditions, user.chronicConditions, Icons.medical_information_rounded);

    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: context.colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const HorizontalGap(12),
            Text(
              LocaleKeys.profileUserMedicalInfo.tr(),
              style: AppTextStyles.getTextStyle(18).copyWith(
                fontWeight: FontWeight.w800,
                color: context.textPalette.primaryColor,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const VerticalGap(20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.secondary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: context.colorScheme.secondary.withValues(alpha: 0.05),
            ),
          ),
          child: Column(children: rows),
        ),
      ],
    );
  }
}
