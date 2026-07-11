import 'package:cliniq/core/dummy/ai_dummy_responses.dart';
import 'package:cliniq/core/dummy/appointments_dummy_responses.dart';
import 'package:cliniq/core/dummy/auth_dummy_responses.dart';
import 'package:cliniq/core/dummy/booking_dummy_responses.dart';
import 'package:cliniq/core/dummy/chat_dummy_responses.dart';
import 'package:cliniq/core/dummy/home_dummy_responses.dart';
import 'package:cliniq/core/dummy/notifications_dummy_responses.dart';
import 'package:cliniq/core/dummy/profile_dummy_responses.dart';

class DummyResponses {
  static dynamic getResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    final response =
        AuthDummyResponses.getResponse(
          path,
          queryParameters: queryParameters,
        ) ??
        ProfileDummyResponses.getResponse(
          path,
          queryParameters: queryParameters,
        ) ??
        HomeDummyResponses.getResponse(
          path,
          queryParameters: queryParameters,
        ) ??
        AppointmentsDummyResponses.getResponse(
          path,
          queryParameters: queryParameters,
        ) ??
        ChatDummyResponses.getResponse(
          path,
          queryParameters: queryParameters,
        ) ??
        AiDummyResponses.getResponse(
          path,
          queryParameters: queryParameters,
        ) ??
        NotificationsDummyResponses.getResponse(
          path,
          queryParameters: queryParameters,
        ) ??
        BookingDummyResponses.getResponse(
          path,
          queryParameters: queryParameters,
        );

    if (response != null) {
      return response;
    }

    return {"success": false, "message": "No dummy response for this endpoint"};
  }

  static Map<String, dynamic> get aiConversation =>
      AiDummyResponses.aiConversation;
}
