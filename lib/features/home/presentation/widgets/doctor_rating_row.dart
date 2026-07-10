import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorRatingRow extends StatelessWidget {
  const DoctorRatingRow({
    super.key,
    required this.rating,
  });

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: Colors.amber,
          size: 18.sp,
        ),
        SizedBox(width: 4.w),
        Text(
          rating,
          style: AppTextStyles.getTextStyle(13).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
