import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/home/domain/entities/specialization_entity.dart';
import 'package:cliniq/features/home/presentation/widgets/home_section_empty_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSpecializationsWidget extends StatelessWidget {
  const HomeSpecializationsWidget({super.key, required this.specializations});

  final List<SpecializationEntity> specializations;

  @override
  Widget build(BuildContext context) {
    if (specializations.isEmpty) {
      return HomeSectionEmptyState(
        icon: Icons.grid_view_rounded,
        title: LocaleKeys.homeNoSpecializations.tr(),
        description: LocaleKeys.homeNoSpecializationsDesc.tr(),
      );
    }

    final items = specializations.take(4).toList();

    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const HorizontalGap(16),
        itemBuilder: (context, index) {
          final spec = items[index];
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(28.r),
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.primary
                              .withValues(alpha: 0.08),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: context.colorScheme.primary
                            .withValues(alpha: 0.08),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28.r),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -8,
                            right: -8,
                            child: Icon(
                              Icons.medical_services_rounded,
                              size: 56,
                              color: context.colorScheme.primary
                                  .withValues(alpha: 0.06),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(22.w),
                            child: CachedNetworkImage(
                              imageUrl: spec.image,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.category_rounded,
                                color: context.textPalette.secondaryColor,
                                size: 32.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const VerticalGap(14),
              SizedBox(
                width: 100.w,
                child: Text(
                  spec.name.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.textPalette.primaryColor,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
