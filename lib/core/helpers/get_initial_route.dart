import 'dart:developer';

import 'package:cliniq/features/auth/presentation/screens/login_screen.dart';
import 'package:cliniq/features/home/presentation/screens/user_main_layout.dart';
import 'package:flutter/material.dart';
import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/features/onboarding/presentation/screens/onboarding_screen.dart';

Widget getInitialRoute() {
  final bool isOnboardingCompleted =
      AppStorageHelper.getBool(StorageKeys.isOnboardingCompleted) ?? false;

  // return OnboardingScreen();
  // return UserMainLayout();
  // return const CompleteUserProfileScreen();
  // return LoginScreen();
  if (!isOnboardingCompleted) {
    return const OnboardingScreen();
  }

  final bool isLoggedIn =
      AppStorageHelper.getBool(StorageKeys.isLoggedIn) ?? false;

  log("get initial route, user isLoggedIn: $isLoggedIn");
  if (isLoggedIn) {
    return const UserMainLayout();
  }
  return const LoginScreen();
}
