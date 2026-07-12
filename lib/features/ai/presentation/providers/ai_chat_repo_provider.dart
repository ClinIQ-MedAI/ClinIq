import 'package:cliniq/core/services/get_it_service.dart';
import 'package:cliniq/features/ai/domain/repos/ai_chat_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiChatRepoProvider = Provider<AiChatRepo>((ref) {
  return getIt<AiChatRepo>();
});
