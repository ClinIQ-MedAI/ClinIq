import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/appointments/presentation/providers/book_appointment_provider.dart';
import 'package:cliniq/features/appointments/presentation/providers/get_doctor_by_id_provider.dart';
import 'package:cliniq/features/appointments/presentation/widgets/booking/about_doctor_section.dart';
import 'package:cliniq/features/appointments/presentation/widgets/booking/booking_date_selector.dart';
import 'package:cliniq/features/appointments/presentation/widgets/booking/confirm_booking_button.dart';
import 'package:cliniq/features/appointments/presentation/widgets/booking/doctor_chat_section.dart';
import 'package:cliniq/features/appointments/presentation/widgets/booking/doctor_detail_header.dart';
import 'package:cliniq/features/appointments/presentation/widgets/booking/working_hours_section.dart';
import 'package:cliniq/features/home/presentation/providers/get_home_data_provider.dart';
import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String doctorId;

  const BookingScreen({super.key, required this.doctorId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  String? selectedFullDate;

  @override
  Widget build(BuildContext context) {
    final doctorDetailAsync = ref.watch(getDoctorByIdProvider(widget.doctorId));

    ref.listen(bookAppointmentProvider, (previous, next) {
      if (next is AsyncError) {
        showCustomSnackBar(context, next.error.toString());
      } else if (next is AsyncData && next.value is Success) {
        showCustomSnackBar(
          context,
          LocaleKeys.messagesSuccessAppointmentBookedSuccessfully,
        );

        final doctorDetail = doctorDetailAsync.value;
        if (doctorDetail != null && selectedFullDate != null) {
          final newAppointment = ExaminationAppointmentEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            doctorName: doctorDetail.doctor.name,
            doctorSpeciality: doctorDetail.doctor.speciality,
            doctorImage: doctorDetail.doctor.image,
            appointmentDate: selectedFullDate!,
            appointmentTime: "09:00 AM",
            appointmentStatus: "Upcoming",
          );
          ref.read(getHomeDataProvider.notifier).addAppointment(newAppointment);
        }

        Navigator.pop(context);
      }
    });

    final bookingState = ref.watch(bookAppointmentProvider);
    final isBookingLoading = bookingState.isLoading;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: ProfileAppBar(title: LocaleKeys.bookingBooking),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorDetailHeader(doctorDetailAsync: doctorDetailAsync),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: doctorDetailAsync.when(
                data: (detail) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AboutDoctorSection(doctor: detail.doctor),
                      const VerticalGap(32),
                      WorkingHoursSection(
                        weeklySchedule: detail.schedule.weeklySchedule,
                      ),
                      const VerticalGap(32),
                      BookingDateSelector(
                        dates: detail.schedule.dates,
                        selectedFullDate: selectedFullDate,
                        onDateSelected: (date) =>
                            setState(() => selectedFullDate = date),
                      ),
                      const VerticalGap(32),
                      DoctorChatSection(doctor: detail.doctor),
                      const VerticalGap(32),
                      ConfirmBookingButton(
                        isLoading: isBookingLoading,
                        isEnabled: selectedFullDate != null,
                        onPressed: () {
                          final userProfile = ref.watch(currentUserProvider);
                          final isProfileCompleted =
                              userProfile?.isProfileCompleted ?? false;
                          if (isProfileCompleted) {
                            ref
                                .read(bookAppointmentProvider.notifier)
                                .book(
                                  doctorId: widget.doctorId,
                                  date: selectedFullDate!,
                                );
                          } else {
                            showCustomSnackBar(
                              context,
                              "You must compelete your profile first before booking",
                            );
                          }
                        },
                      ),
                      const VerticalGap(32),
                    ],
                  );
                },
                loading: () =>
                    const SizedBox.shrink(), // Header handles loading
                error: (error, _) => Center(child: Text(error.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
