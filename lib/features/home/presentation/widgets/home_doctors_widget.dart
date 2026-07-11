import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:cliniq/features/home/presentation/widgets/custom_suggested_doctor_item.dart';
import 'package:cliniq/features/home/presentation/widgets/home_section_empty_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDoctorsWidget extends StatelessWidget {
  const HomeDoctorsWidget({super.key, required this.doctors});

  final List<DoctorEntity> doctors;

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) {
      return HomeSectionEmptyState(
        icon: Icons.person_search_rounded,
        title: LocaleKeys.homeNoDoctors.tr(),
        description: LocaleKeys.homeNoDoctorsDesc.tr(),
      );
    }

    final items = doctors.take(4).toList();

    return SizedBox(
      height: 250.h,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          final doctor = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.doctorDetailsScreen,
                arguments: doctor,
              );
            },
            child: CustomSuggestedDoctorItem(doctor: doctor),
          );
        },
      ),
    );
  }
}
