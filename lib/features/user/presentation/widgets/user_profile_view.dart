import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/user/data/models/user_profile_model.dart';
import 'package:cliniq/features/user/presentation/widgets/medical_info_section.dart';
import 'package:cliniq/features/user/presentation/widgets/personal_info_section.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_header.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_stat_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = UserProfileModel.mock();

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
              ProfileHeader(name: userProfile.name, email: userProfile.email)
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
              const VerticalGap(32),

              // Health Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileStatWidget(
                    label: LocaleKeys.profileUserAge.tr(),
                    value: '24',
                    unit: LocaleKeys.profileUserYears.tr(),
                    icon: Icons.calendar_today_rounded,
                    color: Colors.blueAccent,
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2),
                  ProfileStatWidget(
                    label: LocaleKeys.profileUserWeight.tr(),
                    value: userProfile.weight.replaceAll(' kg', ''),
                    unit: LocaleKeys.profileUserKg.tr(),
                    icon: Icons.monitor_weight_rounded,
                    color: Colors.orangeAccent,
                  ).animate().fadeIn(delay: 500.ms).scale(),
                  ProfileStatWidget(
                    label: LocaleKeys.profileUserHeight.tr(),
                    value: userProfile.height.replaceAll(' cm', ''),
                    unit: LocaleKeys.profileUserCm.tr(),
                    icon: Icons.height_rounded,
                    color: Colors.teal,
                  ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.2),
                ],
              ),
              const VerticalGap(40),

              PersonalInfoSection(
                email: userProfile.email,
                phone: userProfile.mobile,
                gender: 'Male',
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),

              const VerticalGap(32),

              MedicalInfoSection(
                bloodGroup: userProfile.bloodGroup,
                ailments: userProfile.ailments,
                medicalId: 'ID-9823-XYZ',
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),

              const VerticalGap(40),

              // Edit Button
              CustomButton(
                text: LocaleKeys.profileUserEditProfile.tr(),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.editProfileScreen);
                },
              ).animate().fadeIn(delay: 900.ms).scale(),
              const VerticalGap(20),
            ],
          ),
        ),
      ),
    );
  }
}
