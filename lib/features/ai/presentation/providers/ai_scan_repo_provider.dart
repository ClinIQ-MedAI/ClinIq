import 'package:cliniq/core/services/get_it_service.dart';
import 'package:cliniq/features/ai/domain/repos/ai_scan_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiScanRepoProvider = Provider<AiScanRepo>((ref) {
  return getIt<AiScanRepo>();
});
