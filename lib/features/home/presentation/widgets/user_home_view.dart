import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/home/presentation/providers/bottom_nav_index_provider.dart';
import 'package:cliniq/features/home/presentation/providers/get_home_data_provider.dart';
import 'package:cliniq/features/home/presentation/widgets/home_appointments_widget.dart';
import 'package:cliniq/features/home/presentation/widgets/home_doctors_widget.dart';
import 'package:cliniq/features/home/presentation/widgets/home_header.dart';
import 'package:cliniq/features/home/presentation/widgets/home_news_widget.dart';
import 'package:cliniq/features/home/presentation/widgets/home_quick_actions.dart';
import 'package:cliniq/features/home/presentation/widgets/home_section_header.dart';
import 'package:cliniq/features/home/presentation/widgets/home_specializations_widget.dart';
import 'package:cliniq/features/home/presentation/widgets/see_all_button.dart';
import 'package:cliniq/features/home/presentation/widgets/ai_assistant_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserHomeView extends ConsumerWidget {
  const UserHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: ref
                .watch(getHomeDataProvider)
                .when(
                  data: (result) {
                    return result.fold(
                      (failure) => Center(child: Text(failure.message.tr())),
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
                                const HomeQuickActions()
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
                                      trailing: SeeAllButton(
                                        onPressed: () => Navigator.pushNamed(
                                          context,
                                          Routes.appointmentsScreen,
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: 250.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(20),
                                HomeAppointmentsWidget(
                                      appointments:
                                          homeData.examinationAppointments,
                                      onBookAppointment: () {
                                        ref
                                            .read(
                                              bottomNavIndexProvider.notifier,
                                            )
                                            .setIndex(1);
                                      },
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
                                      trailing: SeeAllButton(
                                        onPressed: () => Navigator.pushNamed(
                                          context,
                                          Routes.specializationsScreen,
                                        ),
                                      ),
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
                                      trailing: SeeAllButton(
                                        onPressed: () => Navigator.pushNamed(
                                          context,
                                          Routes.doctorsScreen,
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: 650.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(20),
                                HomeDoctorsWidget(
                                      doctors: homeData.suggestedDoctors,
                                    )
                                    .animate()
                                    .fadeIn(delay: 750.ms)
                                    .slideY(begin: 0.1),
                                const VerticalGap(32),
                                HomeSectionHeader(
                                      title: LocaleKeys.homeNewNews,
                                      description: LocaleKeys.homeNewsDesc,
                                      icon: Icons.newspaper_rounded,
                                      trailing: SeeAllButton(
                                        onPressed: () => Navigator.pushNamed(
                                          context,
                                          Routes.newsScreen,
                                        ),
                                      ),
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
}
