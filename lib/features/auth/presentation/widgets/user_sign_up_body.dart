import 'package:cliniq/core/enums/gender.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/birth_date_pick_widget.dart';
import 'package:cliniq/core/widgets/custom_card_section.dart';
import 'package:cliniq/core/widgets/labeled_dropdown_form_field.dart';
import 'package:cliniq/core/widgets/labeled_form_field.dart';
import 'package:cliniq/features/auth/presentation/widgets/auth_header.dart';
import 'package:cliniq/features/auth/presentation/widgets/auth_switch_widget.dart';
import 'package:cliniq/core/widgets/form_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/validators.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/auth/data/models/user_sign_up_request_model.dart';
import 'package:cliniq/features/auth/domain/entities/user_sign_up_request_entity.dart';
import 'package:cliniq/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserSignUpBody extends ConsumerStatefulWidget {
  const UserSignUpBody({super.key});

  @override
  ConsumerState<UserSignUpBody> createState() => UserSignUpBodyState();
}

class UserSignUpBodyState extends ConsumerState<UserSignUpBody> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isSignUpButtonEnabled = false;
  Gender? selectedGender;
  DateTime? birthDate;

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkFormFilled);
    emailController.addListener(checkFormFilled);
    passwordController.addListener(checkFormFilled);
    confirmPasswordController.addListener(checkFormFilled);
    phoneController.addListener(checkFormFilled);
  }

  void checkFormFilled() {
    final isFilled =
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        selectedGender != null &&
        birthDate != null;
    if (isFilled != isSignUpButtonEnabled) {
      setState(() {
        isSignUpButtonEnabled = isFilled;
      });
    }
  }

  void onCreateAccountPressed() {
    if (formKey.currentState!.validate()) {
      final UserSignUpRequestEntity customerSignUpRequestEntity =
          UserSignUpRequestEntity(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
            passwordConfirm: confirmPasswordController.text,
            phone: phoneController.text,
            gender: selectedGender!,
            birthDate: birthDate!,
          );

      final data = UserSignUpRequestModel.fromEntity(
        customerSignUpRequestEntity,
      ).toJson();
      ref.watch(signUpProvider.notifier).signUp(data: data);
    }
  }

  void onLoginButtonPressed() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            AuthHeader(
              icon: Icons.person_add_rounded,
              title: LocaleKeys.signupTitle,
              description: LocaleKeys.signupDescription,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FormSectionHeader(
                        title: LocaleKeys.completeProfileGeneralInfo,
                        icon: Icons.badge_outlined,
                      ).animate().fadeIn(delay: 500.ms),
                      const VerticalGap(12),
                      CustomCardSection(
                        children: [
                          LabeledFormField(
                            controller: nameController,
                            validator: Validators.validateNormalText,
                            label: LocaleKeys.signupUserName,
                            hint: LocaleKeys.signupUserNameHint,
                            keyboardType: TextInputType.name,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: context.colorScheme.primary,
                            ),
                          ),
                          const VerticalGap(16),
                          LabeledFormField(
                            controller: emailController,
                            label: LocaleKeys.signupUserEmail,
                            hint: LocaleKeys.signupUserEmailHint,
                            validator: Validators.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: context.colorScheme.primary,
                            ),
                          ),
                          const VerticalGap(16),
                          BirthDatePickWidget(
                            onDateSelected: (date) {
                              setState(() {
                                birthDate = date;
                              });
                              checkFormFilled();
                            },
                          ),
                          const VerticalGap(16),
                          LabeledDropdownFormField(
                            title: LocaleKeys.signupUserGender,
                            hintText: LocaleKeys.signupUserGenderHint,
                            items: Gender.values.map((e) => e.name).toList(),
                            validator: Validators.validateNormalText,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = Gender.values.firstWhere(
                                  (e) => e.name == value,
                                );
                              });
                              checkFormFilled();
                            },
                            selectedValue: selectedGender?.name,
                          ),
                          const VerticalGap(16),
                          LabeledFormField(
                            controller: phoneController,
                            label: LocaleKeys.signupUserPhone,
                            hint: LocaleKeys.signupUserPhoneHint,
                            validator: Validators.validatePhoneNumber,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.05),
                      const VerticalGap(24),
                      const FormSectionHeader(
                        title: LocaleKeys.signupUserPasswordsTitle,
                        icon: Icons.lock_outline_rounded,
                      ).animate().fadeIn(delay: 700.ms),
                      const VerticalGap(12),
                      CustomCardSection(
                        children: [
                          LabeledFormField(
                            controller: passwordController,
                            label: LocaleKeys.signupUserPassword,
                            hint: LocaleKeys.signupUserPasswordHint,
                            isPassword: true,
                            validator: Validators.validatePassword,
                          ),
                          const VerticalGap(16),
                          LabeledFormField(
                            controller: confirmPasswordController,
                            label: LocaleKeys.signupUserConfirmPassword,
                            hint: LocaleKeys.signupUserConfirmPasswordHint,
                            isPassword: true,
                            validator: (value) =>
                                Validators.confirmPasswordValidator(
                                  value,
                                  passwordController.text,
                                ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.05),
                      const VerticalGap(32),
                      CustomButton(
                        isDisabled: !isSignUpButtonEnabled,
                        onPressed: onCreateAccountPressed,
                        text: LocaleKeys.signupUserSubmitButton,
                      ).animate().fadeIn(delay: 900.ms),
                      const VerticalGap(24),
                      AuthSwitchWidget(
                        text: LocaleKeys.signupUserAlreadyHaveAccount,
                        actionText: LocaleKeys.signupUserLoginButton,
                        onActionTap: onLoginButtonPressed,
                      ).animate().fadeIn(delay: 1000.ms),
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
