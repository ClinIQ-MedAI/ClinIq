bool isValidNetworkImage(String? url) {
  if (url == null || url.isEmpty) return false;
  if (url.startsWith('blob:')) return false;
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  if (!uri.hasScheme || !uri.hasAuthority) return false;
  return uri.scheme == 'http' || uri.scheme == 'https';
}

bool isBlobUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.startsWith('blob:');
}
