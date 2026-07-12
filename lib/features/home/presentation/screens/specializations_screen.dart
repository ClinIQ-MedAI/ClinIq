import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/utils/image_validation_helper.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/home/domain/entities/specialization_entity.dart';
import 'package:cliniq/features/home/presentation/providers/get_home_data_provider.dart';
import 'package:cliniq/features/home/presentation/widgets/home_section_empty_state.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecializationsScreen extends ConsumerWidget {
  const SpecializationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(getHomeDataProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: ProfileAppBar(
        title: LocaleKeys.homeSpecializationsScreenTitle.tr(),
      ),
      body: homeDataAsync.when(
        data: (result) => result.fold(
          (failure) => Center(child: Text(failure.message)),
          (homeData) => _buildGrid(context, homeData.specializations),
        ),
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    List<SpecializationEntity> specializations,
  ) {
    if (specializations.isEmpty) {
      return Center(
        child: HomeSectionEmptyState(
          icon: Icons.grid_view_rounded,
          title: LocaleKeys.homeNoSpecializations.tr(),
          description: LocaleKeys.homeNoSpecializationsDesc.tr(),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: specializations.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final spec = specializations[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(24.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.primary
                              .withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: context.colorScheme.primary
                            .withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72.w,
                          height: 72.w,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: context.colorScheme.primary
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: isValidNetworkImage(spec.image)
                              ? CachedNetworkImage(
                                  imageUrl: spec.image,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(
                                    Icons.category_rounded,
                                    color: context
                                        .textPalette.secondaryColor,
                                    size: 28.sp,
                                  ),
                                )
                              : Icon(
                                  Icons.category_rounded,
                                  color:
                                      context.textPalette.secondaryColor,
                                  size: 28.sp,
                                ),
                        ),
                        const VerticalGap(12),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            spec.name.tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.getTextStyle(13).copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.textPalette.primaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: (index * 50).ms).scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    duration: 300.ms,
                  );
            },
          );
        },
      ),
    );
  }
}
