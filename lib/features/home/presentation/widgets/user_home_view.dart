import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/presentation/arguments/chat_details_arguments.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_repo_provider.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:cliniq/features/home/presentation/providers/get_home_data_provider.dart';
import 'package:cliniq/features/home/presentation/widgets/home_appointments_widget.dart';
import 'package:cliniq/features/home/presentation/widgets/home_doctors_widget.dart';
import 'package:cliniq/features/home/presentation/widgets/home_header.dart';
import 'package:cliniq/features/home/presentation/widgets/home_news_widget.dart';
import 'package:cliniq/features/home/presentation/widgets/home_section_header.dart';
import 'package:cliniq/features/home/presentation/widgets/home_specializations_widget.dart';
import 'package:cliniq/features/home/presentation/widgets/see_all_button.dart';
import 'package:cliniq/features/home/presentation/widgets/ai_assistant_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserHomeView extends ConsumerWidget {
  const UserHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          HomeHeader(),
          Expanded(
            child: ref
                .watch(getHomeDataProvider)
                .when(
                  data: (result) {
                    return result.fold(
                      (failure) => Center(child: Text(failure.message)),
                      (homeData) {
                        Theme.of(context);
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 40),
                            child: Column(
                              children: [
                                const AiAssistantSection()
                                    .animate()
                                    .fadeIn(delay: 50.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(32),
                                _buildQuickActions(context)
                                    .animate()
                                    .fadeIn(delay: 150.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(32),
                                HomeSectionHeader(
                                      title: LocaleKeys
                                          .homeExaminationAppointments,
                                      description:
                                          LocaleKeys.homeAppointmentsDesc,
                                      icon: Icons.calendar_today_rounded,
                                    )
                                    .animate()
                                    .fadeIn(delay: 250.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(20),
                                HomeAppointmentsWidget(
                                      appointments:
                                          homeData.examinationAppointments,
                                    )
                                    .animate()
                                    .fadeIn(delay: 350.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(32),
                                HomeSectionHeader(
                                      title: LocaleKeys.homeSpecialization,
                                      description:
                                          LocaleKeys.homeSpecializationsDesc,
                                      icon: Icons.grid_view_rounded,
                                      trailing: SeeAllButton(onPressed: () {}),
                                    )
                                    .animate()
                                    .fadeIn(delay: 450.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(20),
                                HomeSpecializationsWidget(
                                      specializations: homeData.specializations,
                                    )
                                    .animate()
                                    .fadeIn(delay: 550.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(32),
                                HomeSectionHeader(
                                      title: LocaleKeys.homeSuggestedDoctor,
                                      description: LocaleKeys.homeDoctorsDesc,
                                      icon: Icons.person_search_rounded,
                                      trailing: SeeAllButton(onPressed: () {}),
                                    )
                                    .animate()
                                    .fadeIn(delay: 650.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(20),
                                HomeDoctorsWidget(
                                      doctors: homeData.suggestedDoctors,
                                      onChatPressed: (doctor) =>
                                          _startConversation(context, ref, doctor),
                                    )
                                    .animate()
                                    .fadeIn(delay: 750.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(32),
                                HomeSectionHeader(
                                      title: LocaleKeys.homeNewNews,
                                      description: LocaleKeys.homeNewsDesc,
                                      icon: Icons.newspaper_rounded,
                                      trailing: SeeAllButton(onPressed: () {}),
                                    )
                                    .animate()
                                    .fadeIn(delay: 850.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(20),
                                HomeNewsWidget(news: homeData.news)
                                    .animate()
                                    .fadeIn(delay: 950.ms)
                                    .slideY(begin: 0.1),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stack) =>
                      Center(child: Text(error.toString())),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.bolt_rounded,
        'label': 'Urgent Care',
        'color': Colors.orange,
      },
      {
        'icon': Icons.home_repair_service_rounded,
        'label': 'Home Visit',
        'color': Colors.blue,
      },
      {
        'icon': Icons.local_pharmacy_rounded,
        'label': 'Pharmacies',
        'color': Colors.green,
      },
      {
        'icon': Icons.videocam_rounded,
        'label': 'Consultation',
        'color': Colors.purple,
      },
    ];

    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (context, index) => const HorizontalGap(16),
        itemBuilder: (context, index) {
          final action = actions[index];
          Color actionColor = action['color'] as Color;

          return Column(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: actionColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: actionColor.withValues(alpha: 0.2)),
                ),
                child: Icon(
                  action['icon'] as IconData,
                  color: actionColor,
                  size: 28.sp,
                ),
              ),
              const VerticalGap(8),
              Text(
                action['label'] as String,
                style: AppTextStyles.getTextStyle(12).copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textPalette.secondaryColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _startConversation(
    BuildContext context,
    WidgetRef ref,
    DoctorEntity doctor,
  ) async {
    final repo = ref.read(chatRepoProvider);

    try {
      final conversation = await repo.createConversation(doctorId: doctor.id);

      if (!context.mounted) return;

      Navigator.pushNamed(
        context,
        Routes.chatDetailsScreen,
        arguments: ChatDetailsArguments(
          conversationId: conversation.id,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.messagesFailuresUnexpectedError.tr())),
      );
    }
  }
}
