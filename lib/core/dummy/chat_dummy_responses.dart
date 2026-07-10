import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/constants/locale_keys.dart';

abstract final class ChatDummyResponses {
  static dynamic getResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    switch (path) {
      case EndPoints.uploadAttachment:
        return {
          "success": true,
          "message": "File uploaded successfully",
          "data": {
            "id": "upload-001",
            "url": "uploads/sample-image.png",
            "fileName": "sample-image.png",
            "fileType": "image",
            "mimeType": "image/png",
            "size": 102400,
          },
        };

      case EndPoints.getConversations:
        return _doctorConversations;

      default:
        if (path.startsWith(EndPoints.sendMessage(''))) {
          // Mock a response for any send-message POST
          return {
            "id": DateTime.now().millisecondsSinceEpoch,
            "senderId": "patient_uuid",
            "senderType": 1,
            "content": queryParameters?['content'] ?? '',
            "status": 0,
            "createdAt": DateTime.now().toIso8601String(),
            "readAt": null,
          };
        }

        final conversationId = _conversationIdFromPath(path);
        if (conversationId != null) {
          final conversation = _doctorConversations.firstWhere(
            (c) => c['id'] == conversationId,
            orElse: () => _doctorConversations.first,
          );
          return conversation['messages'] ?? [];
        }

        return null;
    }
  }

  static int? _conversationIdFromPath(String path) {
    const prefix = 'api/chat/conversations/';
    const suffix = '/messages';

    if (!path.startsWith(prefix) || !path.endsWith(suffix)) {
      return null;
    }

    final id = path.substring(prefix.length, path.length - suffix.length);
    return int.tryParse(id);
  }

  static List<Map<String, dynamic>> get _doctorConversations => [
    {
      "id": 1,
      "doctorId": "doctor-ahmed-uuid",
      "doctorName": LocaleKeys.chatDoctorAhmedName,
      "doctorSpecialization": LocaleKeys.chatDoctorAhmedSpecialty,
      "lastMessageAt": "2026-07-10T09:34:00Z",
      "unreadCount": 2,
      "messages": [
        {
          "messageId": 11,
          "senderId": "doctor-ahmed-uuid",
          "senderType": 0,
          "content": LocaleKeys.chatDoctorMessage1,
          "status": 2,
          "createdAt": "2026-07-10T09:30:00Z",
          "readAt": "2026-07-10T09:32:00Z",
        },
        {
          "messageId": 12,
          "senderId": "patient-uuid",
          "senderType": 1,
          "content": LocaleKeys.chatDoctorMessage2,
          "status": 2,
          "createdAt": "2026-07-10T09:32:00Z",
          "readAt": "2026-07-10T09:32:00Z",
        },
        {
          "messageId": 13,
          "senderId": "doctor-ahmed-uuid",
          "senderType": 0,
          "content": LocaleKeys.chatDoctorMessage3,
          "status": 1,
          "createdAt": "2026-07-10T09:34:00Z",
          "readAt": null,
        },
      ],
    },
    {
      "id": 2,
      "doctorId": "doctor-salma-uuid",
      "doctorName": LocaleKeys.chatDoctorSalmaName,
      "doctorSpecialization": LocaleKeys.chatDoctorSalmaSpecialty,
      "lastMessageAt": "2026-07-10T08:12:00Z",
      "unreadCount": 0,
      "messages": [
        {
          "messageId": 21,
          "senderId": "doctor-salma-uuid",
          "senderType": 0,
          "content": LocaleKeys.chatDoctorSalmaMessage1,
          "status": 2,
          "createdAt": "2026-07-10T08:04:00Z",
          "readAt": "2026-07-10T08:06:00Z",
        },
        {
          "messageId": 22,
          "senderId": "patient-uuid",
          "senderType": 1,
          "content": LocaleKeys.chatDoctorSalmaMessage2,
          "status": 2,
          "createdAt": "2026-07-10T08:08:00Z",
          "readAt": "2026-07-10T08:08:00Z",
        },
        {
          "messageId": 23,
          "senderId": "doctor-salma-uuid",
          "senderType": 0,
          "content": LocaleKeys.chatDoctorSalmaMessage3,
          "status": 1,
          "createdAt": "2026-07-10T08:12:00Z",
          "readAt": null,
        },
      ],
    },
    {
      "id": 3,
      "doctorId": "doctor-youssef-uuid",
      "doctorName": LocaleKeys.chatDoctorYoussefName,
      "doctorSpecialization": LocaleKeys.chatDoctorYoussefSpecialty,
      "lastMessageAt": "2026-07-10T07:31:00Z",
      "unreadCount": 1,
      "messages": [
        {
          "messageId": 31,
          "senderId": "doctor-youssef-uuid",
          "senderType": 0,
          "content": LocaleKeys.chatDoctorYoussefMessage1,
          "status": 2,
          "createdAt": "2026-07-10T07:20:00Z",
          "readAt": "2026-07-10T07:22:00Z",
        },
        {
          "messageId": 32,
          "senderId": "patient-uuid",
          "senderType": 1,
          "content": LocaleKeys.chatDoctorYoussefMessage2,
          "status": 1,
          "createdAt": "2026-07-10T07:25:00Z",
          "readAt": null,
        },
        {
          "messageId": 33,
          "senderId": "doctor-youssef-uuid",
          "senderType": 0,
          "content": LocaleKeys.chatDoctorYoussefMessage3,
          "status": 1,
          "createdAt": "2026-07-10T07:31:00Z",
          "readAt": null,
        },
      ],
    },
  ];
}
