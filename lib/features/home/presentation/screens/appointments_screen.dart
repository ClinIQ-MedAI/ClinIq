import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';
import 'package:cliniq/features/home/presentation/providers/get_home_data_provider.dart';
import 'package:cliniq/features/home/presentation/widgets/home_section_empty_state.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(getHomeDataProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: ProfileAppBar(
        title: LocaleKeys.homeAppointmentsScreenTitle.tr(),
      ),
      body: homeDataAsync.when(
        data: (result) => result.fold(
          (failure) => Center(child: Text(failure.message)),
          (homeData) => _buildList(context, homeData.examinationAppointments),
        ),
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<ExaminationAppointmentEntity> appointments,
  ) {
    if (appointments.isEmpty) {
      return Center(
        child: HomeSectionEmptyState(
          icon: Icons.calendar_month_rounded,
          title: LocaleKeys.homeNoAppointments.tr(),
          description: LocaleKeys.homeNoAppointmentsDesc.tr(),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
        itemCount: appointments.length,
        separatorBuilder: (_, __) => const VerticalGap(16),
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: AppTextStyles.getTextStyle(18).copyWith(
                          fontWeight: FontWeight.w800,
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                      const VerticalGap(4),
                      Text(
                        appointment.doctorSpeciality,
                        style: AppTextStyles.getTextStyle(14).copyWith(
                          color: context.colorScheme.onPrimary
                              .withValues(alpha: 0.85),
                        ),
                      ),
                      const VerticalGap(12),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_filled_rounded,
                            color: context.colorScheme.onPrimary,
                            size: 16,
                          ),
                          const HorizontalGap(8),
                          Text(
                            '${appointment.appointmentDate} • ${appointment.appointmentTime}',
                            style: AppTextStyles.getTextStyle(13).copyWith(
                              color: context.colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const HorizontalGap(12),
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: appointment.doctorImage,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.white10,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colorScheme.onPrimary
                            .withValues(alpha: 0.15),
                      ),
                      child: Icon(
                        Icons.person,
                        color: context.colorScheme.onPrimary,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.05);
        },
      ),
    );
  }
}
