import 'dart:developer';

import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_rejected_body.dart';
import 'package:cliniq/features/ai/presentation/widgets/ai_analysis_success_body.dart';
import 'package:cliniq/features/ai/presentation/widgets/prescription_analysis_body.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AiAnalysisResultScreen extends StatelessWidget {
  const AiAnalysisResultScreen({super.key, required this.analysis});

  final ScanAnalysisEntity analysis;

  @override
  Widget build(BuildContext context) {
    // TEMPORARY: verify which body the screen renders for the entity type.
    log(
      '[AiAnalysisResultScreen] entity=${analysis.runtimeType} -> '
      '${switch (analysis) {
        AIAnalysisRejectedEntity() => 'AiAnalysisRejectedBody',
        AIAnalysisSuccessEntity() => 'AiAnalysisSuccessBody',
        PrescriptionAnalysisEntity() => 'PrescriptionAnalysisBody',
      }}',
    );
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(LocaleKeys.aiScanAnalysisTitle.tr()),
        centerTitle: true,
      ),
      body: switch (analysis) {
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
    );
  }
}
