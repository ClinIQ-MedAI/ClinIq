import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
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
    final borderRadius = BorderRadius.circular(avatarSize / 4);

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: avatarSize,
        height: avatarSize,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(avatarSize, context),
        errorWidget: (context, url, error) =>
            _buildPlaceholder(avatarSize, context),
      ),
    );
  }

  Widget _buildPlaceholder(double avatarSize, BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final colorScheme = context.colorScheme;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
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
            fontSize: avatarSize * 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
