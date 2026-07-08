import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/user_profile_image.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:cliniq/features/user/presentation/providers/update_profile_provider.dart';
import 'package:cliniq/features/user/presentation/widgets/edit_medical_info_section.dart';
import 'package:cliniq/features/user/presentation/widgets/edit_personal_info_section.dart';
import 'package:cliniq/features/user/presentation/widgets/edit_physical_metrics_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileBody extends ConsumerStatefulWidget {
  const EditProfileBody({super.key});

  @override
  ConsumerState<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends ConsumerState<EditProfileBody> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController ailmentsController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    firstNameController = TextEditingController(text: user?.firstName ?? '');
    lastNameController = TextEditingController(text: user?.lastName ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    mobileController = TextEditingController(text: user?.phoneNumber ?? '');
    heightController = TextEditingController(text: user?.height ?? '');
    weightController = TextEditingController(text: user?.weight ?? '');
    ailmentsController = TextEditingController(text: user?.ailments ?? '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    heightController.dispose();
    weightController.dispose();
    ailmentsController.dispose();
    super.dispose();
  }

  Future<void> onSave() async {
    final data = { 
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'mobile': mobileController.text,
      'height': heightController.text,
      'weight': weightController.text,
      'ailments': ailmentsController.text,
    };

    await ref.read(updateProfileProvider.notifier).updateProfile(data);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                const UserProfileImage(circleAvatarRadius: 60, isEnabled: true),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().scale(),
          const VerticalGap(40),
          EditPersonalInfoSection(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            emailController: emailController,
            mobileController: mobileController,
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
          const VerticalGap(24),
          EditPhysicalMetricsSection(
            heightController: heightController,
            weightController: weightController,
          ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
          const VerticalGap(24),
          EditMedicalInfoSection(
            ailmentsController: ailmentsController,
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
          const VerticalGap(48),
          CustomButton(
            text: LocaleKeys.profileUserSave,
            onPressed: onSave,
          ).animate().fadeIn(delay: 800.ms).scale(),
          const VerticalGap(24),
        ],
      ),
    );
  }
}
