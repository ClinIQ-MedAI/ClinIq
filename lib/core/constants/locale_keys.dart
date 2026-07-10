abstract class LocaleKeys {
  // messages.success
  static const messagesSuccessVerificationCodeSent =
      "messages.success.verification_code_sent";
  static const messagesSuccessNewVerificationCodeSent =
      "messages.success.new_verification_code_sent";
  static const messagesSuccessAccountCreatedSuccessfully =
      "messages.success.account_created_successfully";
  static const messagesSuccessAccountVerifiedSuccessfully =
      "messages.success.account_verified_successfully";
  static const messagesSuccessAppointmentBookedSuccessfully =
      "messages.success.appointment_booked_successfully";
  static const messagesSuccessPasswordResetLinkSent =
      "messages.success.password_reset_link_sent";
  static const messagesSuccessProfileUpdatedSuccessfully =
      "messages.success.profile_updated_successfully";

  // messages.failures
  static const messagesFailuresIncorrectCredentials =
      "messages.failures.incorrect_credentials";
  static const messagesFailuresInactiveUser = "messages.failures.inactive.user";
  static const messagesFailuresUnexpectedError =
      "messages.failures.unexpected_error";
  static const messagesFailuresAccountAlreadyExists =
      "messages.failures.account_already_exists";
  static const messagesFailuresPhoneAlreadyExists =
      "messages.failures.phone_already_exists";
  static const messagesFailuresInvalidOrExpiredCode =
      "messages.failures.invalid_or_expired_code";
  static const messagesFailuresInvalidEmail = "messages.failures.invalid_email";
  static const messagesFailuresUserAlreadyActive =
      "messages.failures.user_already_active";
  static const messagesFailuresUserNotFound =
      "messages.failures.user_not_found";
  static const messagesFailuresVerificationCodeNotFound =
      "messages.failures.verification_code_not_found";
  static const messagesFailuresResetTokenExpired =
      "messages.failures.reset_token_expired";
  static const messagesFailuresInvalidVerificationCode =
      "messages.failures.invalid_verification_code";
  static const messagesFailuresPasswordTooShort =
      "messages.failures.password_too_short";
  static const messagesFailuresPasswordRequiresSpecialCharacter =
      "messages.failures.password_requires_special_character";
  static const messagesFailuresPasswordRequiresLowercase =
      "messages.failures.password_requires_lowercase";
  static const messagesFailuresPasswordRequiresUppercase =
      "messages.failures.password_requires_uppercase";
  static const messagesFailuresInvalidEmailFormat =
      "messages.failures.invalid_email_format";

  // validation
  static const validationFieldIsRequired = "validation.field_is_required";
  static const validationEmailIsRequired = "validation.email_is_required";
  static const validationInvalidEmail = "validation.invalid_email";
  static const validationPasswordIsRequired = "validation.password_is_required";
  static const validationPasswordTooShort = "validation.password_too_short";
  static const validationPhoneIsRequired = "validation.phone_is_required";
  static const validationInvalidPhone = "validation.invalid_phone";
  static const validationAgeIsRequired = "validation.age_is_required";
  static const validationInvalidAge = "validation.invalid_age";
  static const validationAgeTooYoung = "validation.age_too_young";
  static const validationAgeTooOld = "validation.age_too_old";
  static const validationConfirmPasswordIsRequired =
      "validation.confirm_password_is_required";
  static const validationPasswordsDoNotMatch =
      "validation.passwords_do_not_match";
  static const validationPasswordMustContain6Chars =
      "validation.password_must_contain_6_chars";
  static const validationPasswordMustContainLowercase =
      "validation.password_must_contain_lowercase";
  static const validationPasswordMustContainUppercase =
      "validation.password_must_contain_uppercase";

  static const validationInvalidNationalId = "validation.invalid_national_id";
  static const validationEnterYourEmailToResetPassword =
      "validation.enter_your_email_to_reset_password";
  static const validationGovernorateIsRequired =
      "validation.governorate_is_required";
  static const validationGovernorateTooLong = "validation.governorate_too_long";
  static const validationPasswordMustContainNumber =
      "validation.password_must_contain_number";
  static const validationBirthDateIsRequired =
      "validation.birth_date_is_required";
  static const validationInvalidBirthDate = "validation.invalid_birth_date";

  // onboarding
  static const onboardingTitle1 = "onboarding.title_1";
  static const onboardingDescription1 = "onboarding.description_1";
  static const onboardingTitle2 = "onboarding.title_2";
  static const onboardingDescription2 = "onboarding.description_2";
  static const onboardingTitle3 = "onboarding.title_3";
  static const onboardingDescription3 = "onboarding.description_3";
  static const onboardingTitle4 = "onboarding.title_4";
  static const onboardingDescription4 = "onboarding.description_4";
  static const onboardingSkip = 'onboarding.skip';
  static const onboardingNext = 'onboarding.next';
  static const onboardingGetStarted = 'onboarding.get_started';
  static const onboarding = 'onboarding';

  // bottom_navigation_bar
  static const bottomNavigationBarAiChat = "bottom_navigation_bar.ai_chat";
  static const bottomNavigationBarDoctorChat =
      "bottom_navigation_bar.doctor_chat";

  // auth_login
  static const authLoginTitle = "auth_login.title";
  static const authLoginDescription = "auth_login.description";
  static const authLoginEmailHint = "auth_login.email_hint";
  static const authLoginPasswordHint = "auth_login.password_hint";
  static const authLoginForgotPassword = "auth_login.forgot_password";
  static const authLoginButton = "auth_login.login_button";
  static const authLoginSignUp = "auth_login.sign_up";
  static const authLoginDontHaveAnAccount = "auth_login.dont_have_an_account";

  // signup/user
  static const signupTitle = "signup.title";
  static const signupDescription = "signup.description";
  static const signupUserFirstName = "signup.user.fname";
  static const signupUserFirstNameHint = "signup.user.fname_hint";
  static const signupUserLastName = "signup.user.lname";
  static const signupUserLastNameHint = "signup.user.lname_hint";
  static const signupUserEmail = "signup.user.email";
  static const signupUserEmailHint = "signup.user.email_hint";
  static const signupUserGender = "signup.user.gender";
  static const signupUserGenderHint = "signup.user.gender_hint";
  static const signupUserPhone = "signup.user.phone";
  static const signupUserPhoneHint = "signup.user.phone_hint";
  static const signupUserBirthDate = "signup.user.birth_date";
  static const signupUserBirthDateHint = "signup.user.birth_date_hint";
  static const signupUserPasswordsTitle = "signup.user.passwords_title";
  static const signupUserPassword = "signup.user.password";
  static const signupUserPasswordHint = "signup.user.password_hint";
  static const signupUserConfirmPassword = "signup.user.confirm_password";
  static const signupUserConfirmPasswordHint =
      "signup.user.confirm_password_hint";
  static const signupUserinticateFingerprint =
      "signup.user.inticate_fingerprint";
  static const signupUserSubmitButton = "signup.user.submit_button";
  static const signupUserAlreadyHaveAccount =
      "signup.user.already_have_account";
  static const signupUserBirthDateButton = "signup.user.birth_date_button";
  static const signupUserLoginButton = "signup.user.login_button";

  // verify_email
  static const verifyEmailTitle = "verify_email.title";
  static const verifyEmailDescription = "verify_email.description";
  static const verifyEmailEnterCode = "verify_email.enter_code";
  static const verifyEmailCodeSent = "verify_email.code_sent";
  static const verifyEmailResendCode = "verify_email.resend_code";
  static const verifyEmailVerifyOtp = "verify_email.verify_otp";
  static const verifyEmailDidntReceiveCode = "verify_email.didnt_receive_code";

  // complete_profile
  static const completeProfileTitle = "complete_profile.title";
  static const completeProfileSkip = "complete_profile.skip";
  static const completeProfileSubmit = "complete_profile.submit";

  static const completeProfileHeight = "complete_profile.height";
  static const completeProfileHeightHint = "complete_profile.height_hint";

  static const completeProfileWeight = "complete_profile.weight";
  static const completeProfileWeightHint = "complete_profile.weight_hint";

  static const completeProfileBloodType = "complete_profile.blood_type";
  static const completeProfileBloodTypeHint =
      "complete_profile.blood_type_hint";

  static const completeProfileHasDiabetes = "complete_profile.has_diabetes";
  static const completeProfileHasPressure = "complete_profile.has_pressure";

  static const completeProfileAllergies = "complete_profile.allergies";
  static const completeProfileAllergiesHint = "complete_profile.allergies_hint";

  static const completeProfileChronicConditions =
      "complete_profile.chronic_conditions";
  static const completeProfileChronicConditionsHint =
      "complete_profile.chronic_conditions_hint";

  static const completeProfileEmergencyContact =
      "complete_profile.emergency_contact";
  static const completeProfileEmergencyContactName =
      "complete_profile.emergency_contact_name";
  static const completeProfileEmergencyContactNameHint =
      "complete_profile.emergency_contact_name_hint";
  static const completeProfileEmergencyContactPhone =
      "complete_profile.emergency_contact_phone";
  static const completeProfileEmergencyContactPhoneHint =
      "complete_profile.emergency_contact_phone_hint";

  static const completeProfileSetupTitle = "complete_profile.setup_title";
  static const completeProfileSetupDescription =
      "complete_profile.setup_description";
  static const completeProfileGeneralInfo = "complete_profile.general_info";
  static const completeProfileGeneralInfoDesc =
      "complete_profile.general_info_desc";
  static const completeProfileHealthStatus = "complete_profile.health_status";
  static const completeProfileHealthStatusDesc =
      "complete_profile.health_status_desc";
  static const completeProfileMedicalHistory =
      "complete_profile.medical_history";
  static const completeProfileMedicalHistoryDesc =
      "complete_profile.medical_history_desc";
  static const completeProfileEmergencyContactDesc =
      "complete_profile.emergency_contact_desc";

  // forget_password
  static const forgetPasswordTitle = "forget_password.title";
  static const forgetPasswordDescription = "forget_password.description";
  static const forgetPasswordForgetPassword = "forget_password.forget_password";
  static const forgetPasswordEmail = "forget_password.email";
  static const forgetPasswordEmailHint = "forget_password.email_hint";
  static const forgetPasswordSendOtp = "forget_password.send_otp";

  // verify_otp
  static const verifyOtpTitle = "verify_otp.title";
  static const verifyOtpDescription = "verify_otp.description";
  static const verifyOtpEnterCode = "verify_otp.enter_code";
  static const verifyOtpCodeSent = "verify_otp.code_sent";
  static const verifyOtpResendCode = "verify_otp.resend_code";
  static const verifyOtpDidntReceiveCode = "verify_otp.didnt_receive_code";
  static const verifyOtpVerifyOtp = "verify_otp.verify_otp";

  // reset_password
  static const resetPasswordTitle = "reset_password.title";
  static const resetPasswordDescription = "reset_password.description";
  static const resetPasswordSetNewPassword = "reset_password.set_new_password";
  static const resetPasswordPasswordHint = "reset_password.password_hint";
  static const resetPasswordConfirmPasswordHint =
      "reset_password.confirm_password_hint";
  static const resetPasswordReset = "reset_password.reset";

  // home
  static const homeTitle = "home.title";
  static const homeWelcomeBack = "home.welcome_back";
  static const homeSearchHint = "home.search_hint";
  static const homeExaminationAppointments = "home.examination_appointments";
  static const homeSpecialization = "home.specialization";
  static const homeSuggestedDoctor = "home.suggested_doctor";
  static const homeNewNews = "home.new_news";
  static const homeSeeAll = "home.see_all";
  static const homeAppointmentsDesc = "home.appointments_desc";
  static const homeSpecializationsDesc = "home.specializations_desc";
  static const homeDoctorsDesc = "home.doctors_desc";
  static const homeNewsDesc = "home.news_desc";
  static const homeAiAssistantTitle = "home.ai_assistant.title";
  static const homeAiAssistantDescription = "home.ai_assistant.description";
  static const homeAiAssistantStartChat = "home.ai_assistant.start_chat";

  // chat
  static const chatDoctorTitle = "chat.doctor.title";
  static const chatDoctorSubtitle = "chat.doctor.subtitle";
  static const chatDoctorEmptyTitle = "chat.doctor.empty_title";
  static const chatDoctorEmptyDescription = "chat.doctor.empty_description";
  static const chatDoctorListEmptyTitle = "chat.doctor.list_empty_title";
  static const chatDoctorListEmptyDescription =
      "chat.doctor.list_empty_description";
  static const chatDoctorAhmedName = "chat.doctor.ahmed_name";
  static const chatDoctorAhmedSpecialty = "chat.doctor.ahmed_specialty";
  static const chatDoctorSalmaName = "chat.doctor.salma_name";
  static const chatDoctorSalmaSpecialty = "chat.doctor.salma_specialty";
  static const chatDoctorYoussefName = "chat.doctor.youssef_name";
  static const chatDoctorYoussefSpecialty = "chat.doctor.youssef_specialty";
  static const chatDoctorMessage1 = "chat.doctor.message_1";
  static const chatDoctorMessage2 = "chat.doctor.message_2";
  static const chatDoctorMessage3 = "chat.doctor.message_3";
  static const chatDoctorSalmaMessage1 = "chat.doctor.salma_message_1";
  static const chatDoctorSalmaMessage2 = "chat.doctor.salma_message_2";
  static const chatDoctorSalmaMessage3 = "chat.doctor.salma_message_3";
  static const chatDoctorYoussefMessage1 = "chat.doctor.youssef_message_1";
  static const chatDoctorYoussefMessage2 = "chat.doctor.youssef_message_2";
  static const chatDoctorYoussefMessage3 = "chat.doctor.youssef_message_3";
  static const chatAiTitle = "chat.ai.title";
  static const chatAiSubtitle = "chat.ai.subtitle";
  static const chatAiEmptyTitle = "chat.ai.empty_title";
  static const chatAiEmptyDescription = "chat.ai.empty_description";
  static const chatAiMessage1 = "chat.ai.message_1";
  static const chatAiMessage2 = "chat.ai.message_2";
  static const chatAiMessage3 = "chat.ai.message_3";
  static const chatInputHint = "chat.input_hint";
  static const chatToday = "chat.today";
  static const chatAttachmentPickerTitle = "chat.attachment_picker_title";
  static const chatDentalXRay = "chat.dental_x_ray";
  static const chatDentalXRayDesc = "chat.dental_x_ray_desc";
  static const chatBoneXRay = "chat.bone_x_ray";
  static const chatBoneXRayDesc = "chat.bone_x_ray_desc";
  static const chatChestXRay = "chat.chest_x_ray";
  static const chatChestXRayDesc = "chat.chest_x_ray_desc";
  static const chatDentalPhoto = "chat.dental_photo";
  static const chatDentalPhotoDesc = "chat.dental_photo_desc";
  static const chatMedicalPrescription = "chat.medical_prescription";
  static const chatMedicalPrescriptionDesc = "chat.medical_prescription_desc";
  static const chatPdfReport = "chat.pdf_report";
  static const chatPdfReportDesc = "chat.pdf_report_desc";
  static const chatAttachmentUploading = "chat.attachment_uploading";
  static const chatAttachmentRemove = "chat.attachment_remove";
  static const chatAttachmentRetry = "chat.attachment_retry";
  static const chatImageViewerShare = "chat.image_viewer.share";
  static const chatImageViewerSave = "chat.image_viewer.save";
  static const chatImageViewerExternal = "chat.image_viewer.external";
  static const chatImageViewerCopy = "chat.image_viewer.copy";
  static const chatImageViewerSavedSuccess = "chat.image_viewer.saved_success";
  static const chatImageViewerCopiedSuccess = "chat.image_viewer.copied_success";
  static const chatImageViewerMoreActions = "chat.image_viewer.more_actions";

  // profile
  static const profileUserTitle = "profile.user.title";
  static const profileUserBloodGroup = "profile.user.blood_group";
  static const profileUserEmail = "profile.user.email";
  static const profileUserMobile = "profile.user.mobile";
  static const profileUserHeight = "profile.user.height";
  static const profileUserWeight = "profile.user.weight";
  static const profileUserAilments = "profile.user.ailments";
  static const profileUserEditProfile = "profile.user.edit_profile";
  static const profileUserFullName = "profile.user.full_name";
  static const profileUserSave = "profile.user.save";
  static const profileUserUpdateProfile = "profile.user.update_profile";
  static const profileUserChangePhoto = "profile.user.change_photo";
  static const profileUserPhysicalMetrics = "profile.user.physical_metrics";
  static const profileUserMedicalId = "profile.user.medical_id";
  static const profileUserPersonalInfo = "profile.user.personal_info";
  static const profileUserMedicalInfo = "profile.user.medical_info";
  static const profileUserGender = "profile.user.gender";
  static const profileUserCm = "profile.user.cm";
  static const profileUserKg = "profile.user.kg";
  static const profileUserCompleteProfileTitle = "profile.user.complete_profile_title";
  static const profileUserCompleteProfileDescription = "profile.user.complete_profile_description";
  static const profileUserCompleteProfileButton = "profile.user.complete_profile_button";
  static const profileUserPhone = "profile.user.phone";

  // settings
  static const settingsUserTitle = "settings.user.title";
  static const settingsUserPushNotifications =
      "settings.user.push_notifications";
  static const settingsUserSmsNotifications = "settings.user.sms_notifications";
  static const settingsUserEmailNotifications =
      "settings.user.email_notifications";
  static const settingsUserChangePassword = "settings.user.change_password";
  static const settingsUserMyLocation = "settings.user.my_location";
  static const settingsUserChangeNumber = "settings.user.change_number";
  static const settingsUserChangeEmail = "settings.user.change_email";
  static const settingsUserTwoFactorAuth = "settings.user.two_factor_auth";
  static const settingsUserPrivacyPolicy = "settings.user.privacy_policy";
  static const settingsUserTermsAndServices =
      "settings.user.terms_and_services";
  static const settingsUserLogout = "settings.user.logout";
  static const settingsUserDarkMode = "settings.user.dark_mode";
  static const settingsUserLanguage = "settings.user.language";
  static const settingsUserEnglish = "settings.user.english";
  static const settingsUserArabic = "settings.user.arabic";
  static const settingsUserGeneral = "settings.user.general";
  static const settingsUserNotifications = "settings.user.notifications";
  static const settingsUserSecurityPrivacy = "settings.user.security_privacy";

  // booking
  static const String bookingTitle = "booking.title";
  static const String bookingAvailableDoctors = "booking.available_doctors";
  static const String bookingBooking = "booking.booking";
  static const String bookingAbout = "booking.about";
  static const String bookingWorkingHours = "booking.working_hours";
  static const String bookingPatient = "booking.patient";
  static const String bookingFull = "booking.full";
  static const String bookingBookingButton = "booking.booking_button";
}
