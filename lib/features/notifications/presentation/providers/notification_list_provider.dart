import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/features/notifications/domain/entities/notification_entity.dart';
import 'package:cliniq/features/notifications/domain/repos/notification_repo.dart';
import 'package:cliniq/features/notifications/presentation/providers/notification_repo_provider.dart';
import 'package:cliniq/features/notifications/presentation/providers/unread_count_provider.dart';

final notificationListProvider =
    AsyncNotifierProvider<NotificationListNotifier, List<NotificationEntity>>(
      NotificationListNotifier.new,
    );

class NotificationListNotifier
    extends AsyncNotifier<List<NotificationEntity>> {
  late final NotificationRepo _repo;

  @override
  FutureOr<List<NotificationEntity>> build() async {
    _repo = ref.read(notificationRepoProvider);
    return _repo.getNotifications();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final notifications = await _repo.getNotifications();
      await ref.read(unreadCountProvider.notifier).load();
      return notifications;
    });
  }

  Future<void> readNotification(String id, int index) async {
    final currentState = state.value;
    if (currentState == null) return;

    final notification = currentState[index];
    if (notification.isRead) return;

    try {
      await _repo.readNotification(id);
    } catch (_) {
      return;
    }

    final updated = [
      for (int i = 0; i < currentState.length; i++)
        if (i == index) currentState[i].copyWith(isRead: true) else currentState[i],
    ];
    state = AsyncData(updated);
    ref.read(unreadCountProvider.notifier).decrement();
  }

  Future<void> readAll() async {
    try {
      await _repo.readAllNotifications();
    } catch (_) {
      return;
    }

    final currentState = state.value;
    if (currentState == null) return;

    final updated = currentState.map((n) => n.copyWith(isRead: true)).toList();
    state = AsyncData(updated);
    ref.read(unreadCountProvider.notifier).reset();
  }
}
