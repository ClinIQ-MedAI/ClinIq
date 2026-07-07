import 'package:cliniq/core/constants/locale_keys.dart';

abstract final class AiDummyResponses {
  static dynamic getResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return null;
  }

  static Map<String, dynamic> get aiConversation => {
    "id": "ai-assistant",
    "type": "ai",
    "title": LocaleKeys.chatAiTitle,
    "subtitle": LocaleKeys.chatAiSubtitle,
    "emptyTitle": LocaleKeys.chatAiEmptyTitle,
    "emptyDescription": LocaleKeys.chatAiEmptyDescription,
    "lastMessage": LocaleKeys.chatAiMessage3,
    "lastMessageTime": "10:06",
    "isOnline": true,
    "messages": [
      {
        "id": "ai-message-1",
        "content": LocaleKeys.chatAiMessage1,
        "sentAt": "10:05",
        "sender": "ai",
        "status": "seen",
      },
      {
        "id": "ai-message-2",
        "content": LocaleKeys.chatAiMessage2,
        "sentAt": "10:06",
        "sender": "user",
        "status": "delivered",
      },
      {
        "id": "ai-message-3",
        "content": LocaleKeys.chatAiMessage3,
        "sentAt": "10:06",
        "sender": "ai",
        "status": "delivered",
      },
    ],
  };
}
