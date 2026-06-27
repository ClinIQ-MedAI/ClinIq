import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/presentation/providers/doctor_conversations_provider.dart';
import 'package:cliniq/features/chat/presentation/screens/chat_details_screen.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_conversation_tile.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_loading_state.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsView extends ConsumerWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(doctorConversationsProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: const ProfileAppBar(
        title: LocaleKeys.chatDoctorTitle,
        showBackButton: false,
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return _DoctorChatsEmptyState();
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
            itemCount: conversations.length,
            separatorBuilder: (context, index) => const VerticalGap(16),
            itemBuilder: (context, index) {
              final conversation = conversations[index];

              return ChatConversationTile(
                conversation: conversation,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatDetailsScreen(conversationId: conversation.id),
                    ),
                  );
                },
              ).animate().fadeIn(delay: (index * 90).ms).slideY(begin: 0.08);
            },
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(LocaleKeys.messagesFailuresUnexpectedError.tr()),
        ),
        loading: () => const ChatLoadingState(),
      ),
    );
  }
}

class _DoctorChatsEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              color: context.colorScheme.primary,
              size: 56.sp,
            ),
            const VerticalGap(18),
            Text(
              LocaleKeys.chatDoctorListEmptyTitle.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(20).copyWith(
                color: context.textPalette.primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const VerticalGap(10),
            Text(
              LocaleKeys.chatDoctorListEmptyDescription.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(14).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
