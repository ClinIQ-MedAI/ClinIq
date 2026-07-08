import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/core/widgets/custom_modal_progress_hud.dart';
import 'package:cliniq/features/auth/presentation/providers/reset_password_provider.dart';
import 'package:cliniq/features/auth/presentation/widgets/reset_password_body.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });
  final String email;
  final String otp;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  void listenOnResetPasswordProvider() {
    ref.listen(resetPasswordProvider, (previous, next) {
      if (next is AsyncError) {
        showCustomSnackBar(context, next.error.toString());
      } else if (next is AsyncData && next.value is Success) {
        goToLoginScreen();
      }
    });
  }

  void goToLoginScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.loginScreen,
      (route) => false,
    );
    Navigator.pushNamed(context, Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    listenOnResetPasswordProvider();
    return CustomModalProgressHUD(
      inAsyncCall: ref.watch(resetPasswordProvider).isLoading,
      child: ResetPasswordBody(
        email: widget.email,
        otp: widget.otp,
      ),
    );
  }
}
