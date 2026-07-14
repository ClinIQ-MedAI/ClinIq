import 'dart:convert';
import 'dart:typed_data';

import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Safely renders a scan image that may arrive as base64, a data URI, or a
/// network URL — in any of the `base64` / `url` fields. Never throws during
/// build (a bad base64 string can crash `Image.memory`), and supports
/// tap-to-zoom fullscreen.
class ScanImageView extends StatelessWidget {
  const ScanImageView({
    super.key,
    this.base64 = '',
    this.url = '',
    this.maxHeight = 300,
    this.enableFullScreen = true,
  });

  final String base64;
  final String url;
  final double maxHeight;
  final bool enableFullScreen;

  @override
  Widget build(BuildContext context) {
    final provider = _resolveProvider();
    if (provider == null) {
      return _placeholder(context);
    }

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: maxHeight.h),
        color: context.colorScheme.surfaceContainerHighest,
        child: Image(
          image: provider,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _placeholder(context),
        ),
      ),
    );

    if (!enableFullScreen) return image;

    return InkWell(
      onTap: () => _showFullScreen(context, provider),
      borderRadius: BorderRadius.circular(12.r),
      child: image,
    );
  }

  ImageProvider? _resolveProvider() {
    // Prefer a decodable base64 payload, then fall back to any usable URL.
    final bytes = _tryDecodeBase64(base64);
    if (bytes != null) return MemoryImage(bytes);

    final directUrl = _asNetworkUrl(base64) ?? _asNetworkUrl(url);
    if (directUrl != null) return NetworkImage(directUrl);

    return null;
  }

  /// Returns decoded bytes for a base64 (optionally a `data:` URI) string, or
  /// null when the value is empty / not valid base64.
  static Uint8List? _tryDecodeBase64(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (_looksLikeUrl(trimmed)) return null;
    final payload = trimmed.contains(',') ? trimmed.split(',').last : trimmed;
    try {
      return base64Decode(payload);
    } catch (_) {
      return null;
    }
  }

  static String? _asNetworkUrl(String value) {
    final trimmed = value.trim();
    return _looksLikeUrl(trimmed) ? trimmed : null;
  }

  static bool _looksLikeUrl(String value) =>
      value.startsWith('http://') || value.startsWith('https://');

  Widget _placeholder(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160.h,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          size: 40.sp,
          color: context.textPalette.secondaryColor,
        ),
      ),
    );
  }

  void _showFullScreen(BuildContext context, ImageProvider provider) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image(image: provider, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
