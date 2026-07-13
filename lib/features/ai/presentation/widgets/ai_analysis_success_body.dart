import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_annotated_image_section.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_info_grid.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_recommendations_section.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_status_header.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_text_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAnalysisSuccessBody extends StatelessWidget {
  const AiAnalysisSuccessBody({super.key, required this.analysis});

  final AIAnalysisSuccessEntity analysis;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      children: [
        AiAnalysisStatusHeader(
          title: LocaleKeys.aiScanResultPassed.tr(),
          icon: Icons.check_circle_rounded,
          color: context.colorScheme.primary,
        ),
        const VerticalGap(12),
        AiAnalysisAnnotatedImageSection(
          annotatedImageBase64: analysis.annotatedImageBase64,
        ),
        const VerticalGap(12),
        AiAnalysisInfoGrid(
          items: {
            LocaleKeys.aiScanRejectedUrgency.tr(): analysis.urgency,
            LocaleKeys.aiScanResultDiagnosis.tr(): analysis.primaryDiagnosis,
            LocaleKeys.aiScanResultConfidence.tr(): analysis.confidence,
          },
        ),
        const VerticalGap(12),
        AiAnalysisTextSection(
          title: LocaleKeys.aiScanResultSummary.tr(),
          value: analysis.summary,
          icon: Icons.summarize_rounded,
        ),
        const VerticalGap(12),
        AiAnalysisRecommendationsSection(
          title: LocaleKeys.aiScanResultRecommendations.tr(),
          recommendations: analysis.recommendations,
        ),
      ],
    );
  }
}
