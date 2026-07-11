import 'package:cliniq/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepo {
  Future<List<NotificationEntity>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> readNotification(String id);
  Future<void> readAllNotifications();
}
