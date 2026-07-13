import 'package:cliniq/features/auth/presentation/arguments/verify_email_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/helpers/navigate_to_home_screen.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/core/widgets/custom_modal_progress_hud.dart';
import 'package:cliniq/features/auth/presentation/providers/login_provider.dart';
import 'package:cliniq/features/auth/presentation/widgets/login_body.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(loginProvider, (previous, next) {
      if (next is AsyncData && next.value is Success) {
        navigateToHomeScreen(context);
      } else if (next is AsyncError) {
        if (next.error != null) {
          if (next.error.toString() ==
              LocaleKeys.messagesFailuresInactiveUser) {
            Navigator.pushNamed(
              context,
              Routes.verifyEmailScreen,
              arguments: VerifyEmailArguments(
                email: ref.read(loginProvider.notifier).email ?? '',
              ),
            );
          } else {
            showCustomSnackBar(context, next.error.toString());
          }
        }
      }
    });
    return CustomModalProgressHUD(
      inAsyncCall: ref.watch(loginProvider).isLoading,
      child: const LoginBody(),
    );
  }
}
