import 'package:cliniq/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/core/widgets/custom_modal_progress_hud.dart';
import 'package:cliniq/features/auth/presentation/providers/verify_email_provider.dart';
import 'package:cliniq/features/auth/presentation/widgets/verify_email_body.dart';

class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(verifyEmailProvider, (previous, next) {
      if (next is AsyncData && next.value is Success) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.loginScreen,
          (route) => false,
        );
      } else if (next is AsyncError) {
        showCustomSnackBar(context, next.error.toString());
      }
    });
    return CustomModalProgressHUD(
      inAsyncCall: ref.watch(verifyEmailProvider).isLoading,
      child: VerifyEmailBody(email: email),
    );
  }
}
