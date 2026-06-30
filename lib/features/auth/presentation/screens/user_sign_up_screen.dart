import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/features/auth/presentation/arguments/verify_email_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/widgets/custom_modal_progress_hud.dart';
import 'package:cliniq/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:cliniq/features/auth/presentation/widgets/user_sign_up_body.dart';

class UserSignUpScreen extends ConsumerWidget {
  const UserSignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(signUpProvider, (previous, next) {
      if (next is AsyncData && next.value is Success) {
        showCustomSnackBar(
          context,
          LocaleKeys.messagesSuccessAccountCreatedSuccessfully,
        );
        Navigator.pushNamed(
          context,
          Routes.verifyEmailScreen,
          arguments: VerifyEmailArguments(
            email: ref.watch(signUpProvider).value?.data['email'] ?? '',
          ),
        );
      } else if (next is AsyncError) {
        showCustomSnackBar(context, next.error.toString());
      }
    });
    return CustomModalProgressHUD(
      inAsyncCall: ref.watch(signUpProvider).isLoading,
      child: const UserSignUpBody(),
    );
  }
}
