class ChatbotReplyEntity {
  final String chatId;
  final String status;
  final String reply;
  final String queryType;
  final bool showUpload;
  final String? patientId;
  final String? error;
  final String? worker;
  final int? durationMs;
  final String? finishedAt;

  const ChatbotReplyEntity({
    required this.chatId,
    required this.status,
    required this.reply,
    this.queryType = '',
    this.showUpload = false,
    this.patientId,
    this.error,
    this.worker,
    this.durationMs,
    this.finishedAt,
  });
}
