import 'package:dartz/dartz.dart';
import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/core/extensions/either_extensions.dart';
import 'package:cliniq/core/repos/base_repo/base_repo_impl.dart';
import 'package:cliniq/features/booking/data/models/booking_model.dart';
import 'package:cliniq/features/booking/domain/entities/booking_entity.dart';
import 'package:cliniq/features/booking/domain/repos/booking_repo.dart';
import 'package:cliniq/features/home/data/models/doctor_model.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';

class BookingRepoImpl extends BaseRepoImpl implements BookingRepo {
  BookingRepoImpl({required super.api});

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorById(String doctorId) async {
    final result = await handleApi(
      () => api.get(EndPoints.getDoctorById(doctorId)),
    );
    return result.fold((failure) => Left(failure), (response) {
      final responseData =
          response is Map ? (response['data'] ?? response) : <String, dynamic>{};
      final doctorData = responseData is Map && responseData.containsKey('doctor')
          ? responseData['doctor']
          : responseData;
      return Right(DoctorModel.fromJson(doctorData as Map<String, dynamic>));
    });
  }

  @override
  Future<Either<Failure, DoctorSchedulesEntity>> getDoctorSchedules(
    String doctorId,
    String date,
  ) async {
    final result = await handleApi(
      () => api.get(
        EndPoints.getDoctorSchedules(doctorId),
        queryParameters: {'date': date},
      ),
    );
    return result.fold((failure) => Left(failure), (response) {
      final data = response is Map
          ? (response['data'] ?? response)
          : <String, dynamic>{};
      return Right(DoctorSchedulesModel.fromJson(data as Map<String, dynamic>));
    });
  }

  @override
  Future<Either<Failure, void>> createBooking({
    required String doctorId,
    required String date,
    required String time,
  }) async {
    return handleApi(
      () => api.post(
        EndPoints.createBooking,
        data: {'doctorId': doctorId, 'date': date, 'time': time},
      ),
    ).asVoid();
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getMyBookings() async {
    final result = await handleApi(() => api.get(EndPoints.getMyBookings));
    return result.fold((failure) => Left(failure), (response) {
      final raw = response is List
          ? response
          : (response['data'] as List? ?? []);
      return Right(
        raw
            .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    });
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsByDate(
    String date,
  ) async {
    final result = await handleApi(
      () =>
          api.get(EndPoints.getDoctorsByDate, queryParameters: {'date': date}),
    );
    return result.fold((failure) => Left(failure), (response) {
      final raw = response is List
          ? response
          : (response['data'] as List? ?? []);
      return Right(
        raw
            .map((item) => DoctorModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    });
  }
}
