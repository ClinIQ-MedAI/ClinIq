import 'package:cliniq/features/auth/presentation/arguments/reset_password_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/core/widgets/custom_modal_progress_hud.dart';
import 'package:cliniq/features/auth/presentation/providers/verify_reset_code_provider.dart';
import 'package:cliniq/features/auth/presentation/widgets/verify_reset_code_body.dart';

class VerifyResetCodeScreen extends ConsumerStatefulWidget {
  const VerifyResetCodeScreen({super.key, required this.userEmail});

  final String userEmail;

  @override
  ConsumerState<VerifyResetCodeScreen> createState() =>
      _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends ConsumerState<VerifyResetCodeScreen> {
  void listenOnVerifyResetCodeProvider() {
    ref.listen(verifyResetCodeProvider, (previous, next) {
      if (next is AsyncError) {
        showCustomSnackBar(context, next.error.toString());
        goToResetPasswordScreen();
      } else if (next is AsyncData && next.value is Success) {
        goToResetPasswordScreen();
      }
    });
  }

  void goToResetPasswordScreen() {
    final email = ref.read(verifyResetCodeProvider.notifier).email;
    final otp = ref.read(verifyResetCodeProvider.notifier).otp;
    if (email != null && otp != null) {
      Navigator.pushNamed(
        context,
        Routes.resetPasswordScreen,
        arguments: ResetPasswordArguments(email: email, otp: otp),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    listenOnVerifyResetCodeProvider();
    return CustomModalProgressHUD(
      inAsyncCall: ref.watch(verifyResetCodeProvider).isLoading,
      child: VerifyResetCodeBody(userEmail: widget.userEmail),
    );
  }
}
