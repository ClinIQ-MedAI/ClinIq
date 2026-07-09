import 'package:cliniq/core/services/get_it_service.dart';
import 'package:cliniq/features/chat/domain/repos/attachment_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attachmentRepoProvider = Provider<AttachmentRepo>((ref) {
  return getIt<AttachmentRepo>();
});
