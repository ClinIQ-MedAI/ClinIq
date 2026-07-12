import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/features/home/presentation/providers/get_home_repo_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/features/home/domain/entities/get_home_data_entity.dart';

import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';

class GetHomeDataNotifier extends AsyncNotifier<Either<Failure, GetHomeDataEntity>> {
  @override
  Future<Either<Failure, GetHomeDataEntity>> build() {
    return ref.read(getHomeRepoProvider).getHomeData();
  }

  void addAppointment(ExaminationAppointmentEntity newAppointment) {
    state.whenData((either) {
      either.fold(
        (failure) {
          // If the current state is a failure, do nothing.
        },
        (data) {
          // Check for duplicates
          if (data.examinationAppointments.any((e) => e.id == newAppointment.id)) return;

          // Insert at top
          final updatedAppointments = [
            newAppointment,
            ...data.examinationAppointments
          ];

          final updatedData = GetHomeDataEntity(
            specializations: data.specializations,
            suggestedDoctors: data.suggestedDoctors,
            news: data.news,
            examinationAppointments: updatedAppointments,
          );
          
          state = AsyncData(Right(updatedData));
        },
      );
    });
  }
}

final getHomeDataProvider = AsyncNotifierProvider<GetHomeDataNotifier, Either<Failure, GetHomeDataEntity>>(
  () => GetHomeDataNotifier(),
);
