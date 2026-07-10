import 'package:cliniq/core/providers/socket_repo_provider.dart';
import 'package:cliniq/core/services/socket_lifecycle_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final socketLifecycleProvider =
    Provider<SocketLifecycleService>((ref) {
  return SocketLifecycleService(
    ref.read(socketRepoProvider),
  );
});