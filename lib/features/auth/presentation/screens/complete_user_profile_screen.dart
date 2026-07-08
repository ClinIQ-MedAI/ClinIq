import 'package:cliniq/core/helpers/navigate_to_home_screen.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/core/widgets/custom_modal_progress_hud.dart';
import 'package:cliniq/features/auth/presentation/providers/complete_profile_provider.dart';
import 'package:cliniq/features/auth/presentation/widgets/complete_profile_header.dart';
import 'package:cliniq/features/auth/presentation/widgets/complete_user_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompleteUserProfileScreen extends ConsumerWidget {
  const CompleteUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(completeProfileProvider, (prev, next) {
      if (next is AsyncData && next.value is Success) {
        navigateToHomeScreen(context);
      } else if (next is AsyncError) {
        showCustomSnackBar(context, next.error.toString());
      }
    });

    return CustomModalProgressHUD(
      inAsyncCall: ref.watch(completeProfileProvider).isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CompleteProfileHeader(
                onSkip: () => navigateToHomeScreen(context),
              ),
              const Expanded(child: CompleteProfileBody()),
            ],
          ),
        ),
      ),
    );
  }
}
