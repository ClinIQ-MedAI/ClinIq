import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/notifications/presentation/providers/notification_list_provider.dart';
import 'package:cliniq/features/notifications/presentation/widgets/notification_card.dart';
import 'package:cliniq/features/notifications/presentation/widgets/notifications_app_bar.dart';
import 'package:cliniq/features/notifications/presentation/widgets/notifications_empty_state.dart';
import 'package:cliniq/features/notifications/presentation/widgets/notifications_error_state.dart';
import 'package:cliniq/features/notifications/presentation/widgets/notifications_loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: NotificationsAppBar(
        title: LocaleKeys.notificationsTitle.tr(),
        showReadAll: notificationsAsync.value?.any((n) => !n.isRead) ?? false,
        onReadAll: () => ref.read(notificationListProvider.notifier).readAll(),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationListProvider.notifier).refresh(),
        child: notificationsAsync.when(
          loading: () => const NotificationsLoadingState(),
          error: (error, stack) => NotificationsErrorState(
            title: LocaleKeys.notificationsErrorTitle.tr(),
            description: LocaleKeys.notificationsErrorDescription.tr(),
            onRetry: () => ref.read(notificationListProvider.notifier).refresh(),
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return NotificationsEmptyState(
                title: LocaleKeys.notificationsEmptyTitle.tr(),
                description: LocaleKeys.notificationsEmptyDescription.tr(),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () {
                    ref
                        .read(notificationListProvider.notifier)
                        .readNotification(notification.id, index);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
