import 'package:cliniq/core/widgets/app_bottom_navigation_bar.dart';
import 'package:cliniq/features/appointments/presentation/widgets/user_appoinments_view.dart';
import 'package:cliniq/features/chat/presentation/widgets/chats_view.dart';
import 'package:cliniq/features/home/presentation/providers/bottom_nav_index_provider.dart';
import 'package:cliniq/features/home/presentation/widgets/user_home_view.dart';
import 'package:cliniq/features/user/presentation/widgets/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserMainLayout extends ConsumerWidget {
  const UserMainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          UserHomeView(),
          UserAppointmentsView(),
          ChatsView(),
          UserProfileView(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: selectedIndex,
        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).setIndex(index);
        },
      ),
    );
  }
}
