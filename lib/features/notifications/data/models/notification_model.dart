import 'package:cliniq/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.createdAt,
    super.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final createdAt = _resolveCreatedAt(json);

    return NotificationModel(
      id: id,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: createdAt,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }

  @override
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  static String _resolveCreatedAt(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] as String?;
    if (createdAt != null && createdAt.isNotEmpty) return createdAt;
    return '';
  }
}
