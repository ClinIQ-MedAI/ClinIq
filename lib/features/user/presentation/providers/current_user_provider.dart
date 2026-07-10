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
    _initFromCache();
    return null;
  }

  void _initFromCache() {
    final json = AppStorageHelper.getString(StorageKeys.currentUser);
    if (json != null && json.isNotEmpty) {
      try {
        final decoded = jsonDecode(json);
        state = UserProfileModel.fromJson(decoded);
      } catch (_) {}
    }
  }

  Future<void> loadUser() async {
    if (state != null) return;
    await refreshUser();
  }

  Future<void> refreshUser() async {
    final result = await ref.read(getUserRepoProvider).getMe();
    result.fold((_) => null, (user) => state = user);
  }

  Future<void> updateUser(UserProfileEntity user) async {
    final model = user is UserProfileModel
        ? user
        : UserProfileModel.fromEntity(user);
    await saveCurrentUserData(model);
    state = user;
  }

  Future<void> clearUser() async {
    await AppStorageHelper.remove(StorageKeys.currentUser);
    await AppStorageHelper.remove(StorageKeys.currentUserId);
    state = null;
  }

  bool get isProfileCompleted {
    return AppStorageHelper.getBool(StorageKeys.isProfileCompleted) ?? false;
  }

  Future<void> setProfileCompleted(bool value) async {
    await AppStorageHelper.setBool(StorageKeys.isProfileCompleted, value);
  }
}
