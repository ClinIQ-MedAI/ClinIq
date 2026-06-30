import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/custom_card_section.dart';
import 'package:cliniq/core/widgets/labeled_form_field.dart';
import 'package:cliniq/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/success.dart';
import 'package:cliniq/core/utils/validators.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/auth/presentation/arguments/verify_reset_code_arguments.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cliniq/features/auth/presentation/providers/forget_password_provider.dart';

class ForgetPasswordBody extends ConsumerStatefulWidget {
  const ForgetPasswordBody({super.key});

  @override
  ConsumerState<ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends ConsumerState<ForgetPasswordBody> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(checkEmail);
  }

  void checkEmail() {
    final isFilled = emailController.text.isNotEmpty;
    if (isFilled != isButtonEnabled) {
      setState(() {
        isButtonEnabled = isFilled;
      });
    }
  }

  @override
  void dispose() {
    emailController.removeListener(checkEmail);
    emailController.dispose();
    super.dispose();
  }

  void onSendCodeTap() {
    if (formKey.currentState!.validate()) {
      ref
          .read(forgetPasswordProvider.notifier)
          .forgetPassword(email: emailController.text);
    }
  }

  void goToVerifyCodeScreen() {
    Navigator.pushNamed(
      context,
      Routes.verifyResetCodeScreen,
      arguments: VerifyResetCodeArguments(email: emailController.text),
    );
  }

  void listenOnForgetPasswordProvider() {
    ref.listen(forgetPasswordProvider, (previous, next) {
      if (next is AsyncError) {
        showCustomSnackBar(context, next.error.toString());
      } else if (next is AsyncData && next.value is Success) {
        goToVerifyCodeScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listenOnForgetPasswordProvider();

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            AuthHeader(
              icon: Icons.lock_reset_rounded,
              title: LocaleKeys.forgetPasswordTitle,
              description: LocaleKeys.forgetPasswordDescription,
              onBack: () => Navigator.pop(context),
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
                          LabeledFormField(
                            label: LocaleKeys.forgetPasswordEmail,
                            hint: LocaleKeys.forgetPasswordEmailHint,
                            controller: emailController,
                            validator: Validators.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                      const VerticalGap(32),
                      CustomButton(
                        onPressed: onSendCodeTap,
                        isDisabled: !isButtonEnabled,
                        text: LocaleKeys.forgetPasswordSendOtp,
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
