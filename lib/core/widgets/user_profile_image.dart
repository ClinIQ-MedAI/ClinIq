import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/utils/image_validation_helper.dart';
import 'package:cliniq/core/widgets/custom_person_icon.dart';
import 'package:cliniq/features/home/presentation/providers/bottom_nav_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileImage extends ConsumerWidget {
  const UserProfileImage({
    super.key,
    this.circleAvatarRadius = 30,
    this.profilePicUrl,
    this.name,
    this.isEnabled = true,
    this.isCurrentUser = false,
    this.borderColor,
    this.borderWidth = 3,
    this.addBoxShadow = false,
  });

  final double circleAvatarRadius;
  final String? profilePicUrl;
  final String? name;
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
            child: profilePicUrl != null && isValidNetworkImage(profilePicUrl)
                ? CachedNetworkImage(
                    imageUrl: profilePicUrl!,
                    fit: BoxFit.cover,
                    width: circleAvatarRadius * 2,
                    height: circleAvatarRadius * 2,
                    errorWidget: (context, error, stackTrace) {
                      return _buildFallback(context);
                    },
                  )
                : _buildFallback(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    if (name != null && name!.isNotEmpty) {
      final initial = name![0].toUpperCase();
      final colorScheme = context.colorScheme;
      return Container(
        width: circleAvatarRadius * 2,
        height: circleAvatarRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withValues(alpha: 0.7),
              colorScheme.primaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            initial,
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: circleAvatarRadius,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
    return CustomPersonIcon(circleAvatarRadius: circleAvatarRadius);
  }
}
