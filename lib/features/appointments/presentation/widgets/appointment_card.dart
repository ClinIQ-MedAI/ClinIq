import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/features/appointments/presentation/screens/booking_screen.dart';
import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment});

  final ExaminationAppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: context.colorScheme.outline.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                DoctorAvatar(
                  imageUrl: appointment.doctorImage,
                  name: appointment.doctorName,
                  size: 56,
                ),
                const HorizontalGap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: AppTextStyles.getTextStyle(16).copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.textPalette.primaryColor,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const VerticalGap(4),
                      Text(
                        appointment.doctorSpeciality,
                        style: AppTextStyles.getTextStyle(13).copyWith(
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
            const VerticalGap(20),
            Container(
              height: 1,
              color: context.colorScheme.outline.withValues(alpha: 0.06),
            ),
            const VerticalGap(20),
            _InfoRow(
              icon: Icons.calendar_month_rounded,
              text: appointment.appointmentDate,
            ),
            const VerticalGap(12),
            _InfoRow(
              icon: Icons.access_time_rounded,
              text: appointment.appointmentTime,
            ),
            const VerticalGap(20),
            Container(
              height: 1,
              color: context.colorScheme.outline.withValues(alpha: 0.06),
            ),
            const VerticalGap(20),
            Center(
              child: _StatusBadge(status: appointment.appointmentStatus),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: context.colorScheme.primary.withValues(alpha: 0.8),
        ),
        const HorizontalGap(12),
        Text(
          text,
          style: AppTextStyles.getTextStyle(14).copyWith(
            fontWeight: FontWeight.w500,
            color: context.textPalette.primaryColor,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final statusLower = status.toLowerCase();
    
    Color color = context.colorScheme.primary;
    String label = status;
    
    if (statusLower == 'upcoming') {
      color = Colors.green;
      label = LocaleKeys.homeUpcoming.tr();
    } else if (statusLower == 'pending') {
      color = Colors.orange;
      label = LocaleKeys.homePending.tr();
    } else if (statusLower == 'completed') {
      color = Colors.blue;
      label = LocaleKeys.homeCompleted.tr();
    } else if (statusLower == 'cancelled') {
      color = Colors.red;
      label = LocaleKeys.homeCancelled.tr();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const HorizontalGap(8),
          Text(
            label,
            style: AppTextStyles.getTextStyle(13).copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
