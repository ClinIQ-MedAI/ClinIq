import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/core/repos/base_repo/base_repo_impl.dart';
import 'package:cliniq/features/home/data/models/doctor_model.dart';
import 'package:cliniq/features/home/data/models/examination_appointment_model.dart';
import 'package:cliniq/features/home/data/models/news_model.dart';
import 'package:cliniq/features/home/data/models/specialization_model.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';
import 'package:cliniq/features/home/domain/entities/get_home_data_entity.dart';
import 'package:cliniq/features/home/domain/entities/news_entity.dart';
import 'package:cliniq/features/home/domain/entities/specialization_entity.dart';
import 'package:cliniq/features/home/domain/repos/home_repo.dart';
import 'package:dartz/dartz.dart';

class HomeRepoImpl extends BaseRepoImpl implements HomeRepo {
  HomeRepoImpl({required super.api});

  @override
  Future<Either<Failure, List<SpecializationEntity>>>
  getSpecializations() async {
    final result = await handleApi(() => api.get(EndPoints.specializations));
    return result.fold((failure) => Left(failure), (data) {
      final list = (data['data'] as List)
          .map((e) => SpecializationModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> getSuggestedDoctors() async {
    final result = await handleApi(() => api.get(EndPoints.suggestedDoctors));
    return result.fold((failure) => Left(failure), (data) {
      final list = (data['data'] as List)
          .map((e) => DoctorModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews() async {
    final result = await handleApi(() => api.get(EndPoints.news));
    return result.fold((failure) => Left(failure), (data) {
      final list = (data['data'] as List)
          .map((e) => NewsModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<ExaminationAppointmentEntity>>>
  getExaminationAppointments() async {
    final result = await handleApi(
      () => api.get(EndPoints.examinationAppointments),
    );
    return result.fold((failure) => Right([]), (data) {
      final list = (data['data'] as List)
          .map((e) => ExaminationAppointmentModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, GetHomeDataEntity>> getHomeData() async {
    final res = await Future.wait([
      getSpecializations(),
      getSuggestedDoctors(),
      getNews(),
      getExaminationAppointments(),
    ]);

    final specializationsResult =
        res[0] as Either<Failure, List<SpecializationEntity>>;
    final doctorsResult = res[1] as Either<Failure, List<DoctorEntity>>;
    final newsResult = res[2] as Either<Failure, List<NewsEntity>>;
    final appointmentsResult =
        res[3] as Either<Failure, List<ExaminationAppointmentEntity>>;

    return specializationsResult.fold(
      (failure) => Left(failure),
      (specializations) => doctorsResult.fold(
        (failure) => Left(failure),
        (doctors) => newsResult.fold(
          (failure) => Left(failure),
          (news) => appointmentsResult.fold(
            (failure) => Left(failure),
            (appointments) => Right(
              GetHomeDataEntity(
                specializations: specializations,
                suggestedDoctors: doctors,
                news: news,
                examinationAppointments: appointments,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
