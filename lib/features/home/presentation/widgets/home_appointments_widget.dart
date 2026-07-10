import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';
import 'package:cliniq/features/home/presentation/widgets/home_section_empty_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeAppointmentsWidget extends StatefulWidget {
  const HomeAppointmentsWidget({
    super.key,
    required this.appointments,
    this.onBookAppointment,
  });

  final List<ExaminationAppointmentEntity> appointments;
  final VoidCallback? onBookAppointment;

  @override
  State<HomeAppointmentsWidget> createState() => _HomeAppointmentsWidgetState();
}

class _HomeAppointmentsWidgetState extends State<HomeAppointmentsWidget> {
  late PageController _pageController;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appointments.isEmpty) {
      return HomeSectionEmptyState(
        icon: Icons.calendar_month_rounded,
        title: LocaleKeys.homeNoAppointments.tr(),
        description: LocaleKeys.homeNoAppointmentsDesc.tr(),
        action: widget.onBookAppointment != null
            ? CustomButton(
                text: LocaleKeys.homeBookAppointment.tr(),
                onPressed: widget.onBookAppointment,
                width: 200,
                height: 44,
                borderRadius: 14,
                textFontSize: 14,
              )
            : null,
      );
    }

    final appointments = widget.appointments.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: appointments.length,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final delta = index - _currentPage;

              final double scale = (1 - (delta.abs() * 0.1)).clamp(0.8, 1.0);
              final double opacity = (1 - (delta.abs() * 0.5)).clamp(0.0, 1.0);
              final double translation = delta * 60.0;

              return Opacity(
                opacity: opacity,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(translation)
                      ..scale(scale),
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.colorScheme.primary,
                          context.colorScheme.primaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32.r),
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.onPrimary
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'UPCOMING',
                                  style: AppTextStyles.getTextStyle(10)
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.2,
                                      ),
                                ),
                              ),
                              const VerticalGap(12),
                              Text(
                                appointment.doctorName,
                                style: AppTextStyles.getTextStyle(20).copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: context.colorScheme.onPrimary,
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const VerticalGap(4),
                              Text(
                                appointment.doctorSpeciality,
                                style: AppTextStyles.getTextStyle(15).copyWith(
                                  color: context.colorScheme.onPrimary
                                      .withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const VerticalGap(16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.onPrimary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time_filled_rounded,
                                      color: context.colorScheme.onPrimary,
                                      size: 16,
                                    ),
                                    const HorizontalGap(8),
                                    Text(
                                      '${appointment.appointmentDate} • ${appointment.appointmentTime}',
                                      style: AppTextStyles.getTextStyle(13)
                                          .copyWith(
                                            color:
                                                context.colorScheme.onPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const HorizontalGap(8),
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: appointment.doctorImage,
                            width: 90.w,
                            height: 90.w,
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
                              width: 90.w,
                              height: 90.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.colorScheme.onPrimary
                                    .withValues(alpha: 0.15),
                              ),
                              child: Icon(
                                Icons.person,
                                color: context.colorScheme.onPrimary,
                                size: 36.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (appointments.length > 1) ...[
          const VerticalGap(20),
          Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: appointments.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8.h,
                dotWidth: 8.h,
                activeDotColor: context.colorScheme.primary,
                dotColor: context.colorScheme.primary.withValues(alpha: 0.2),
                expansionFactor: 4,
                spacing: 8.w,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
