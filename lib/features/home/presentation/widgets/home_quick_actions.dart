import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionData(
        icon: Icons.bolt_rounded,
        labelKey: LocaleKeys.homeQuickActionsUrgentCare,
        color: Colors.orange,
      ),
      _ActionData(
        icon: Icons.home_repair_service_rounded,
        labelKey: LocaleKeys.homeQuickActionsHomeVisit,
        color: Colors.blue,
      ),
      _ActionData(
        icon: Icons.local_pharmacy_rounded,
        labelKey: LocaleKeys.homeQuickActionsPharmacies,
        color: Colors.green,
      ),
      _ActionData(
        icon: Icons.videocam_rounded,
        labelKey: LocaleKeys.homeQuickActionsConsultation,
        color: Colors.purple,
      ),
    ];

    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const HorizontalGap(16),
        itemBuilder: (context, index) {
          final action = actions[index];
          return _ActionItem(action: action);
        },
      ),
    );
  }
}

class _ActionData {
  const _ActionData({
    required this.icon,
    required this.labelKey,
    required this.color,
  });

  final IconData icon;
  final String labelKey;
  final Color color;
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.action});

  final _ActionData action;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: action.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: action.color.withValues(alpha: 0.2),
            ),
          ),
          child: Icon(
            action.icon,
            color: action.color,
            size: 28.sp,
          ),
        ),
        const VerticalGap(8),
        Text(
          action.labelKey.tr(),
          style: AppTextStyles.getTextStyle(12).copyWith(
            fontWeight: FontWeight.w600,
            color: context.textPalette.secondaryColor,
          ),
        ),
      ],
    );
  }
}
