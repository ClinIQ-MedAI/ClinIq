import 'dart:developer';
import 'package:cliniq/features/auth/presentation/arguments/verify_email_arguments.dart';
import 'package:cliniq/features/auth/presentation/arguments/verify_reset_code_arguments.dart';
import 'package:cliniq/features/auth/presentation/screens/complete_user_profile_screen.dart';
import 'package:cliniq/features/auth/presentation/screens/user_sign_up_screen.dart';
import 'package:cliniq/features/chat/presentation/arguments/chat_details_arguments.dart';
import 'package:cliniq/features/chat/presentation/screens/chat_details_screen.dart';
import 'package:cliniq/features/home/presentation/screens/user_main_layout.dart';
import 'package:flutter/material.dart';
import 'package:cliniq/core/widgets/undefined_route_page.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:cliniq/features/auth/presentation/screens/login_screen.dart';
import 'package:cliniq/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:cliniq/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:cliniq/features/auth/presentation/screens/verify_reset_code_screen.dart';
import 'package:cliniq/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:cliniq/features/settings/presentation/screens/settings_screen.dart';
import 'package:cliniq/features/settings/presentation/screens/terms_and_services_screen.dart';
import 'package:cliniq/features/user/presentation/screens/edit_profile_screen.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings, BuildContext context) {
  log("Navigating to ${settings.name}");

  switch (settings.name) {
    case Routes.loginScreen:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    case Routes.userSignUpScreen:
      return MaterialPageRoute(builder: (_) => const UserSignUpScreen());

    case Routes.forgetPasswordScreen:
      return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());

    case Routes.resetPasswordScreen:
      return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());

    case Routes.verifyResetCodeScreen:
      final args = settings.arguments as VerifyResetCodeArguments?;
      final email = args?.email ?? '';
      return MaterialPageRoute(
        builder: (_) => VerifyResetCodeScreen(userEmail: email),
      );

    case Routes.verifyEmailScreen:
      final args = settings.arguments as VerifyEmailArguments?;
      final email = args?.email ?? '';
      return MaterialPageRoute(builder: (_) => VerifyEmailScreen(email: email));

    case Routes.userHomeScreen:
      return MaterialPageRoute(builder: (_) => const UserMainLayout());

    case Routes.completeUserProfileScreen:
      return MaterialPageRoute(
        builder: (_) => const CompleteUserProfileScreen(),
      );

    // User Profile
    case Routes.editProfileScreen:
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());

    // Settings
    case Routes.settingsScreen:
      return MaterialPageRoute(builder: (_) => const SettingsScreen());

    case Routes.privacyPolicyScreen:
      return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());

    case Routes.termsAndConditionsScreen:
      return MaterialPageRoute(
        builder: (_) => const TermsAndConditionsScreen(),
      );

    // Chat
    case Routes.chatDetailsScreen:
      final args = settings.arguments as ChatDetailsArguments?;
      final conversationId = args?.conversationId ?? '';
      return MaterialPageRoute(
        builder: (_) => ChatDetailsScreen(conversationId: conversationId),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const UndefinedRoutePage(),
      );
  }
}
