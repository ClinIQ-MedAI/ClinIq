import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/utils/image_validation_helper.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/features/appointments/domain/entities/doctor_detail_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailHeader extends StatelessWidget {
  final AsyncValue<DoctorDetailEntity> doctorDetailAsync;

  const DoctorDetailHeader({super.key, required this.doctorDetailAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: doctorDetailAsync.when(
        data: (detail) => Column(
          children: [
            Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: isValidNetworkImage(detail.doctor.image)
                    ? CachedNetworkImage(
                        imageUrl: detail.doctor.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: context.colorScheme.primary
                              .withValues(alpha: 0.05),
                          child: const Center(
                              child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: context.colorScheme.primary
                              .withValues(alpha: 0.05),
                          child: Icon(
                            Icons.person_rounded,
                            color: context.colorScheme.primary,
                            size: 48.sp,
                          ),
                        ),
                      )
                    : Container(
                        color: context.colorScheme.primary
                            .withValues(alpha: 0.05),
                        child: Icon(
                          Icons.person_rounded,
                          color: context.colorScheme.primary,
                          size: 48.sp,
                        ),
                      ),
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
            const VerticalGap(20),
            Text(
              detail.doctor.name,
              style: AppTextStyles.getTextStyle(24).copyWith(
                fontWeight: FontWeight.w900,
                color: context.textPalette.primaryColor,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            const VerticalGap(6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                detail.doctor.speciality,
                style: AppTextStyles.getTextStyle(14).copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
            const VerticalGap(28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildModernStat(
                  context,
                  Icons.star_rounded,
                  detail.doctor.rating,
                  Colors.amber,
                ),
                const HorizontalGap(24),
                _buildModernStat(
                  context,
                  Icons.work_history_rounded,
                  detail.doctor.experience,
                  context.colorScheme.primary,
                ),
                const HorizontalGap(24),
                _buildModernStat(
                  context,
                  Icons.people_alt_rounded,
                  detail.doctor.numberOfAppointments,
                  context.colorScheme.primary,
                ),
              ],
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
        loading: () => Container(
          height: 220.h,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
        error: (error, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildModernStat(
    BuildContext context,
    IconData icon,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        const VerticalGap(8),
        Text(
          value,
          style: AppTextStyles.getTextStyle(13).copyWith(
            fontWeight: FontWeight.w800,
            color: context.textPalette.primaryColor,
          ),
        ),
      ],
    );
  }
}
