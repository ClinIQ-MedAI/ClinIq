import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/features/appointments/presentation/widgets/available_doctor_card.dart';
import 'package:cliniq/features/appointments/presentation/widgets/available_doctors_empty_state.dart';
import 'package:cliniq/features/appointments/domain/entities/available_doctor_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvailableDoctorsSection extends StatelessWidget {
  final AsyncValue<List<AvailableDoctorEntity>> doctorsAsync;
  final VoidCallback? onSelectAnotherDate;

  const AvailableDoctorsSection({
    super.key,
    required this.doctorsAsync,
    this.onSelectAnotherDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Icon(
                Icons.person_search_rounded,
                color: context.colorScheme.primary,
                size: 22.sp,
              ),
              const HorizontalGap(8),
              Text(
                LocaleKeys.bookingAvailableDoctors.tr(),
                style: AppTextStyles.getTextStyle(18).copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.textPalette.primaryColor,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const VerticalGap(16),
        Expanded(
          child: doctorsAsync.when(
            data: (doctors) {
              if (doctors.isEmpty) {
                return AvailableDoctorsEmptyState(
                  onSelectAnotherDate: onSelectAnotherDate ?? () {},
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                physics: const BouncingScrollPhysics(),
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  return AvailableDoctorCard(
                    doctor: doctors[index],
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text(error.toString())),
          ),
        ),
      ],
    );
  }
}

