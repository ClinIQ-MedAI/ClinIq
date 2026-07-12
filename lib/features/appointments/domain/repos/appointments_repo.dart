import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/features/appointments/domain/entities/doctor_detail_entity.dart';
import 'package:cliniq/features/appointments/domain/entities/doctor_schedule_entity.dart';
import 'package:cliniq/features/appointments/domain/entities/available_doctor_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AppointmentsRepo {
  Future<Either<Failure, List<AvailableDoctorEntity>>>
  getAvailableDoctors(String date);

  Future<Either<Failure, DoctorScheduleEntity>> getDoctorWorkingHours({
    required String doctorId,
    required String date,
  });

  Future<Either<Failure, DoctorDetailEntity>> getDoctorById({
    required String doctorId,
  });

  Future<Either<Failure, void>> bookAppointment({
    required String doctorId,
    required String date,
    required String time,
  });
}
