import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/home/domain/entities/news_entity.dart';
import 'package:cliniq/features/home/presentation/widgets/home_section_empty_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeNewsWidget extends StatelessWidget {
  const HomeNewsWidget({super.key, required this.news});

  final List<NewsEntity> news;

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) {
      return HomeSectionEmptyState(
        icon: Icons.newspaper_rounded,
        title: LocaleKeys.homeNoNews.tr(),
        description: LocaleKeys.homeNoNewsDesc.tr(),
      );
    }

    final items = news.take(4).toList();

    return SizedBox(
      height: 300.h,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const HorizontalGap(20),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 280.w,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withValues(alpha: 0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
              border: Border.all(
                color: context.colorScheme.primary.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32.r),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: item.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            color: context.colorScheme.surfaceContainerHigh,
                            child: const Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: context.colorScheme.surfaceContainerHigh,
                            child: Icon(
                              Icons.newspaper_rounded,
                              color: context.textPalette.secondaryColor,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary.withValues(
                                alpha: 0.9,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'HEALTH',
                              style:
                                  AppTextStyles.getTextStyle(10).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.getTextStyle(16).copyWith(
                            fontWeight: FontWeight.w800,
                            color: context.textPalette.primaryColor,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const VerticalGap(8),
                        Expanded(
                          child: Text(
                            item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.getTextStyle(13).copyWith(
                              color: context.textPalette.secondaryColor,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
