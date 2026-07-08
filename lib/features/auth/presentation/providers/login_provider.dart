import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/extensions/either_extensions.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/features/auth/presentation/providers/get_auth_repo_provider.dart';

final loginProvider =
    AsyncNotifierProvider.autoDispose<LoginNotifier, Success?>(
      LoginNotifier.new,
    );

class LoginNotifier extends AsyncNotifier<Success?> {
  String? email;

  @override
  Future<Success?> build() async {
    return null;
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    this.email = email;

    state = const AsyncLoading();
    await ref
        .read(getAuthRepoProvider)
        .signInWithEmailAndPassword(email: email, password: password)
        .onSuccess((_) async {
          state = const AsyncData(Success());
        })
        .onFailure((l) {
          state = AsyncError(l, StackTrace.current);
        });
  }
}
