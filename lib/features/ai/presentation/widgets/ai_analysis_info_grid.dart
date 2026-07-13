import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAnalysisInfoGrid extends StatelessWidget {
  const AiAnalysisInfoGrid({super.key, required this.items});

  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    final visibleItems = Map.fromEntries(
      items.entries.where((entry) => entry.value.isNotEmpty),
    );

    if (visibleItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 2.7,
      children: visibleItems.entries.map((entry) {
        return Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                entry.key,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.getTextStyle(11).copyWith(
                  color: context.textPalette.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                entry.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.getTextStyle(14).copyWith(
                  color: context.textPalette.primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
