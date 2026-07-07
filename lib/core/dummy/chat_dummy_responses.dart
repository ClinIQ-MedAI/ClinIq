import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/constants/locale_keys.dart';

abstract final class ChatDummyResponses {
  static dynamic getResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    switch (path) {
      case EndPoints.getConversations:
        final doctorId = queryParameters?['doctorId'] as String?;
        if (doctorId != null) {
          final conversation = _doctorConversations.firstWhere(
            (c) => c['id'] == doctorId,
            orElse: () => _doctorConversations.first,
          );
          return {
            "success": true,
            "message": "Conversation created successfully",
            "data": conversation,
          };
        }
        return {
          "success": true,
          "message": "Conversations fetched successfully",
          "data": _doctorConversations,
        };
    }

    final conversationId = _conversationIdFromPath(path);
    if (conversationId != null) {
      final id = queryParameters?['id'] as String? ?? conversationId;
      final conversation = _doctorConversations.firstWhere(
        (c) => c['id'] == id,
        orElse: () => _doctorConversations.first,
      );
      return {
        "success": true,
        "message": "Messages fetched successfully",
        "data": conversation['messages'],
      };
    }

    return null;
  }

  static String? _conversationIdFromPath(String path) {
    const prefix = 'chat/conversations/';
    const suffix = '/messages';

    if (!path.startsWith(prefix) || !path.endsWith(suffix)) {
      return null;
    }

    final id = path.substring(prefix.length, path.length - suffix.length);
    return id.isEmpty ? null : id;
  }

  static List<Map<String, dynamic>> get _doctorConversations => [
    {
      "id": "doctor-ahmed",
      "type": "doctor",
      "title": LocaleKeys.chatDoctorAhmedName,
      "subtitle": LocaleKeys.chatDoctorAhmedSpecialty,
      "emptyTitle": LocaleKeys.chatDoctorEmptyTitle,
      "emptyDescription": LocaleKeys.chatDoctorEmptyDescription,
      "lastMessage": LocaleKeys.chatDoctorMessage3,
      "lastMessageTime": "09:34",
      "unreadCount": 2,
      "isTyping": true,
      "isOnline": true,
      "messages": [
        {
          "id": "doctor-ahmed-message-1",
          "content": LocaleKeys.chatDoctorMessage1,
          "sentAt": "09:30",
          "sender": "doctor",
          "status": "seen",
        },
        {
          "id": "doctor-ahmed-message-2",
          "content": LocaleKeys.chatDoctorMessage2,
          "sentAt": "09:32",
          "sender": "user",
          "status": "seen",
        },
        {
          "id": "doctor-ahmed-message-3",
          "content": LocaleKeys.chatDoctorMessage3,
          "sentAt": "09:34",
          "sender": "doctor",
          "status": "delivered",
        },
      ],
    },
    {
      "id": "doctor-salma",
      "type": "doctor",
      "title": LocaleKeys.chatDoctorSalmaName,
      "subtitle": LocaleKeys.chatDoctorSalmaSpecialty,
      "emptyTitle": LocaleKeys.chatDoctorEmptyTitle,
      "emptyDescription": LocaleKeys.chatDoctorEmptyDescription,
      "lastMessage": LocaleKeys.chatDoctorSalmaMessage3,
      "lastMessageTime": "08:12",
      "unreadCount": 0,
      "isOnline": false,
      "messages": [
        {
          "id": "doctor-salma-message-1",
          "content": LocaleKeys.chatDoctorSalmaMessage1,
          "sentAt": "08:04",
          "sender": "doctor",
          "status": "seen",
        },
        {
          "id": "doctor-salma-message-2",
          "content": LocaleKeys.chatDoctorSalmaMessage2,
          "sentAt": "08:08",
          "sender": "user",
          "status": "seen",
        },
        {
          "id": "doctor-salma-message-3",
          "content": LocaleKeys.chatDoctorSalmaMessage3,
          "sentAt": "08:12",
          "sender": "doctor",
          "status": "seen",
        },
      ],
    },
    {
      "id": "doctor-youssef",
      "type": "doctor",
      "title": LocaleKeys.chatDoctorYoussefName,
      "subtitle": LocaleKeys.chatDoctorYoussefSpecialty,
      "emptyTitle": LocaleKeys.chatDoctorEmptyTitle,
      "emptyDescription": LocaleKeys.chatDoctorEmptyDescription,
      "lastMessage": LocaleKeys.chatDoctorYoussefMessage3,
      "lastMessageTime": "07:31",
      "unreadCount": 1,
      "isOnline": true,
      "messages": [
        {
          "id": "doctor-youssef-message-1",
          "content": LocaleKeys.chatDoctorYoussefMessage1,
          "sentAt": "07:20",
          "sender": "doctor",
          "status": "seen",
        },
        {
          "id": "doctor-youssef-message-2",
          "content": LocaleKeys.chatDoctorYoussefMessage2,
          "sentAt": "07:25",
          "sender": "user",
          "status": "delivered",
        },
        {
          "id": "doctor-youssef-message-3",
          "content": LocaleKeys.chatDoctorYoussefMessage3,
          "sentAt": "07:31",
          "sender": "doctor",
          "status": "delivered",
        },
      ],
    },
  ];
}
