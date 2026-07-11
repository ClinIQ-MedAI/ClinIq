import 'package:cliniq/core/api/api_consumer.dart';
import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/features/notifications/data/models/notification_model.dart';
import 'package:cliniq/features/notifications/domain/entities/notification_entity.dart';
import 'package:cliniq/features/notifications/domain/repos/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  NotificationRepoImpl({required this.api});

  final ApiConsumer api;

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final response = await api.get(EndPoints.getNotifications);
    final raw = response is List
        ? response
        : (response['data'] as List? ?? []);
    return raw
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await api.get(EndPoints.getUnreadNotificationCount);
    final count = response is Map
        ? (response['count'] ?? response['data']?['count'] ?? 0)
        : 0;
    return count is int ? count : int.tryParse(count.toString()) ?? 0;
  }

  @override
  Future<void> readNotification(String id) async {
    await api.put(EndPoints.readNotification(id));
  }

  @override
  Future<void> readAllNotifications() async {
    await api.put(EndPoints.readAllNotifications);
  }
}
