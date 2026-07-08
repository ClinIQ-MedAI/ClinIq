import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_info_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicInfoSection extends StatelessWidget {
  const BasicInfoSection({super.key, required this.phone});

  final String? phone;

  @override
  Widget build(BuildContext context) {
    if (phone == null || phone!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const HorizontalGap(12),
            Text(
              LocaleKeys.profileUserPersonalInfo.tr(),
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
                color: context.colorScheme.primary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: context.colorScheme.primary.withValues(alpha: 0.05),
            ),
          ),
          child: ProfileInfoRow(
            title: LocaleKeys.profileUserPhone,
            value: phone!,
            icon: Icons.phone_android_rounded,
          ),
        ),
      ],
    );
  }
}
