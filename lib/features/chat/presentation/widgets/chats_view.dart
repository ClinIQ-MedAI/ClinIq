import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/presentation/arguments/chat_details_arguments.dart';
import 'package:cliniq/features/chat/presentation/providers/doctor_conversations_provider.dart';
import 'package:cliniq/features/chat/presentation/providers/start_chat_provider.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_conversation_tile.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_loading_state.dart';
import 'package:cliniq/features/chat/presentation/widgets/empty_conversations_state.dart';
import 'package:cliniq/features/chat/presentation/widgets/new_conversation_button.dart';
import 'package:cliniq/features/chat/presentation/widgets/new_conversation_sheet.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:cliniq/features/home/presentation/providers/get_home_data_provider.dart';
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
      appBar: ProfileAppBar(
        title: LocaleKeys.chatDoctorTitle,
        showBackButton: false,
        actions: [
          NewConversationButton(
            onTap: () => _showNewConversationSheet(context, ref),
          ),
        ],
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return EmptyConversationsState(
              onStartConversation: () =>
                  _showNewConversationSheet(context, ref),
            );
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
                  Navigator.pushNamed(
                    context,
                    Routes.chatDetailsScreen,
                    arguments: ChatDetailsArguments(
                      conversationId: conversation.id,
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

  void _showNewConversationSheet(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.read(getHomeDataProvider);

    homeDataAsync.whenData((either) {
      either.fold(
        (failure) {
          _showSnackBar(context, failure.message);
        },
        (homeData) {
          if (homeData.suggestedDoctors.isEmpty) {
            _showSnackBar(
              context,
              LocaleKeys.messagesFailuresUnexpectedError.tr(),
            );
            return;
          }
          _showDoctorSheet(context, ref, homeData.suggestedDoctors);
        },
      );
    });
  }

  void _showDoctorSheet(
    BuildContext context,
    WidgetRef ref,
    List<DoctorEntity> doctors,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewConversationSheet(
        doctors: doctors,
        onDoctorSelected: (doctor) => _startConversation(context, ref, doctor),
      ),
    );
  }

  Future<void> _startConversation(
    BuildContext context,
    WidgetRef ref,
    DoctorEntity doctor,
  ) async {
    Navigator.pop(context);

    final useCase = ref.read(startChatUseCaseProvider);

    try {
      final conversation = await useCase(
        doctorId: doctor.id,
        doctorName: doctor.name,
      );

      if (!context.mounted) return;
      await Navigator.pushNamed(
        context,
        Routes.chatDetailsScreen,
        arguments: ChatDetailsArguments(conversationId: conversation.id),
      );

      ref.invalidate(doctorConversationsProvider);
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, '$e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    showCustomSnackBar(context, message);
  }
}
