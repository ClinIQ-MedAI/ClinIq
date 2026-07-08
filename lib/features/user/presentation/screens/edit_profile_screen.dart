import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';
import 'package:cliniq/features/user/presentation/widgets/edit_profile_body.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/features/user/presentation/providers/get_user_repo_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ailmentsController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _mobileController = TextEditingController(text: user?.phoneNumber ?? '');
    _heightController = TextEditingController(text: user?.height ?? '');
    _weightController = TextEditingController(text: user?.weight ?? '');
    _ailmentsController = TextEditingController(text: user?.ailments ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ailmentsController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() => _isSaving = true);

    final data = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'mobile': _mobileController.text,
      'height': _heightController.text,
      'weight': _weightController.text,
      'ailments': _ailmentsController.text,
    };

    final result = await ref
        .read(getUserRepoProvider)
        .updateMe(data: data);

    result.fold(
      (failure) {
        showCustomSnackBar(context, failure.message);
        setState(() => _isSaving = false);
      },
      (user) {
        ref.read(currentUserProvider.notifier).updateUser(user);
        setState(() => _isSaving = false);
        if (mounted) Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: ProfileAppBar(
          title: LocaleKeys.profileUserUpdateProfile,
          showBackButton: true,
          onBackAction: () => Navigator.pop(context),
        ),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : EditProfileBody(
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              emailController: _emailController,
              mobileController: _mobileController,
              heightController: _heightController,
              weightController: _weightController,
              ailmentsController: _ailmentsController,
              onSave: _onSave,
            ),
    );
  }
}
