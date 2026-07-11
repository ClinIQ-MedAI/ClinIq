import 'package:cliniq/core/api/end_points.dart';

abstract final class NotificationsDummyResponses {
  static dynamic getResponse(String path, {Map<String, dynamic>? queryParameters}) {
    switch (path) {
      case EndPoints.getNotifications:
        return {
          "data": [
            {
              "id": "1",
              "title": "Appointment Reminder",
              "body": "Your appointment with Dr. Ahmed is tomorrow at 10:00 AM",
              "createdAt": "2026-07-10T14:30:00Z",
              "isRead": false,
            },
            {
              "id": "2",
              "title": "Lab Results Available",
              "body": "Your blood test results are now available. Please check your medical records.",
              "createdAt": "2026-07-09T09:15:00Z",
              "isRead": false,
            },
            {
              "id": "3",
              "title": "Prescription Refill",
              "body": "Your prescription for Amoxicillin has been refilled. You can pick it up at your pharmacy.",
              "createdAt": "2026-07-08T16:45:00Z",
              "isRead": true,
            },
          ],
        };
      case EndPoints.getUnreadNotificationCount:
        return {"count": 2};
      default:
        return null;
    }
  }
}
