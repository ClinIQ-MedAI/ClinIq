import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/user_profile_image.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.profilePic,
  });

  final String name;
  final String email;
  final String? profilePic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colorScheme.primary.withValues(alpha: 0.2),
                  width: 3,
                ),
              ),
              child: UserProfileImage(
                circleAvatarRadius: 60,
                profilePicUrl: profilePic,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.verified_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
        const VerticalGap(20),
        Text(
          name,
          style: AppTextStyles.getTextStyle(26).copyWith(
            fontWeight: FontWeight.w900,
            color: context.textPalette.primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        const VerticalGap(6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: context.colorScheme.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            '#CLINIQ-ID-9823',
            style: AppTextStyles.getTextStyle(12).copyWith(
              fontWeight: FontWeight.w800,
              color: context.colorScheme.secondary,
              letterSpacing: 1,
            ),
          ),
        ),
        const VerticalGap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.alternate_email_rounded,
              size: 16,
              color: context.textPalette.secondaryColor,
            ),
            const HorizontalGap(8),
            Text(
              email,
              style: AppTextStyles.getTextStyle(14).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
