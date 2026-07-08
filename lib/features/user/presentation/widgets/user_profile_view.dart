import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:cliniq/features/user/presentation/widgets/basic_info_section.dart';
import 'package:cliniq/features/user/presentation/widgets/medical_info_section.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_header.dart';
import 'package:cliniq/features/user/presentation/widgets/incomplete_profile_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProvider);
    final isProfileCompleted = ref
        .read(currentUserProvider.notifier)
        .isProfileCompleted;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ProfileAppBar(
          title: LocaleKeys.profileUserTitle,
          showBackButton: false,
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.settingsScreen),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.settings_suggest_rounded,
                  color: context.colorScheme.onPrimary,
                  size: 22.sp,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            children: [
              if (userProfile != null)
                ProfileHeader(
                      name: userProfile.fullName,
                      email: userProfile.email,
                      profilePic: userProfile.profilePic,
                    )
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .scale(begin: const Offset(0.9, 0.9)),

              if (userProfile != null) ...[
                const VerticalGap(24),
                BasicInfoSection(
                  phone: userProfile.phoneNumber,
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
              ],

              if (!isProfileCompleted) ...[
                const VerticalGap(24),
                const IncompleteProfileBanner()
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .slideY(begin: 0.1),
              ],

              if (isProfileCompleted && userProfile != null) ...[
                const VerticalGap(32),
                MedicalInfoSection(
                  user: userProfile,
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
              ],

              if (isProfileCompleted) ...[
                const VerticalGap(40),
                CustomButton(
                  text: LocaleKeys.profileUserEditProfile,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.editProfileScreen);
                  },
                ).animate().fadeIn(delay: 900.ms).scale(),
                const VerticalGap(20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
