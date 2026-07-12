import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/core/utils/app_routes.dart';

String getInitialRouteName() {
  final isOnboardingCompleted =
      AppStorageHelper.getBool(StorageKeys.isOnboardingCompleted) ?? false;
  if (!isOnboardingCompleted) return Routes.onboardingScreen;
  final isLoggedIn = AppStorageHelper.getBool(StorageKeys.isLoggedIn) ?? false;
  return isLoggedIn ? Routes.userHomeScreen : Routes.loginScreen;
}
