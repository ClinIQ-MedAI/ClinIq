import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliniq/core/utils/image_validation_helper.dart';
import 'package:flutter/material.dart';

enum ImageSourceType { file, blob, network, invalid }

ImageSourceType resolveImageSourceType(String url) {
  if (!isValidNetworkImage(url)) return ImageSourceType.invalid;
  return ImageSourceType.network;
}

Widget buildImageWidget({
  required String url,
  String? localFilePath,
  required BoxFit fit,
  required Widget Function(BuildContext context, String url) placeholderBuilder,
  required Widget Function(BuildContext context, String url, dynamic error) errorBuilder,
  double? width,
  double? height,
}) {
  if (localFilePath != null) {
    return Image.file(
      File(localFilePath),
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) =>
          errorBuilder(context, localFilePath, error),
    );
  }

  final type = resolveImageSourceType(url);

  switch (type) {
    case ImageSourceType.network:
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => placeholderBuilder(context, url),
        errorWidget: (context, url, error) => errorBuilder(context, url, error),
      );

    case ImageSourceType.file:
      return Image.file(
        File(url),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) =>
            errorBuilder(context, url, error),
      );

    case ImageSourceType.blob:
    case ImageSourceType.invalid:
      return const SizedBox.shrink();
  }
}
