import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NotificationsAppBar({
    super.key,
    required this.title,
    this.onReadAll,
    this.showReadAll = false,
  });

  final String title;
  final VoidCallback? onReadAll;
  final bool showReadAll;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.getTextStyle(20).copyWith(
          fontWeight: FontWeight.w700,
          color: context.textPalette.primaryColor,
        ),
      ),
      centerTitle: true,
      actions: [
        if (showReadAll && onReadAll != null)
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: TextButton(
              onPressed: onReadAll,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                LocaleKeys.notificationsReadAll.tr(),
                style: AppTextStyles.getTextStyle(13).copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
