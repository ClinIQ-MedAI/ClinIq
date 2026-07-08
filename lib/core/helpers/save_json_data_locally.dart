import 'dart:convert';
import 'dart:developer';

import 'package:cliniq/core/helpers/app_storage_helper.dart';

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
