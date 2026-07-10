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
  static const String examinationAppointments = "patient/appointments";
  static const String specializations = "patient/home/specializations";
  static const String suggestedDoctors = "patient/home/suggested-doctors";
  static const String news = "patient/home/news";

  // appointments
  static const String availableDoctors = "api/bookings/doctors";
  static const String doctorWorkingHours =
      "api/bookings/doctors/{doctorId}/schedules";
  static const String getDoctorById = "api/bookings/doctors/{doctorId}";
  static const String bookAppointment = "api/bookings";

  // chats
  static const String getConversations = "patient/chat/conversations";
  static const String createConversation = "patient/chat/conversations";
  static String sendMessage(String conversationId) =>
      "patient/chat/conversations/$conversationId/messages";
  static String getConversationById(String conversationId) =>
      "patient/chat/conversations/$conversationId/messages";
  static const String uploadAttachment = "patient/chat/upload";

  // profile
  static const String getMe = "patient/me";
  static const String updateMe = "patient/me";
  static const String completeProfile = "patient/Survey";
}
