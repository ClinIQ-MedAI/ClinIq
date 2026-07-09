class EndPoints {
  // Auth
  static const String refreshToken = "Auth/RefreshToken/refresh-token";
  static const String login = "auth/login";
  static const String userSignUp = "auth/register";
  static const String logOut = "Auth/Logout/logout";

  static const String verifyEmail = "auth/verify-email";
  static const String resendVerifyEmail = "auth/send-email-otp";
  static const String sendEmailOtp = "auth/send-email-otp";

  static const String forgetPassword = "auth/forgot-password";
  static const String resetPassword = "auth/reset-password";
  static const String verifyResetCode =
      "Auth/VerifyResetCode/verify-reset-code";
  static const String resendResetCode =
      "Auth/ResendResetCode/resend-reset-code";
  static const String changePassword = "patient/me/change-password";

  // home
  static const String examinationAppointments =
      "Home/ExaminationAppointments/examination-appointments";
  static const String specializations = "Home/Specializations/specializations";
  static const String suggestedDoctors =
      "Home/SuggestedDoctors/suggested-doctors";
  static const String news = "Home/News/news";

  // appointments
  static const String availableDoctors = "api/bookings/doctors";
  static const String doctorWorkingHours =
      "api/bookings/doctors/{doctorId}/schedules";
  static const String getDoctorById = "api/bookings/doctors/{doctorId}";
  static const String bookAppointment = "api/bookings";

  // chats
  static const String getConversations = "chat/conversations";
  static const String createConversation = "chat/conversations";
  static String getConversationById(String conversationId) =>
      "chat/conversations/$conversationId/messages";
  static String sendChatMessage(String conversationId) =>
      "chat/conversations/$conversationId/messages";
  static const String uploadAttachment = "chat/upload";

  // profile
  static const String getMe = "patient/me";
  static const String updateMe = "patient/me";
  static const String completeProfile = "patient/Survey";
}
