import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/custom_card_section.dart';
import 'package:cliniq/features/auth/presentation/widgets/auth_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/validators.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/custom_password_text_field.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cliniq/features/auth/presentation/providers/reset_password_provider.dart';

class ResetPasswordBody extends ConsumerStatefulWidget {
  const ResetPasswordBody({super.key, required this.email, required this.otp});
  final String email;
  final String otp;

  @override
  ConsumerState<ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends ConsumerState<ResetPasswordBody> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(checkPassword);
    confirmPasswordController.addListener(checkPassword);
  }

  void checkPassword() {
    final isFilled =
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
    if (isFilled != isButtonEnabled) {
      setState(() {
        isButtonEnabled = isFilled;
      });
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void onSendCodeTap() async {
    if (formKey.currentState!.validate()) {
      ref
          .read(resetPasswordProvider.notifier)
          .resetPassword(
            newPassword: passwordController.text,
            email: widget.email,
            otp: widget.otp,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            AuthHeader(
              icon: Icons.shield_rounded,
              title: LocaleKeys.resetPasswordTitle,
              description: LocaleKeys.resetPasswordDescription,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomCardSection(
                        children: [
                          CustomPasswordTextField(
                            validator: Validators.validatePassword,
                            controller: passwordController,
                            hintText: LocaleKeys.resetPasswordPasswordHint.tr(),
                          ),
                          const VerticalGap(16),
                          CustomPasswordTextField(
                            validator: (value) =>
                                Validators.confirmPasswordValidator(
                                  value,
                                  passwordController.text,
                                ),
                            controller: confirmPasswordController,
                            hintText: LocaleKeys
                                .resetPasswordConfirmPasswordHint
                                .tr(),
                          ),
                        ],
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                      const VerticalGap(32),
                      CustomButton(
                        onPressed: onSendCodeTap,
                        isDisabled: !isButtonEnabled,
                        text: LocaleKeys.resetPasswordReset.tr(),
                      ).animate().fadeIn(delay: 600.ms),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
