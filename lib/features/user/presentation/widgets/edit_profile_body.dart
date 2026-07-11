import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/user_profile_image.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:cliniq/features/user/presentation/providers/update_profile_provider.dart';
import 'package:cliniq/features/user/presentation/widgets/edit_emergency_contact_section.dart';
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
  late TextEditingController allergiesController;
  late TextEditingController chronicConditionsController;
  late TextEditingController emergencyNameController;
  late TextEditingController emergencyPhoneController;

  String? gender;
  String? dateOfBirth;
  String? bloodGroup;
  bool hasDiabetes = false;
  bool hasPressureIssues = false;

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
    allergiesController = TextEditingController(text: user?.allergies ?? '');
    chronicConditionsController = TextEditingController(text: user?.chronicConditions ?? '');
    emergencyNameController = TextEditingController(text: user?.emergencyContactName ?? '');
    emergencyPhoneController = TextEditingController(text: user?.emergencyContactPhone ?? '');
    gender = user?.gender;
    dateOfBirth = user?.dateOfBirth;
    bloodGroup = user?.bloodGroup;
    hasDiabetes = user?.hasDiabetes ?? false;
    hasPressureIssues = user?.hasPressureIssues ?? false;
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
    allergiesController.dispose();
    chronicConditionsController.dispose();
    emergencyNameController.dispose();
    emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> onSave() async {
    final data = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'phoneNumber': mobileController.text,
      'height': heightController.text,
      'weight': weightController.text,
      'ailments': ailmentsController.text,
      'allergies': allergiesController.text,
      'chronicConditions': chronicConditionsController.text,
      'emergencyContactName': emergencyNameController.text,
      'emergencyContactPhone': emergencyPhoneController.text,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (bloodGroup != null) 'bloodGroup': bloodGroup,
      'hasDiabetes': hasDiabetes,
      'hasPressureIssues': hasPressureIssues,
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
            gender: gender,
            dateOfBirth: dateOfBirth,
            onGenderChanged: (v) => setState(() => gender = v),
            onDateOfBirthChanged: (v) => setState(() => dateOfBirth = v.toIso8601String().split('T').first),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
          const VerticalGap(24),
          EditPhysicalMetricsSection(
            heightController: heightController,
            weightController: weightController,
            bloodGroup: bloodGroup,
            onBloodGroupChanged: (v) => setState(() => bloodGroup = v),
          ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
          const VerticalGap(24),
          EditMedicalInfoSection(
            ailmentsController: ailmentsController,
            allergiesController: allergiesController,
            chronicConditionsController: chronicConditionsController,
            hasDiabetes: hasDiabetes,
            hasPressureIssues: hasPressureIssues,
            onDiabetesChanged: (v) => setState(() => hasDiabetes = v),
            onPressureChanged: (v) => setState(() => hasPressureIssues = v),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
          const VerticalGap(24),
          EditEmergencyContactSection(
            emergencyNameController: emergencyNameController,
            emergencyPhoneController: emergencyPhoneController,
          ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
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
