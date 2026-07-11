import 'package:cliniq/core/services/get_it_service.dart';
import 'package:cliniq/features/notifications/domain/repos/notification_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepoProvider = Provider<NotificationRepo>((ref) {
  return getIt<NotificationRepo>();
});
