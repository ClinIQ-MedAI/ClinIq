import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/features/appointments/presentation/screens/booking_screen.dart';
import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';
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
        padding: EdgeInsets.all(16.w),
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
        child: Row(
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
                  width: 64.w,
                  height: 64.w,
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
                      size: 32.sp,
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
                  ),
                  const VerticalGap(4),
                  Text(
                    appointment.doctorSpeciality,
                    style: AppTextStyles.getTextStyle(13).copyWith(
                      color: context.textPalette.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalGap(10),
                  Row(
                    children: [
                      _buildInfoItem(
                        context,
                        Icons.star_rounded,
                        '${appointment.rating} (${appointment.reviewCount})',
                      ),
                      const HorizontalGap(12),
                      _buildInfoItem(
                        context,
                        Icons.access_time_rounded,
                        '${appointment.startTime} - ${appointment.endTime}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05);
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: context.colorScheme.primary),
        const HorizontalGap(4),
        Text(
          label,
          style: AppTextStyles.getTextStyle(12).copyWith(
            fontWeight: FontWeight.w600,
            color: context.textPalette.primaryColor,
          ),
        ),
      ],
    );
  }
}
