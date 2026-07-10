import 'package:cliniq/features/chat/domain/use_cases/start_chat_use_case.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final startChatUseCaseProvider = Provider<StartChatUseCase>((ref) {
  return StartChatUseCase(repo: ref.read(chatRepoProvider));
});
