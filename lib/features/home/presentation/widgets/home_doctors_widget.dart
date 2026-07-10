import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/appointments/presentation/screens/booking_screen.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomeDoctorsWidget extends StatelessWidget {
  const HomeDoctorsWidget({
    super.key,
    required this.doctors,
    this.onChatPressed,
  });

  final List<DoctorEntity> doctors;
  final void Function(DoctorEntity doctor)? onChatPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: doctors.length,
        separatorBuilder: (context, index) => const HorizontalGap(16),
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return GestureDetector(
            onTap: () {
              final appointment = ExaminationAppointmentEntity(
                id: doctor.id,
                doctorName: doctor.name,
                doctorSpeciality: doctor.speciality,
                doctorImage: doctor.image,
                appointmentDate: DateFormat(
                  'yyyy-MM-dd',
                ).format(DateTime.now()),
                appointmentTime: '09:00 AM',
                appointmentStatus: 'Available',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(doctor: appointment),
                ),
              );
            },
            child: Container(
              width: 170.w,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: CachedNetworkImage(
                            imageUrl: doctor.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            alignment: Alignment.topCenter,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person, color: Colors.grey),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: context.colorScheme.surfaceContainerHigh,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.red.shade300,
                              size: 14,
                            ),
                          ),
                        ),
                        if (onChatPressed != null)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: GestureDetector(
                              onTap: () => onChatPressed!(doctor),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.surfaceContainerHigh,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: context.colorScheme.primary,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const VerticalGap(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.getTextStyle(15).copyWith(
                            fontWeight: FontWeight.w800,
                            color: context.textPalette.primaryColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const VerticalGap(2),
                        Text(
                          doctor.speciality,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.getTextStyle(13).copyWith(
                            color: context.textPalette.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const VerticalGap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const HorizontalGap(4),
                                Text(
                                  doctor.rating,
                                  style: AppTextStyles.getTextStyle(12)
                                      .copyWith(
                                        color: context.textPalette.primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              '${doctor.experience}',
                              style: AppTextStyles.getTextStyle(11).copyWith(
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
