import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_svgs.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/user_profile_image.dart';
import 'package:cliniq/features/notifications/presentation/providers/unread_count_provider.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProvider);
    final unreadCount = ref.watch(unreadCountProvider);
    ref.read(unreadCountProvider.notifier).load();
    final userName = userProfile?.fullName ?? 'User';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50.h,
            right: -50.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -30.h,
            left: -20.w,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Colors.white.withValues(alpha: 0.2),
                                width: 2,
                              ),
                            ),
                            child: const UserProfileImage(
                              circleAvatarRadius: 28,
                            ),
                          )
                          .animate()
                          .scale(
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          )
                          .fadeIn(),
                      const HorizontalGap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.homeWelcomeBack.tr(),
                              style: AppTextStyles.getTextStyle(14)
                                  .copyWith(
                                    color: context.colorScheme.onPrimary
                                        .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Text(
                              userName,
                              style: AppTextStyles.getTextStyle(22)
                                  .copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: context.colorScheme.onPrimary,
                                    letterSpacing: -0.5,
                                  ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 200.ms).slideX(
                              begin: -0.1,
                            ),
                      ),
                      Container(
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color:
                                Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: IconButton(
                          icon: Badge(
                            isLabelVisible: unreadCount > 0,
                            backgroundColor:
                                context.colorScheme.secondary,
                            smallSize: 18,
                            label: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            child: SvgPicture.asset(
                              AppSvgs.notificationIcon,
                              height: 24.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.notificationsScreen,
                            );
                          },
                        ),
                      ).animate().fadeIn(delay: 400.ms).scale(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
