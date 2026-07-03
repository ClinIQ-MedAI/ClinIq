import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/custom_person_icon.dart';
import 'package:cliniq/features/home/presentation/providers/bottom_nav_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileImage extends ConsumerWidget {
  const UserProfileImage({
    super.key,
    this.circleAvatarRadius = 30,
    this.profilePicUrl,
    this.isEnabled = true,
    this.isCurrentUser = false,
    this.borderColor,
    this.borderWidth = 3,
    this.addBoxShadow = false,
  });

  final double circleAvatarRadius;
  final String? profilePicUrl;
  final bool isEnabled;
  final bool isCurrentUser;
  final Color? borderColor;
  final double borderWidth;
  final bool addBoxShadow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: !isEnabled
          ? null
          : () {
              ref.read(bottomNavIndexProvider.notifier).setIndex(3);
            },
      child: Container(
        width: (circleAvatarRadius + borderWidth) * 2,
        height: (circleAvatarRadius + borderWidth) * 2,
        padding: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? context.theme.primaryColor,
            width: borderWidth,
          ),
          boxShadow: addBoxShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: CircleAvatar(
          radius: circleAvatarRadius,
          backgroundColor: context.colorScheme.onPrimary,
          child: ClipOval(
            child: profilePicUrl != null
                ? CachedNetworkImage(
                    imageUrl: profilePicUrl!,
                    fit: BoxFit.cover,
                    width: circleAvatarRadius * 2,
                    height: circleAvatarRadius * 2,
                    errorWidget: (context, error, stackTrace) {
                      return CustomPersonIcon(
                        circleAvatarRadius: circleAvatarRadius,
                      );
                    },
                  )
                : CustomPersonIcon(circleAvatarRadius: circleAvatarRadius),
          ),
        ),
      ),
    );
  }
}
