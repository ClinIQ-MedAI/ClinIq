import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/providers/ai_scan_upload_provider.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_rejected_body.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_success_body.dart';
import 'package:cliniq/features/ai/presentation/widgets/prescription_analysis_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class AiScanUploadBody extends ConsumerWidget {
  const AiScanUploadBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiScanUploadProvider);

    return switch (state) {
      AiScanUploadInitial() => _buildInitial(context),
      AiScanUploadingImage() => _buildLoading(
          context,
          LocaleKeys.aiScanUploadingImage.tr(),
        ),
      AiScanFetchingAnalysis() => _buildLoading(
          context,
          LocaleKeys.aiScanFetchingAnalysis.tr(),
        ),
      AiScanUploadCompleted(analysis: final analysis) => switch (analysis) {
        AIAnalysisRejectedEntity rejected => AiAnalysisRejectedBody(
          analysis: rejected,
        ),
        AIAnalysisSuccessEntity success => AiAnalysisSuccessBody(
          analysis: success,
        ),
        PrescriptionAnalysisEntity prescription => PrescriptionAnalysisBody(
          analysis: prescription,
        ),
      },
      AiScanUploadError(message: final message) => _buildError(
          context,
          message,
          ref,
        ),
    };
  }

  Widget _buildInitial(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.aiScanSelectImage.tr(),
        style: AppTextStyles.getTextStyle(14),
      ),
    );
  }

  Widget _buildLoading(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: context.colorScheme.primary,
          ),
          const VerticalGap(16),
          Text(
            message,
            style: AppTextStyles.getTextStyle(14),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: context.colorScheme.error,
            ),
            const VerticalGap(16),
            Text(
              message,
              style: AppTextStyles.getTextStyle(14),
              textAlign: TextAlign.center,
            ),
            const VerticalGap(24),
            FilledButton.icon(
              onPressed: () {
                ref.read(aiScanUploadProvider.notifier).reset();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(LocaleKeys.aiScanRetry.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
