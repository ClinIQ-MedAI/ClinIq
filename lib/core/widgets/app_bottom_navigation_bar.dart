import 'package:cliniq/core/constants/dropdown_options.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });
  final int selectedIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.15),
            offset: const Offset(0, -10),
            blurRadius: 30,
            spreadRadius: -5,
          ),
        ],
      ),
      child: CurvedNavigationBar(
        height: 75.h,
        backgroundColor: Colors.transparent,
        color: context.colorScheme.surface,
        buttonBackgroundColor: context.colorScheme.primary,
        animationCurve: Curves.elasticOut,
        animationDuration: const Duration(milliseconds: 600),
        index: selectedIndex,
        items: List.generate(DropdownOptions.bottomNavItems.length, (index) {
          final isSelected = selectedIndex == index;

          return CurvedNavigationBarItem(
            label: isSelected ? _getLabel(index).tr() : null,
            labelStyle: AppTextStyles.getTextStyle(11).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
            child: _buildIcon(context, index, isSelected),
          );
        }),
        onTap: onTap,
      ),
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return LocaleKeys.homeTitle;
      case 1:
        return LocaleKeys.homeExaminationAppointments;
      case 2:
        return LocaleKeys.bottomNavigationBarAiChat;
      case 3:
        return LocaleKeys.bottomNavigationBarDoctorChat;
      case 4:
        return LocaleKeys.profileUserTitle;
      default:
        return '';
    }
  }

  Widget _buildIcon(BuildContext context, int index, bool isSelected) {
    IconData icon;
    bool isAi = index == 2;
    switch (index) {
      case 0:
        icon = isSelected ? Icons.dashboard_rounded : Icons.dashboard_outlined;
        break;
      case 1:
        icon = isSelected
            ? Icons.calendar_month
            : Icons.calendar_month_outlined;
        break;
      case 2:
        icon = Icons.auto_awesome_rounded;
        break;
      case 3:
        icon = isSelected ? Icons.chat_rounded : Icons.chat_outlined;
        break;
      case 4:
        icon = isSelected ? Icons.person_rounded : Icons.person_outline_rounded;
        break;
      default:
        icon = Icons.help_outline;
    }

    return Container(
      padding: EdgeInsets.all(isAi ? 10.w : 6.w),
      decoration: BoxDecoration(
        color: isAi && !isSelected
            ? context.colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        shape: BoxShape.circle,
        border: isAi && !isSelected
            ? Border.all(
                color: context.colorScheme.primary.withValues(alpha: 0.25),
                width: 1.5,
              )
            : null,
      ),
      child: Icon(
        icon,
        size: isSelected ? (isAi ? 34.sp : 30.sp) : (isAi ? 28.sp : 26.sp),
        color: isSelected
            ? Colors.white
            : (isAi
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurface.withValues(alpha: 0.75)),
      ),
    );
  }
}
