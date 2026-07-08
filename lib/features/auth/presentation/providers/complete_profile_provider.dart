import 'package:cliniq/features/auth/domain/repos/auth_repo.dart';
import 'package:cliniq/features/auth/presentation/providers/get_auth_repo_provider.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/extensions/either_extensions.dart';
import 'package:cliniq/core/utils/success.dart';

final completeProfileProvider =
    AsyncNotifierProvider.autoDispose<CompleteProfileNotifier, Success?>(
      CompleteProfileNotifier.new,
    );

class CompleteProfileNotifier extends AsyncNotifier<Success?> {
  late final AuthRepo _repository;

  @override
  Future<Success?> build() async {
    _repository = ref.read(getAuthRepoProvider);
    return null;
  }

  Future<void> submitProfile({required Map<String, dynamic> data}) async {
    state = const AsyncLoading();

    await _repository
        .completeUserProfile(data: data)
        .onSuccess((_) async {
          await ref
              .read(currentUserProvider.notifier)
              .setProfileCompleted(true);
          ref.read(currentUserProvider.notifier).reloadFromCache();
          state = AsyncData(Success(data: data));
        })
        .onFailure((error) {
          state = AsyncError(error, StackTrace.current);
        });
  }
}
