import 'package:cliniq/core/services/get_it_service.dart';
import 'package:cliniq/features/booking/domain/entities/booking_entity.dart';
import 'package:cliniq/features/booking/domain/repos/booking_repo.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookingRepoProvider = Provider<BookingRepo>((ref) => getIt<BookingRepo>());

final doctorDetailsProvider = FutureProvider.family<DoctorEntity, String>(
  (ref, doctorId) async {
    final repo = ref.read(bookingRepoProvider);
    final result = await repo.getDoctorById(doctorId);
    return result.fold(
      (failure) => throw failure.message,
      (doctor) => doctor,
    );
  },
);

final doctorSchedulesProvider =
    FutureProvider.family<DoctorSchedulesEntity, ({String doctorId, String date})>(
  (ref, params) async {
    final repo = ref.read(bookingRepoProvider);
    final result = await repo.getDoctorSchedules(params.doctorId, params.date);
    return result.fold(
      (failure) => throw failure.message,
      (schedules) => schedules,
    );
  },
);

final myBookingsProvider = FutureProvider<List<BookingEntity>>(
  (ref) async {
    final repo = ref.read(bookingRepoProvider);
    final result = await repo.getMyBookings();
    return result.fold(
      (failure) => throw failure.message,
      (bookings) => bookings,
    );
  },
);

final createBookingProvider =
    FutureProvider.family<void, ({String doctorId, String date, String time})>(
  (ref, params) async {
    final repo = ref.read(bookingRepoProvider);
    final result = await repo.createBooking(
      doctorId: params.doctorId,
      date: params.date,
      time: params.time,
    );
    return result.fold(
      (failure) => throw failure.message,
      (_) {},
    );
  },
);
