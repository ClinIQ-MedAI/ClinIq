import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/features/appointments/presentation/screens/booking_screen.dart';
import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment});

  final ExaminationAppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(doctorId: appointment.id),
          ),
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
              color: context.colorScheme.primary.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: context.colorScheme.outline.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorScheme.primary.withValues(alpha: 0.1),
                      width: 2.w,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: appointment.doctorImage,
                      width: 60.w,
                      height: 60.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: context.colorScheme.primary.withValues(alpha: 0.05),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: context.colorScheme.primary.withValues(alpha: 0.05),
                        child: Icon(
                          Icons.person_rounded,
                          color: context.colorScheme.primary,
                          size: 30.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                const HorizontalGap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: AppTextStyles.getTextStyle(16).copyWith(
                          fontWeight: FontWeight.w900,
                          color: context.textPalette.primaryColor,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const VerticalGap(4),
                      Text(
                        appointment.doctorSpeciality,
                        style: AppTextStyles.getTextStyle(13).copyWith(
                          color: context.textPalette.secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VerticalGap(16),
            Container(
              height: 1,
              color: context.colorScheme.outline.withValues(alpha: 0.08),
            ),
            const VerticalGap(16),
            Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: 16.sp,
                  color: context.colorScheme.primary,
                ),
                const HorizontalGap(8),
                Text(
                  appointment.appointmentDate,
                  style: AppTextStyles.getTextStyle(13).copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.textPalette.primaryColor,
                  ),
                ),
                const HorizontalGap(20),
                Icon(
                  Icons.access_time_rounded,
                  size: 16.sp,
                  color: context.colorScheme.primary,
                ),
                const HorizontalGap(8),
                Text(
                  appointment.appointmentTime,
                  style: AppTextStyles.getTextStyle(13).copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.textPalette.primaryColor,
                  ),
                ),
              ],
            ),
            const VerticalGap(16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                _statusLabel(context),
                style: AppTextStyles.getTextStyle(12).copyWith(
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05);
  }

  Color _statusColor(BuildContext context) {
    switch (appointment.appointmentStatus.toLowerCase()) {
      case 'upcoming':
        return context.colorScheme.primary;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(BuildContext context) {
    switch (appointment.appointmentStatus.toLowerCase()) {
      case 'upcoming':
        return LocaleKeys.homeUpcoming.tr();
      case 'completed':
        return LocaleKeys.homeCompleted.tr();
      case 'cancelled':
        return LocaleKeys.homeCancelled.tr();
      case 'pending':
        return LocaleKeys.homePending.tr();
      default:
        return appointment.appointmentStatus;
    }
  }
}
