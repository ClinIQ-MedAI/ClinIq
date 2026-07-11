import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingSuccessDialog extends StatelessWidget {
  const BookingSuccessDialog({
    super.key,
    required this.doctorName,
    this.bookingNumber,
  });

  final String doctorName;
  final String? bookingNumber;

  static Future<void> show(
    BuildContext context, {
    required String doctorName,
    String? bookingNumber,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BookingSuccessDialog(
        doctorName: doctorName,
        bookingNumber: bookingNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 56,
              ),
            ),
            const VerticalGap(24),
            Text(
              LocaleKeys.bookingSuccessTitle.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(24).copyWith(
                fontWeight: FontWeight.w900,
                color: context.textPalette.primaryColor,
              ),
            ),
            const VerticalGap(12),
            Text(
              LocaleKeys.bookingSuccessMessage.tr(args: [doctorName]),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(15).copyWith(
                color: context.textPalette.secondaryColor,
                height: 1.5,
              ),
            ),
            if (bookingNumber != null) ...[
              const VerticalGap(16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  bookingNumber!,
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
            ],
            const VerticalGap(28),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: Text(
                  LocaleKeys.bookingDone.tr(),
                  style: AppTextStyles.getTextStyle(16).copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
