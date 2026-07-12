import 'package:cliniq/features/ai/domain/entities/chatbot_reply_entity.dart';

class ChatbotReplyModel extends ChatbotReplyEntity {
  const ChatbotReplyModel({
    required super.chatId,
    required super.status,
    required super.reply,
    super.queryType,
    super.showUpload,
    super.patientId,
    super.error,
    super.worker,
    super.durationMs,
    super.finishedAt,
  });

  factory ChatbotReplyModel.fromJson(Map<String, dynamic> json) {
    return ChatbotReplyModel(
      chatId: json['chatId']?.toString() ?? json['chat_id']?.toString() ?? '',
      status: json['status'] as String? ?? '',
      reply: json['reply'] as String? ?? '',
      queryType:
          json['query_type'] as String? ?? json['queryType'] as String? ?? '',
      showUpload: json['show_upload'] as bool? ??
          json['showUpload'] as bool? ??
          false,
      patientId: json['patient_id']?.toString() ??
          json['patientId']?.toString(),
      error: json['error'] as String?,
      worker: json['worker'] as String?,
      durationMs:
          (json['duration_ms'] as num?)?.toInt() ??
              (json['durationMs'] as num?)?.toInt(),
      finishedAt: json['finished_at'] as String? ??
          json['finishedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'status': status,
        'reply': reply,
        'queryType': queryType,
        'showUpload': showUpload,
        if (patientId != null) 'patientId': patientId,
        if (error != null) 'error': error,
        if (worker != null) 'worker': worker,
        if (durationMs != null) 'durationMs': durationMs,
        if (finishedAt != null) 'finishedAt': finishedAt,
      };

  ChatbotReplyEntity copyWith({
    String? chatId,
    String? status,
    String? reply,
    String? queryType,
    bool? showUpload,
    String? patientId,
    String? error,
    String? worker,
    int? durationMs,
    String? finishedAt,
  }) {
    return ChatbotReplyEntity(
      chatId: chatId ?? this.chatId,
      status: status ?? this.status,
      reply: reply ?? this.reply,
      queryType: queryType ?? this.queryType,
      showUpload: showUpload ?? this.showUpload,
      patientId: patientId ?? this.patientId,
      error: error ?? this.error,
      worker: worker ?? this.worker,
      durationMs: durationMs ?? this.durationMs,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }
}
