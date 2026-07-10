import 'dart:convert';
import 'dart:developer';

import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/features/user/data/models/user_profile_model.dart';

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

Future<void> saveCurrentUserData(UserProfileModel user) async {
  await saveJsonDataLocally(
    storageKey: StorageKeys.currentUser,
    json: user.toJson(),
  );
  if (user.id != null) {
    await AppStorageHelper.setString(StorageKeys.currentUserId, user.id!);
  }
}
