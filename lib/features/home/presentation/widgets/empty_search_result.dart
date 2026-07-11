import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptySearchResult extends StatelessWidget {
  const EmptySearchResult({
    super.key,
    this.onClearSearch,
  });

  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 44.sp,
                color: context.colorScheme.primary,
              ),
            ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
            const VerticalGap(24),
            Text(
              LocaleKeys.homeNoSearchResults.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(20).copyWith(
                color: context.textPalette.primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            const VerticalGap(12),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 280.w),
              child: Text(
                LocaleKeys.homeNoSearchResultsDesc.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.getTextStyle(14).copyWith(
                  color: context.textPalette.secondaryColor,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ).animate().fadeIn(delay: 350.ms),
            if (onClearSearch != null) ...[
              const VerticalGap(28),
              OutlinedButton(
                onPressed: onClearSearch,
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.colorScheme.primary,
                  side: BorderSide(
                    color: context.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                ),
                child: Text(
                  LocaleKeys.homeClearSearch.tr(),
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
            ],
          ],
        ),
      ),
    );
  }
}
