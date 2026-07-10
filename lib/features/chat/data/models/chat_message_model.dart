import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.content,
    required super.sentAt,
    required super.sender,
    required super.status,
    super.attachmentUrl,
    super.attachmentName,
    super.attachmentSize,
    super.attachmentMimeType,
    super.localFilePath,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final id = _resolveId(json);
    final sender = _resolveSender(json);
    final status = _resolveStatus(json);
    final sentAt = _resolveSentAt(json);

    return ChatMessageModel(
      id: id,
      content: json['content'] as String? ?? '',
      sentAt: sentAt,
      sender: sender,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sentAt': sentAt,
      'sender': sender.name,
      'status': status.name,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      if (attachmentName != null) 'attachmentName': attachmentName,
      if (attachmentSize != null) 'attachmentSize': attachmentSize,
      if (attachmentMimeType != null) 'attachmentMimeType': attachmentMimeType,
    };
  }

  @override
  ChatMessageModel copyWith({
    String? id,
    String? content,
    String? sentAt,
    ChatMessageSender? sender,
    ChatMessageStatus? status,
    String? attachmentUrl,
    String? attachmentName,
    int? attachmentSize,
    String? attachmentMimeType,
    String? localFilePath,
    bool clearAttachmentUrl = false,
    bool clearAttachmentName = false,
    bool clearAttachmentSize = false,
    bool clearAttachmentMimeType = false,
    bool clearLocalFilePath = false,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      sender: sender ?? this.sender,
      status: status ?? this.status,
      attachmentUrl:
          clearAttachmentUrl ? null : (attachmentUrl ?? this.attachmentUrl),
      attachmentName: clearAttachmentName
          ? null
          : (attachmentName ?? this.attachmentName),
      attachmentSize: clearAttachmentSize
          ? null
          : (attachmentSize ?? this.attachmentSize),
      attachmentMimeType: clearAttachmentMimeType
          ? null
          : (attachmentMimeType ?? this.attachmentMimeType),
      localFilePath: clearLocalFilePath
          ? null
          : (localFilePath ?? this.localFilePath),
    );
  }

  static String _resolveId(Map<String, dynamic> json) {
    // Socket payload uses 'messageId', HTTP uses 'id'
    final id = json['messageId'] ?? json['id'];
    return id?.toString() ?? '';
  }

  static ChatMessageSender _resolveSender(Map<String, dynamic> json) {
    final senderType = json['senderType'];
    if (senderType is int) {
      // 0 = DOCTOR, 1 = PATIENT
      return senderType == 0
          ? ChatMessageSender.doctor
          : ChatMessageSender.user;
    }
    if (senderType is String) {
      if (senderType == 'DOCTOR') return ChatMessageSender.doctor;
      if (senderType == 'PATIENT') return ChatMessageSender.user;
    }
    // Fallback to old string sender field
    final sender = json['sender'] as String?;
    return ChatMessageSender.values.firstWhere(
      (s) => s.name == sender,
      orElse: () => ChatMessageSender.doctor,
    );
  }

  static ChatMessageStatus _resolveStatus(Map<String, dynamic> json) {
    final status = json['status'];
    if (status is int) {
      // 0 = SENT, 1 = DELIVERED, 2 = READ
      switch (status) {
        case 0:
          return ChatMessageStatus.sent;
        case 1:
          return ChatMessageStatus.delivered;
        case 2:
          return ChatMessageStatus.seen;
      }
    }
    if (status is String) {
      if (status == 'SENT') return ChatMessageStatus.sent;
      if (status == 'DELIVERED') return ChatMessageStatus.delivered;
      if (status == 'READ') return ChatMessageStatus.seen;
    }
    return ChatMessageStatus.sent;
  }

  static String _resolveSentAt(Map<String, dynamic> json) {
    // Prefer 'createdAt' ISO string, fallback to old 'sentAt'
    final createdAt = json['createdAt'] as String?;
    if (createdAt != null && createdAt.length >= 16) {
      // Extract HH:mm from ISO string "2026-07-09T03:00:00Z"
      try {
        return createdAt.substring(11, 16);
      } catch (_) {
        return createdAt;
      }
    }
    return json['sentAt'] as String? ?? '';
  }
}
