import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/features/appointments/domain/entities/available_doctor_entity.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvailableDoctorCard extends StatelessWidget {
  const AvailableDoctorCard({super.key, required this.doctor});

  final AvailableDoctorEntity doctor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.bookingScreen,
          arguments: doctor.id,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: context.colorScheme.outline.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoctorAvatar(
                  imageUrl: doctor.imageUrl,
                  name: doctor.name,
                  size: 64,
                ),
                const HorizontalGap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: AppTextStyles.getTextStyle(18).copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.textPalette.primaryColor,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const VerticalGap(4),
                      Text(
                        doctor.specialization,
                        style: AppTextStyles.getTextStyle(14).copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.textPalette.secondaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const VerticalGap(8),
                      // Rating Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16.sp,
                          ),
                          const HorizontalGap(4),
                          Text(
                            doctor.rating.toStringAsFixed(1),
                            style: AppTextStyles.getTextStyle(13).copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.textPalette.primaryColor,
                            ),
                          ),
                          const HorizontalGap(6),
                          Text(
                            "(${doctor.reviewCount} ${LocaleKeys.homeReviews.tr()})",
                            style: AppTextStyles.getTextStyle(12).copyWith(
                              fontWeight: FontWeight.w500,
                              color: context.textPalette.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VerticalGap(16),
            Container(
              height: 1,
              color: context.colorScheme.outline.withValues(alpha: 0.06),
            ),
            const VerticalGap(16),
            // Bottom Section (Availability & Status)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Availability Time
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 20.sp,
                        color: context.colorScheme.primary.withValues(alpha: 0.8),
                      ),
                      const HorizontalGap(8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.homeAvailableToday.tr(),
                              style: AppTextStyles.getTextStyle(13).copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.textPalette.primaryColor,
                              ),
                            ),
                            const VerticalGap(2),
                            Text(
                              "${doctor.startTime} — ${doctor.endTime}",
                              style: AppTextStyles.getTextStyle(12).copyWith(
                                fontWeight: FontWeight.w500,
                                color: context.textPalette.secondaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const HorizontalGap(6),
                      Text(
                        LocaleKeys.homeAvailable.tr(),
                        style: AppTextStyles.getTextStyle(12).copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05);
  }
}
