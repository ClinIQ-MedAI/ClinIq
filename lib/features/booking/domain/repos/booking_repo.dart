import 'package:dartz/dartz.dart';
import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/features/booking/domain/entities/booking_entity.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';

abstract class BookingRepo {
  Future<Either<Failure, DoctorEntity>> getDoctorById(String doctorId);
  Future<Either<Failure, DoctorSchedulesEntity>> getDoctorSchedules(
    String doctorId,
    String date,
  );
  Future<Either<Failure, void>> createBooking({
    required String doctorId,
    required String date,
    required String time,
  });
  Future<Either<Failure, List<BookingEntity>>> getMyBookings();
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsByDate(String date);
}
