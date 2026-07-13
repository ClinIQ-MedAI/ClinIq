import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalysisSectionCard extends StatelessWidget {
  const AnalysisSectionCard({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
    this.trailing,
    required this.child,
    this.padding,
  });

  final String title;
  final IconData? icon;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null || subtitle != null || trailing != null)
            _header(scheme)
          else
            _titleOnly(scheme),
          const VerticalGap(14),
          child,
        ],
      ),
    );
  }

  Widget _titleOnly(ColorScheme scheme) {
    return Text(
      title,
      style: AppTextStyles.getTextStyle(13).copyWith(
        color: scheme.onSurface.withValues(alpha: 0.5),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _header(ColorScheme scheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18.sp, color: scheme.primary),
          SizedBox(width: 8.w),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextStyles.getTextStyle(13).copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    subtitle!,
                    style: AppTextStyles.getTextStyle(10).copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.35),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
