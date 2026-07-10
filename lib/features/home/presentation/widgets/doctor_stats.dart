import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorStats extends StatelessWidget {
  const DoctorStats({
    super.key,
    required this.experience,
  });

  final String experience;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(
          icon: Icons.workspace_premium,
          title: '$experience ${LocaleKeys.homeYearsExp.tr()}',
        ),
        const _StatDivider(),
        _StatItem(
          icon: Icons.people_alt_rounded,
          title: LocaleKeys.homeProfessional.tr(),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: context.colorScheme.primary),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.getTextStyle(12).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        width: 1,
        height: 20.h,
        color: context.colorScheme.outline.withValues(alpha: 0.15),
      ),
    );
  }
}
