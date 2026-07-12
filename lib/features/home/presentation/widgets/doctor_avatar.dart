import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/utils/image_validation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorAvatar extends StatelessWidget {
  const DoctorAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    this.size = 90,
  });

  final String imageUrl;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final avatarSize = size.w;

    if (!isValidNetworkImage(imageUrl)) {
      return _buildInitialsCircle(avatarSize, context);
    }

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              _buildInitialsCircle(avatarSize, context),
          errorWidget: (context, url, error) =>
              _buildInitialsCircle(avatarSize, context),
        ),
      ),
    );
  }

  Widget _buildInitialsCircle(double avatarSize, BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final colorScheme = context.colorScheme;

    return Container(
      width: avatarSize,
      height: avatarSize,
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
        border: Border.all(
          color: colorScheme.onPrimary.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            initial,
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: avatarSize * 0.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          Positioned(
            right: avatarSize * 0.02,
            bottom: avatarSize * 0.02,
            child: Icon(
              Icons.medical_services_rounded,
              size: avatarSize * 0.2,
              color: colorScheme.onPrimary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
