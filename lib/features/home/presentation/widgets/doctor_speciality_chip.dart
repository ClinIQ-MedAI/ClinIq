import 'package:cliniq/core/extensions/doctor_speciality_extension.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorSpecialityChip extends StatelessWidget {
  const DoctorSpecialityChip({
    super.key,
    required this.speciality,
  });

  final String speciality;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        speciality.localizedSpeciality,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.getTextStyle(12).copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
