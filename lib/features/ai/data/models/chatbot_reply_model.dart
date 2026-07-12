import 'package:cliniq/features/ai/domain/entities/chatbot_reply_entity.dart';

class ChatbotReplyModel extends ChatbotReplyEntity {
  const ChatbotReplyModel({
    required super.chatId,
    required super.status,
    required super.reply,
    required super.queryType,
    required super.showUpload,
    required super.patientId,
    super.error,
    super.worker,
    super.durationMs,
    super.finishedAt,
  });

  factory ChatbotReplyModel.fromJson(Map<String, dynamic> json) {
    return ChatbotReplyModel(
      chatId: json['chat_id']?.toString() ?? json['chatId']?.toString() ?? '',
      status: json['status'] as String? ?? '',
      reply: json['reply'] as String? ?? '',
      queryType: json['query_type'] as String? ?? json['queryType'] as String? ?? '',
      showUpload: json['show_upload'] as bool? ?? json['showUpload'] as bool? ?? false,
      patientId: json['patient_id']?.toString() ?? json['patientId']?.toString() ?? '',
      error: json['error'] as String?,
      worker: json['worker'] as String?,
      durationMs: json['duration_ms'] as int? ?? json['durationMs'] as int?,
      finishedAt: json['finished_at'] as String? ?? json['finishedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'status': status,
      'reply': reply,
      'queryType': queryType,
      'showUpload': showUpload,
      'patientId': patientId,
      if (error != null) 'error': error,
      if (worker != null) 'worker': worker,
      if (durationMs != null) 'durationMs': durationMs,
      if (finishedAt != null) 'finishedAt': finishedAt,
    };
  }
}
