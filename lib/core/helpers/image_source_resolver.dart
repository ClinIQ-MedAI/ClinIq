import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageSourceType { file, blob, network }

ImageSourceType resolveImageSourceType(String url) {
  if (url.startsWith('blob:')) return ImageSourceType.blob;
  if (url.startsWith('http')) return ImageSourceType.network;
  return ImageSourceType.file;
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
    case ImageSourceType.blob:
      return Image.network(
        url,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholderBuilder(context, url);
        },
        errorBuilder: (context, error, stackTrace) =>
            errorBuilder(context, url, error),
      );

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
  }
}
