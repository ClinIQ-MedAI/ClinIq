import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_avatar.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_rating_row.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_speciality_chip.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_stats.dart';
import 'package:cliniq/features/home/presentation/widgets/start_chat_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  final DoctorEntity doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(26.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.all(18.w),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(color: scheme.outline.withValues(alpha: .08)),
          boxShadow: [
            BoxShadow(
              blurRadius: 25,
              offset: const Offset(0, 10),
              color: scheme.shadow.withValues(alpha: .08),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoctorAvatar(
                  imageUrl: doctor.image,
                  name: doctor.name,
                  size: 74.r,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.getTextStyle(18).copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      DoctorSpecialityChip(speciality: doctor.speciality),
                      SizedBox(height: 12.h),
                      DoctorRatingRow(rating: doctor.rating),
                    ],
                  ),
                ),
              ],
            ),
            const VerticalGap(20),
            Divider(height: 1, color: scheme.outline.withValues(alpha: .15)),
            const VerticalGap(18),
            DoctorStats(experience: doctor.experience),
            const VerticalGap(20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      side: BorderSide(
                        color: scheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      LocaleKeys.homeViewProfile.tr(),
                      style: AppTextStyles.getTextStyle(13).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: StartChatButton(
                    doctorId: doctor.id,
                    doctorName: doctor.name,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
