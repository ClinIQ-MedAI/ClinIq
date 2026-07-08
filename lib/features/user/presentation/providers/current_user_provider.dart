import 'dart:convert';
import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/core/helpers/save_json_data_locally.dart';
import 'package:cliniq/features/user/data/models/user_profile_model.dart';
import 'package:cliniq/features/user/domain/entities/user_profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider =
    NotifierProvider<CurrentUserNotifier, UserProfileEntity?>(() {
      return CurrentUserNotifier();
    });

class CurrentUserNotifier extends Notifier<UserProfileEntity?> {
  @override
  UserProfileEntity? build() {
    return _loadCachedUser();
  }

  UserProfileEntity? _loadCachedUser() {
    final json = AppStorageHelper.getString(StorageKeys.currentUser);
    if (json != null && json.isNotEmpty) {
      try {
        final decoded = jsonDecode(json);
        final user = UserProfileModel.fromJson(decoded);
        return user;
      } catch (_) {}
    }
    return null;
  }

  void updateUser(UserProfileEntity user) {
    final model = user is UserProfileModel
        ? user
        : UserProfileModel.fromEntity(user);
    saveJsonDataLocally(
      storageKey: StorageKeys.currentUser,
      json: model.toJson(),
    );
    state = user;
  }

  void reloadFromCache() {
    state = _loadCachedUser();
  }

  void clearUser() {
    state = null;
  }

  bool get isProfileCompleted {
    return AppStorageHelper.getBool(StorageKeys.isProfileCompleted) ?? false;
  }

  Future<void> setProfileCompleted(bool value) async {
    await AppStorageHelper.setBool(StorageKeys.isProfileCompleted, value);
  }
}
