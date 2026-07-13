import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAnalysisRecommendationsSection extends StatelessWidget {
  const AiAnalysisRecommendationsSection({
    super.key,
    required this.title,
    required this.recommendations,
  });

  final String title;
  final List<String> recommendations;

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.getTextStyle(14).copyWith(
              color: context.textPalette.primaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const VerticalGap(12),
          ...recommendations.map(
            (recommendation) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: context.colorScheme.primary,
                    size: 18.sp,
                  ),
                  const HorizontalGap(8),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: AppTextStyles.getTextStyle(13).copyWith(
                        color: context.textPalette.secondaryColor,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
