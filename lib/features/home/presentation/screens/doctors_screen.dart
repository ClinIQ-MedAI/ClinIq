import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/custom_text_form_field.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:cliniq/features/home/presentation/providers/get_home_data_provider.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_card.dart';
import 'package:cliniq/features/home/presentation/widgets/home_section_empty_state.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorsScreen extends ConsumerStatefulWidget {
  const DoctorsScreen({super.key});

  @override
  ConsumerState<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends ConsumerState<DoctorsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeDataAsync = ref.watch(getHomeDataProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: ProfileAppBar(title: LocaleKeys.homeDoctorsScreenTitle.tr()),
      body: homeDataAsync.when(
        data: (result) => result.fold(
          (failure) => Center(child: Text(failure.message)),
          (homeData) => _buildList(context, ref, homeData.suggestedDoctors),
        ),
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<DoctorEntity> doctors,
  ) {
    final filteredDoctors = _searchQuery.isEmpty
        ? doctors
        : doctors
              .where(
                (d) =>
                    d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    d.speciality.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
            child: CustomTextFormField(
              controller: _searchController,
              hintText: LocaleKeys.homeDoctorsSearchHint.tr(),
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
        ),
        Expanded(
          child: filteredDoctors.isEmpty
              ? Center(
                  child: HomeSectionEmptyState(
                    icon: _searchQuery.isNotEmpty
                        ? Icons.search_off_rounded
                        : Icons.person_search_rounded,
                    title: _searchQuery.isNotEmpty
                        ? LocaleKeys.homeNoSearchResults.tr()
                        : LocaleKeys.homeNoDoctors.tr(),
                    description: _searchQuery.isNotEmpty
                        ? LocaleKeys.homeNoSearchResultsDesc.tr()
                        : LocaleKeys.homeNoDoctorsDesc.tr(),
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
                  itemCount: filteredDoctors.length,
                  separatorBuilder: (_, __) => const VerticalGap(16),
                  itemBuilder: (context, index) {
                    final doctor = filteredDoctors[index];
                    return DoctorCard(
                          doctor: doctor,
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.doctorDetailsScreen,
                            arguments: doctor,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: (index * 60).ms)
                        .slideX(begin: 0.05);
                  },
                ),
        ),
      ],
    );
  }
}
