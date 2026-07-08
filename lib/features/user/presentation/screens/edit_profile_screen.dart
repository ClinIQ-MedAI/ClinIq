import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/core/widgets/custom_modal_progress_hud.dart';
import 'package:cliniq/features/user/presentation/providers/update_profile_provider.dart';
import 'package:cliniq/features/user/presentation/widgets/edit_profile_body.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(updateProfileProvider, (previous, next) {
      if (next is AsyncData && next.value is Success) {
        showCustomSnackBar(
          context,
          LocaleKeys.messagesSuccessProfileUpdatedSuccessfully,
        );
        Navigator.pop(context);
      } else if (next is AsyncError) {
        showCustomSnackBar(context, next.error.toString());
      }
    });
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: ProfileAppBar(
          title: LocaleKeys.profileUserUpdateProfile,
          showBackButton: true,
          onBackAction: () => Navigator.pop(context),
        ),
      ),
      body: CustomModalProgressHUD(
        inAsyncCall: ref.watch(updateProfileProvider).isLoading,
        child: EditProfileBody(),
      ),
    );
  }
}
