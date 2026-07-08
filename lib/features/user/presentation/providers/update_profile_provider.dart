import 'package:cliniq/core/extensions/either_extensions.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/features/user/presentation/providers/get_user_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateProfileProvider =
    AsyncNotifierProvider<UpdateProfileNotifier, Success?>(() {
      return UpdateProfileNotifier();
    });

class UpdateProfileNotifier extends AsyncNotifier<Success?> {
  @override
  Future<Success?> build() async {
    return null;
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = const AsyncLoading();

    await ref
        .read(getUserRepoProvider)
        .updateMe(data: data)
        .onSuccess((_) async {
          state = AsyncData(Success(data: data));
        })
        .onFailure((l) {
          state = AsyncError(l, StackTrace.current);
        });
  }
}
