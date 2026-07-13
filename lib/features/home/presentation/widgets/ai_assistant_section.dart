import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAssistantSection extends ConsumerWidget {
  const AiAssistantSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  context.colorScheme.primary.withValues(alpha: 0.15),
                  context.colorScheme.secondary.withValues(alpha: 0.05),
                ]
              : [
                  context.colorScheme.primary.withValues(alpha: 0.08),
                  context.colorScheme.primary.withValues(alpha: 0.02),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: context.colorScheme.primary.withValues(
            alpha: isDark ? 0.25 : 0.15,
          ),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(
              alpha: isDark ? 0.05 : 0.02,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: () {
            final userProfile = ref.watch(currentUserProvider);
            final isProfileCompleted = userProfile?.isProfileCompleted ?? false;
            if (isProfileCompleted) {
              Navigator.pushNamed(context, Routes.aiChatScreen);
            } else {
              showCustomSnackBar(
                context,
                "You must complete your profile before trying this feature",
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // AI Badge / Icon
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorScheme.primary.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: context.colorScheme.primary,
                    size: 32.sp,
                  ),
                ),
                const HorizontalGap(20),
                // AI Title, Desc and Button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.homeAiAssistantTitle.tr(),
                        style: AppTextStyles.getTextStyle(18).copyWith(
                          fontWeight: FontWeight.w800,
                          color: context.textPalette.primaryColor,
                        ),
                      ),
                      const VerticalGap(6),
                      Text(
                        LocaleKeys.homeAiAssistantDescription.tr(),
                        style: AppTextStyles.getTextStyle(12).copyWith(
                          color: context.textPalette.secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const VerticalGap(14),
                      SizedBox(
                        width: 140.w,
                        child: CustomButton(
                          text: LocaleKeys.homeAiAssistantStartChat.tr(),
                          height: 38,
                          borderRadius: 12,
                          textFontSize: 13,
                          onPressed: () {
                            final userProfile = ref.watch(currentUserProvider);
                            final isProfileCompleted =
                                userProfile?.isProfileCompleted ?? false;
                            if (isProfileCompleted) {
                              Navigator.pushNamed(context, Routes.aiChatScreen);
                            } else {
                              showCustomSnackBar(
                                context,
                                "You must complete your profile before trying this feature",
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
