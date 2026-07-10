import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/home/domain/entities/news_entity.dart';
import 'package:cliniq/features/home/presentation/providers/get_home_data_provider.dart';
import 'package:cliniq/features/home/presentation/widgets/home_section_empty_state.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(getHomeDataProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: ProfileAppBar(
        title: LocaleKeys.homeNewsScreenTitle.tr(),
      ),
      body: homeDataAsync.when(
        data: (result) => result.fold(
          (failure) => Center(child: Text(failure.message)),
          (homeData) => _buildList(context, homeData.news),
        ),
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<NewsEntity> news,
  ) {
    if (news.isEmpty) {
      return Center(
        child: HomeSectionEmptyState(
          icon: Icons.newspaper_rounded,
          title: LocaleKeys.homeNoNews.tr(),
          description: LocaleKeys.homeNoNewsDesc.tr(),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
      itemCount: news.length,
      separatorBuilder: (_, __) => const VerticalGap(20),
      itemBuilder: (context, index) {
        final item = news[index];
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: context.colorScheme.primary.withValues(alpha: 0.08),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200.h,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: item.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: context.colorScheme.surfaceContainerHigh,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: context.colorScheme.surfaceContainerHigh,
                    child: Icon(
                      Icons.newspaper_rounded,
                      color: context.textPalette.secondaryColor,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.getTextStyle(18).copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.textPalette.primaryColor,
                      ),
                    ),
                    const VerticalGap(10),
                    Text(
                      item.description,
                      style: AppTextStyles.getTextStyle(14).copyWith(
                        color: context.textPalette.secondaryColor,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.05);
      },
    );
  }
}
