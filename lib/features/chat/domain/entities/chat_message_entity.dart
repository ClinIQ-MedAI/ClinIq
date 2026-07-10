import 'package:cliniq/core/api/api_urls.dart';

enum ChatMessageSender { user, doctor, ai }

enum ChatMessageStatus { sending, sent, delivered, seen, failed }

class ChatMessageEntity {
  const ChatMessageEntity({
    required this.id,
    required this.content,
    required this.sentAt,
    required this.sender,
    required this.status,
    this.senderId,
    this.attachmentUrl,
    this.attachmentName,
    this.attachmentSize,
    this.attachmentMimeType,
    this.localFilePath,
  });

  final String id;
  final String content;
  final String sentAt;
  final ChatMessageSender sender;
  final String? senderId;
  final ChatMessageStatus status;
  final String? attachmentUrl;
  final String? attachmentName;
  final int? attachmentSize;
  final String? attachmentMimeType;
  final String? localFilePath;

  bool get hasAttachment => localFilePath != null || attachmentUrl != null;

  String get attachmentDisplayName {
    if (attachmentName != null) return attachmentName!;
    if (attachmentUrl != null) return attachmentUrl!.split('/').last;
    if (localFilePath != null) return localFilePath!.split('/').last;
    return '';
  }

  String get resolvedAttachmentUrl {
    if (attachmentUrl == null) return '';
    if (attachmentUrl!.startsWith('http')) return attachmentUrl!;
    final base = ApiUrls.baseUrl;
    return '${base.replaceAll(RegExp(r'/+$'), '')}/${attachmentUrl!.replaceAll(RegExp(r'^/+'), '')}';
  }

  bool get isImageAttachment {
    if (localFilePath != null) {
      final ext = localFilePath!.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext)) {
        return true;
      }
    }

    if (attachmentUrl == null) return false;

    if (attachmentMimeType != null && attachmentMimeType!.startsWith('image/')) {
      return true;
    }

    if (attachmentName != null) {
      final ext = attachmentName!.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext)) {
        return true;
      }
    }

    final ext = attachmentUrl!.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext)) {
      return true;
    }

    return false;
  }

  ChatMessageEntity copyWith({
    String? id,
    String? content,
    String? sentAt,
    ChatMessageSender? sender,
    String? senderId,
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
    bool clearSenderId = false,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      sender: sender ?? this.sender,
      senderId: clearSenderId ? null : (senderId ?? this.senderId),
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
}
