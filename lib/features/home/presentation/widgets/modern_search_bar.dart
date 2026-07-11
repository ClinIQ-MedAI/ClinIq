import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModernSearchBar extends StatefulWidget {
  const ModernSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? hintText;

  @override
  State<ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colorScheme.primary;

    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: _isFocused
              ? primaryColor
              : context.colorScheme.outline.withValues(alpha: 0.15),
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _isFocused
                ? primaryColor.withValues(alpha: 0.1)
                : primaryColor.withValues(alpha: 0.04),
            blurRadius: _isFocused ? 20 : 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FocusScope(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          style: AppTextStyles.getTextStyle(14).copyWith(
            color: context.textPalette.primaryColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 18.w,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 22.sp,
              color: _isFocused
                  ? primaryColor
                  : context.textPalette.secondaryColor,
            ),
            hintText: widget.hintText?.tr() ?? LocaleKeys.homeDoctorsSearchHint.tr(),
            hintStyle: AppTextStyles.getTextStyle(14).copyWith(
              color: context.textPalette.secondaryColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      widget.controller.clear();
                      widget.onChanged('');
                    },
                    child: Container(
                      margin: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18.sp,
                        color: primaryColor,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
