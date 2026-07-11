import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/features/notifications/presentation/providers/notification_repo_provider.dart';

final unreadCountProvider =
    NotifierProvider<UnreadCountNotifier, int>(UnreadCountNotifier.new);

class UnreadCountNotifier extends Notifier<int> {
  @override
  int build() => 0;

  Future<void> load() async {
    final count = await ref.read(notificationRepoProvider).getUnreadCount();
    if (count >= 0) state = count;
  }

  void decrement() {
    if (state > 0) state = state - 1;
  }

  void reset() {
    state = 0;
  }

  void setCount(int count) {
    state = count;
  }
}
