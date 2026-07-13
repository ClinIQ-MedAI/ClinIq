import 'package:cliniq/core/extensions/either_extensions.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/features/appointments/presentation/providers/appointments_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookAppointmentProvider =
    AsyncNotifierProvider<BookAppointmentNotifier, Success?>(
      BookAppointmentNotifier.new,
    );

class BookAppointmentNotifier extends AsyncNotifier<Success?> {
  @override
  Future<Success?> build() async {
    return null;
  }

  Future<void> book({
    required String doctorId,
    required String date,
  }) async {
    state = const AsyncLoading();
    await ref
        .read(appointmentsRepoProvider)
        .bookAppointment(doctorId: doctorId, date: date)
        .onSuccess((value) async {
          state = const AsyncData(Success());
        })
        .onFailure((failure) {
          state = AsyncError(failure.message, StackTrace.current);
        });
  }
}
