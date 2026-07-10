import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewConversationSheet extends StatelessWidget {
  const NewConversationSheet({
    super.key,
    required this.doctors,
    required this.onDoctorSelected,
  });

  final List<DoctorEntity> doctors;
  final void Function(DoctorEntity doctor) onDoctorSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          const VerticalGap(20),
          Text(
            LocaleKeys.chatDoctorEmptyTitle.tr(),
            style: AppTextStyles.getTextStyle(18).copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPalette.primaryColor,
            ),
          ),
          const VerticalGap(4),
          Text(
            LocaleKeys.chatDoctorEmptyDescription.tr(),
            style: AppTextStyles.getTextStyle(13).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const VerticalGap(20),
          SizedBox(
            height: doctors.length > 4 ? 320.h : null,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: doctors.length,
              separatorBuilder: (_, __) => const VerticalGap(8),
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return _DoctorItem(
                  doctor: doctor,
                  onTap: () => onDoctorSelected(doctor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorItem extends StatelessWidget {
  const _DoctorItem({required this.doctor, required this.onTap});

  final DoctorEntity doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.colorScheme.primary.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.getTextStyle(15).copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.textPalette.primaryColor,
                      ),
                    ),
                    const VerticalGap(2),
                    Text(
                      doctor.speciality,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.getTextStyle(12).copyWith(
                        color: context.textPalette.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: context.colorScheme.primary,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
