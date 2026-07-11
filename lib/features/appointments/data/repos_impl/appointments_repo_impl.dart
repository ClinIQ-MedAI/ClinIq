import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/core/repos/base_repo/base_repo_impl.dart';
import 'package:cliniq/features/appointments/domain/repos/appointments_repo.dart';
import 'package:cliniq/features/home/data/models/examination_appointment_model.dart';
import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';
import 'package:dartz/dartz.dart';

import 'package:cliniq/features/appointments/domain/entities/doctor_detail_entity.dart';
import 'package:cliniq/features/appointments/domain/entities/doctor_schedule_entity.dart';
import 'package:cliniq/features/appointments/data/models/doctor_details_model.dart';

class AppointmentsRepoImpl extends BaseRepoImpl implements AppointmentsRepo {
  AppointmentsRepoImpl({required super.api});

  @override
  Future<Either<Failure, List<ExaminationAppointmentEntity>>>
  getAvailableDoctors(String date) async {
    final result = await handleApi(
      () =>
          api.get(EndPoints.getDoctorsByDate, queryParameters: {'date': date}),
    );
    return result.fold((failure) => Left(failure), (data) {
      final list = (data as List)
          .map((e) => ExaminationAppointmentModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, DoctorScheduleEntity>> getDoctorWorkingHours({
    required String doctorId,
    required String date,
  }) async {
    final result = await handleApi(
      () => api.get(
        EndPoints.getDoctorSchedules(doctorId),
        queryParameters: {'date': date},
      ),
    );
    return result.fold((failure) => Left(failure), (data) {
      final scheduleData = data['data'] as Map<String, dynamic>;

      final weeklySchedule = (scheduleData['weeklySchedule'] as List)
          .map((e) => WorkingDayRangeEntity(day: e['day'], range: e['range']))
          .toList();

      final dates = (scheduleData['dates'] as List)
          .map(
            (e) => DoctorDateAvailabilityEntity(
              day: e['day'],
              date: e['date'],
              month: e['month'],
              fullDate: e['fullDate'],
              patientCount: e['patientCount'],
              isFull: e['isFull'],
            ),
          )
          .toList();

      return Right(
        DoctorScheduleEntity(weeklySchedule: weeklySchedule, dates: dates),
      );
    });
  }

  @override
  Future<Either<Failure, DoctorDetailEntity>> getDoctorById({
    required String doctorId,
  }) async {
    final result = await handleApi(
      () => api.get(EndPoints.getDoctorById(doctorId)),
    );
    return result.fold((failure) => Left(failure), (data) {
      final responseData = data['data'] as Map<String, dynamic>;
      final doctorDetail = DoctorDetailsModel.fromJson(responseData);
      return Right(doctorDetail);
    });
  }

  @override
  Future<Either<Failure, void>> bookAppointment({
    required String doctorId,
    required String date,
    required String time,
  }) async {
    final result = await handleApi(
      () => api.post(
        EndPoints.createBooking,
        data: {'doctorId': doctorId, 'date': date, 'time': time},
      ),
    );
    return result.fold((failure) => Left(failure), (data) => const Right(null));
  }
}
