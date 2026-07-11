import 'dart:async';
import 'dart:convert';
import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/core/helpers/save_json_data_locally.dart';
import 'package:cliniq/features/user/data/models/user_profile_model.dart';
import 'package:cliniq/features/user/domain/entities/user_profile_entity.dart';
import 'package:cliniq/features/user/presentation/providers/get_user_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider =
    NotifierProvider<CurrentUserNotifier, UserProfileEntity?>(() {
      return CurrentUserNotifier();
    });

class CurrentUserNotifier extends Notifier<UserProfileEntity?> {
  @override
  UserProfileEntity? build() {
    state = null;
    Future.microtask(loadUser);
    return null;
  }

  Future<void> loadUser() async {
    final json = AppStorageHelper.getString(StorageKeys.currentUser);
    if (json != null && json.isNotEmpty) {
      try {
        final decoded = jsonDecode(json);
        state = UserProfileModel.fromJson(decoded);
        return;
      } catch (_) {}
    }
    await refreshUser();
  }

  Future<void> refreshUser() async {
    final result = await ref.read(getUserRepoProvider).getMe();
    result.fold((_) => null, (user) => state = user);
  }

  Future<void> updateUser(UserProfileEntity user) async {
    await cacheCurrentUser(user);
    state = user;
  }

  Future<void> clearUser() async {
    await AppStorageHelper.remove(StorageKeys.currentUser);
    await AppStorageHelper.remove(StorageKeys.currentUserId);
    state = null;
  }
}
