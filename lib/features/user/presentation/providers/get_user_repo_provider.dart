import 'package:cliniq/core/services/get_it_service.dart';
import 'package:cliniq/features/user/domain/repos/user_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserRepoProvider = Provider<UserRepo>((ref) {
  return getIt<UserRepo>();
});
