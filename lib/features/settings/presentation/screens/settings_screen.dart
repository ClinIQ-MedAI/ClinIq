import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/cubits/app_theme_cubit/app_theme_cubit.dart';
import 'package:cliniq/core/cubits/app_theme_cubit/app_theme_state.dart';
import 'package:cliniq/core/enums/app_theme_mode.dart';
import 'package:cliniq/core/widgets/custom_divider.dart';
import 'package:cliniq/core/widgets/custom_switch_tile.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/settings/presentation/widgets/language_tile.dart';
import 'package:cliniq/features/settings/presentation/widgets/settings_action_tile.dart';
import 'package:cliniq/core/widgets/custom_card_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/features/user/presentation/providers/current_user_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          LocaleKeys.settingsUserTitle.tr(),
          style: AppTextStyles.getTextStyle(20).copyWith(
            fontWeight: FontWeight.w700,
            color: context.textPalette.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomCardSection(
              children: [
                CustomSwitchTile(
                  title: LocaleKeys.settingsUserPushNotifications,
                  value: _pushNotifications,
                  onChanged: (val) {
                    setState(() => _pushNotifications = val);
                  },
                ),
                CustomSwitchTile(
                  title: LocaleKeys.settingsUserSmsNotifications,
                  value: _smsNotifications,
                  onChanged: (val) {
                    setState(() => _smsNotifications = val);
                  },
                ),
                CustomSwitchTile(
                  title: LocaleKeys.settingsUserEmailNotifications,
                  value: _emailNotifications,
                  onChanged: (val) {
                    setState(() => _emailNotifications = val);
                  },
                ),
              ],
            ),

            const VerticalGap(20),

            Text(
              LocaleKeys.settingsUserGeneral.tr(),
              style: AppTextStyles.getTextStyle(18).copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const VerticalGap(12),
            CustomCardSection(
              children: [
                BlocBuilder<AppThemeCubit, AppThemeState>(
                  builder: (context, state) {
                    final themeCubit = context.read<AppThemeCubit>();
                    return CustomSwitchTile(
                      title: LocaleKeys.settingsUserDarkMode,
                      value: themeCubit.currentTheme == AppThemeMode.dark,
                      onChanged: (val) {
                        themeCubit.changeTheme(
                          val ? AppThemeMode.dark : AppThemeMode.light,
                        );
                      },
                    );
                  },
                ),
                const CustomDivider(),
                LanguageTile(),
              ],
            ),

            const VerticalGap(20),

            CustomCardSection(
              children: [
                SettingsActionTile(
                  title: LocaleKeys.settingsUserChangePassword.tr(),
                  icon: Icons.lock_outline,
                  onTap: () {},
                ),
                SettingsActionTile(
                  title: LocaleKeys.settingsUserMyLocation.tr(),
                  icon: Icons.location_on_outlined,
                  onTap: () {},
                ),
                SettingsActionTile(
                  title: LocaleKeys.settingsUserChangeNumber.tr(),
                  icon: Icons.phone_android_outlined,
                  onTap: () {},
                ),
                SettingsActionTile(
                  title: LocaleKeys.settingsUserChangeEmail.tr(),
                  icon: Icons.email_outlined,
                  onTap: () {},
                ),
                SettingsActionTile(
                  title: LocaleKeys.settingsUserTwoFactorAuth.tr(),
                  icon: Icons.security_outlined,
                  onTap: () {},
                ),
              ],
            ),

            const VerticalGap(20),

            CustomCardSection(
              children: [
                SettingsActionTile(
                  title: LocaleKeys.settingsUserPrivacyPolicy.tr(),
                  icon: Icons.privacy_tip_outlined,
                  onTap: () {
                    Navigator.pushNamed(context, Routes.privacyPolicyScreen);
                  },
                ),
                SettingsActionTile(
                  title: LocaleKeys.settingsUserTermsAndServices.tr(),
                  icon: Icons.description_outlined,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.termsAndConditionsScreen,
                    );
                  },
                ),
              ],
            ),

            const VerticalGap(20),

            CustomCardSection(
              children: [
                SettingsActionTile(
                  title: LocaleKeys.settingsUserLogout.tr(),
                  icon: Icons.logout,
                  onTap: () async {
                    await AppStorageHelper.deleteSecureData(
                      StorageKeys.accessToken,
                    );
                    await AppStorageHelper.deleteSecureData(
                      StorageKeys.refreshToken,
                    );
                    await AppStorageHelper.setBool(
                      StorageKeys.isLoggedIn,
                      false,
                    );
                    await AppStorageHelper.remove(StorageKeys.currentUser);
                    await AppStorageHelper.remove(StorageKeys.currentUserId);

                    ref.read(currentUserProvider.notifier).clearUser();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.loginScreen,
                        (route) => false,
                      );
                    }
                  },
                  textColor: context.colorScheme.error,
                  iconColor: context.colorScheme.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
