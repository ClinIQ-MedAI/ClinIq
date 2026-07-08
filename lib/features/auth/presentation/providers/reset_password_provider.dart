import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/extensions/either_extensions.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/features/auth/presentation/providers/get_auth_repo_provider.dart';

final resetPasswordProvider =
    AsyncNotifierProvider.autoDispose<ResetPasswordNotifier, Success?>(
      ResetPasswordNotifier.new,
    );

class ResetPasswordNotifier extends AsyncNotifier<Success?> {
  @override
  Future<Success?> build() async {
    return null;
  }

  Future<void> resetPassword({
    required String newPassword,
    required String email,
    required String otp,
  }) async {
    state = const AsyncLoading();
    await ref
        .read(getAuthRepoProvider)
        .resetPassword(
          newPassword: newPassword,
          email: email,
          otp: otp,
        )
        .onSuccess((_) async {
          state = const AsyncData(Success());
        })
        .onFailure((l) {
          state = AsyncError(l, StackTrace.current);
        });
  }
}
