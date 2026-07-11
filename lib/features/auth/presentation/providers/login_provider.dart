import 'dart:convert';
import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/features/user/data/models/user_profile_model.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
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
          final json =
              AppStorageHelper.getString(StorageKeys.currentUser);
          if (json != null && json.isNotEmpty) {
            try {
              final decoded = jsonDecode(json);
              final user = UserProfileModel.fromJson(decoded);
              ref.read(currentUserProvider.notifier).updateUser(user);
            } catch (_) {}
          }
          state = const AsyncData(Success());
        })
        .onFailure((l) {
          state = AsyncError(l, StackTrace.current);
        });
  }
}
