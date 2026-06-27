import 'package:cliniq/core/services/get_it_service.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepoProvider = Provider<ChatRepo>((ref) {
  return getIt<ChatRepo>();
});
