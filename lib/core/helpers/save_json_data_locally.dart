import 'dart:convert';
import 'dart:developer';

import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/features/user/data/models/user_profile_model.dart';
import 'package:cliniq/features/user/domain/entities/user_profile_entity.dart';

Future<void> saveJsonDataLocally({
  required String storageKey,
  required Map<String, dynamic> json,
}) async {
  try {
    log('save data in prefs');
    var jsonData = jsonEncode(json);
    log("new user data after save it: ${jsonData.toString()}");
    await AppStorageHelper.setString(storageKey, jsonData);
  } on Exception catch (e) {
    log("exception in saveUserDataInPrefs ==> ${e.toString()}");
  }
}

Future<void> cacheCurrentUser(UserProfileEntity user) async {
  final model = user is UserProfileModel
      ? user
      : UserProfileModel.fromEntity(user);
  await saveJsonDataLocally(
    storageKey: StorageKeys.currentUser,
    json: model.toJson(),
  );
  if (model.id != null) {
    await AppStorageHelper.setString(StorageKeys.currentUserId, model.id!);
  }
}
