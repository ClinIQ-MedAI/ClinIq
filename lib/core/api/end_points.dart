class EndPoints {
  // Auth
  static const String refreshToken = "Auth/RefreshToken/refresh-token";
  static const String login = "Auth/Login/login";
  static const String userSignUp = "Auth/RegisterCustomer/register/customer";
  static const String doctorSignUp = "Auth/RegisterDoctor/register/doctor";
  static const String logOut = "Auth/Logout/logout";

  static const String verifyEmail = "Auth/VerifyEmail/verify";
  static const String resendVerifyEmail =
      "Auth/ResendVerification/resend-verification";

  static const String forgetPassword = "Auth/ForgotPassword/forgot-password";
  static const String resetPassword = "Auth/ResetPassword/reset-password";
  static const String verifyResetCode =
      "Auth/VerifyResetCode/verify-reset-code";
  static const String resendResetCode =
      "Auth/ResendResetCode/resend-reset-code";
  static const String changePassword = "Auth/ChangePassword/change-password";
  static const String completeUserProfile =
      "Auth/CompleteUserProfile/complete-user-profile";

  static const String getMe = "Auth/GetCurrentUser/me";

  // home
  static const String examinationAppointments =
      "Home/ExaminationAppointments/examination-appointments";
  static const String specializations = "Home/Specializations/specializations";
  static const String suggestedDoctors =
      "Home/SuggestedDoctors/suggested-doctors";
  static const String news = "Home/News/news";

  // appointments
  static const String availableDoctors =
      "Appointments/AvailableDoctors/available-doctors";
  static const String doctorWorkingHours =
      "Appointments/WorkingHours/working-hours";
  static const String getDoctorById =
      "Appointments/GetDoctorById/get-doctor-by-id";
  static const String bookAppointment =
      "Appointments/BookAppointment/book-appointment";

  // chats
  static const String getConversations = "Chats/GetConversations";
  static const String getConversation = "Chats/GetConversation";
  static const String getConversationById = "Chats/GetConversationById";
  static const String sendChatMessage = "Chats/SendMessage";
}
