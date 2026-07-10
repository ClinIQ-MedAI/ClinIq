import 'package:cliniq/core/services/get_it_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/repos/socket_repo/socket_repo.dart';

final socketRepoProvider = Provider<SocketRepo>((ref) {
  return getIt<SocketRepo>();
});