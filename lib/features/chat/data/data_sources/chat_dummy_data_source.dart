import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/features/chat/data/models/chat_conversation_model.dart';
import 'package:cliniq/features/chat/data/models/chat_message_model.dart';
import 'package:cliniq/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';

class ChatDummyDataSource {
  Future<ChatConversationModel> getConversation(ChatType type) async {
    return switch (type) {
      ChatType.doctor => _doctorConversation,
      ChatType.ai => _aiConversation,
    };
  }

  ChatConversationModel get _doctorConversation => const ChatConversationModel(
    type: ChatType.doctor,
    title: LocaleKeys.chatDoctorTitle,
    subtitle: LocaleKeys.chatDoctorSubtitle,
    emptyTitle: LocaleKeys.chatDoctorEmptyTitle,
    emptyDescription: LocaleKeys.chatDoctorEmptyDescription,
    unreadCount: 2,
    isTyping: true,
    messages: [
      ChatMessageModel(
        id: 'doctor-message-1',
        content: LocaleKeys.chatDoctorMessage1,
        sentAt: '09:30',
        sender: ChatMessageSender.doctor,
        status: ChatMessageStatus.seen,
      ),
      ChatMessageModel(
        id: 'doctor-message-2',
        content: LocaleKeys.chatDoctorMessage2,
        sentAt: '09:32',
        sender: ChatMessageSender.user,
        status: ChatMessageStatus.seen,
      ),
      ChatMessageModel(
        id: 'doctor-message-3',
        content: LocaleKeys.chatDoctorMessage3,
        sentAt: '09:34',
        sender: ChatMessageSender.doctor,
        status: ChatMessageStatus.delivered,
      ),
    ],
  );

  ChatConversationModel get _aiConversation => const ChatConversationModel(
    type: ChatType.ai,
    title: LocaleKeys.chatAiTitle,
    subtitle: LocaleKeys.chatAiSubtitle,
    emptyTitle: LocaleKeys.chatAiEmptyTitle,
    emptyDescription: LocaleKeys.chatAiEmptyDescription,
    messages: [
      ChatMessageModel(
        id: 'ai-message-1',
        content: LocaleKeys.chatAiMessage1,
        sentAt: '10:05',
        sender: ChatMessageSender.ai,
        status: ChatMessageStatus.seen,
      ),
      ChatMessageModel(
        id: 'ai-message-2',
        content: LocaleKeys.chatAiMessage2,
        sentAt: '10:06',
        sender: ChatMessageSender.user,
        status: ChatMessageStatus.delivered,
      ),
      ChatMessageModel(
        id: 'ai-message-3',
        content: LocaleKeys.chatAiMessage3,
        sentAt: '10:06',
        sender: ChatMessageSender.ai,
        status: ChatMessageStatus.delivered,
      ),
    ],
  );
}
