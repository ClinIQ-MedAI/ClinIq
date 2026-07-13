import 'dart:convert';

import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/chat_message_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RejectedAnalysisMessage extends StatelessWidget {
  const RejectedAnalysisMessage({
    super.key,
    required this.message,
    this.onUploadAnother,
  });

  final ChatMessageEntity message;
  final VoidCallback? onUploadAnother;

  Map<String, dynamic>? get _data {
    try {
      final decoded = jsonDecode(message.content);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  String? get _urgency => _data?['urgency'] as String?;

  String? get _summary => _data?['summary'] as String?;

  List<String> get _recommendations {
    final list = _data?['recommendations'] as List?;
    return list?.map((e) => e.toString()).toList() ?? [];
  }

  Map<String, dynamic>? get _inputGate =>
      _data?['input_gate'] as Map<String, dynamic>?;

  String? get _inputGateReason => _inputGate?['reason'] as String?;

  Map<String, dynamic>? get _scores =>
      _inputGate?['scores'] as Map<String, dynamic>?;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: _bgColor(scheme),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _borderColor(scheme),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _borderColor(scheme).withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _headerRow(scheme),
          const VerticalGap(14),
          if (_urgency != null && _urgency!.isNotEmpty) ...[
            _urgencyBadge(scheme),
            const VerticalGap(14),
          ],
          if (_summary != null && _summary!.isNotEmpty) ...[
            _summaryCard(scheme),
            const VerticalGap(14),
          ],
          if (_inputGateReason != null && _inputGateReason!.isNotEmpty) ...[
            _detectionReasonCard(scheme),
            const VerticalGap(14),
          ],
          if (_recommendations.isNotEmpty) ...[
            _recommendationsSection(scheme),
            const VerticalGap(16),
          ],
          if (_scores != null && _scores!.isNotEmpty) ...[
            _metricsCard(scheme),
            const VerticalGap(16),
          ],
          if (onUploadAnother != null) _uploadButton(context, scheme),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.06, duration: 300.ms);
  }

  Widget _headerRow(ColorScheme scheme) {
    return Row(
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: _accentColor(scheme).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.warning_amber_rounded,
            size: 20.sp,
            color: _accentColor(scheme),
          ),
        ),
        const HorizontalGap(10),
        Expanded(
          child: Text(
            LocaleKeys.aiScanRejectedTitle.tr(),
            style: AppTextStyles.getTextStyle(15).copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _urgencyBadge(ColorScheme scheme) {
    final red = const Color(0xFFE53935);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: red.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: red.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 14.sp,
                color: red,
              ),
              const HorizontalGap(4),
              Text(
                _urgency!.toUpperCase(),
                style: AppTextStyles.getTextStyle(11).copyWith(
                  color: red,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: _accentColor(scheme).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: _accentColor(scheme).withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.aiScanRejectedReason.tr(),
            style: AppTextStyles.getTextStyle(10).copyWith(
              color: scheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const VerticalGap(6),
          Text(
            _summary!,
            style: AppTextStyles.getTextStyle(12).copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detectionReasonCard(ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: scheme.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16.sp,
                color: scheme.error,
              ),
              const HorizontalGap(6),
              Text(
                LocaleKeys.aiScanRejectedDetectionReason.tr(),
                style: AppTextStyles.getTextStyle(10).copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const VerticalGap(6),
          Text(
            _inputGateReason!,
            style: AppTextStyles.getTextStyle(12).copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendationsSection(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.aiScanRejectedSuggestions.tr(),
          style: AppTextStyles.getTextStyle(10).copyWith(
            color: scheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const VerticalGap(8),
        ..._recommendations.map(
          (rec) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 18.sp,
                  color: const Color(0xFF4CAF50),
                ),
                const HorizontalGap(8),
                Expanded(
                  child: Text(
                    rec,
                    style: AppTextStyles.getTextStyle(12).copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _metricsCard(ColorScheme scheme) {
    final labels = <String, String>{
      LocaleKeys.aiScanResultWidth.tr(): '${_formatNum(_scores?['width'])} px',
      LocaleKeys.aiScanResultHeight.tr(): '${_formatNum(_scores?['height'])} px',
      LocaleKeys.aiScanResultAspectRatio.tr(): '${_formatDec(_scores?['aspect_ratio'])}',
      LocaleKeys.aiScanResultIntensityStd.tr(): '${_formatDec(_scores?['intensity_std'])}',
      LocaleKeys.aiScanResultColorSpread.tr(): '${_formatDec(_scores?['color_spread'])}',
      LocaleKeys.aiScanResultColorfulFraction.tr(): '${_formatDec(_scores?['colorful_fraction'])}',
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.aiScanResultMetrics.tr(),
            style: AppTextStyles.getTextStyle(10).copyWith(
              color: scheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const VerticalGap(10),
          ...labels.entries.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: _metricRow(scheme, e.key, e.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricRow(ColorScheme scheme, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: AppTextStyles.getTextStyle(11).copyWith(
            color: scheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 3.h),
            child: Text(
              ' ' + '.' * (_maxDotCount - label.length).clamp(1, 30),
              style: AppTextStyles.getTextStyle(11).copyWith(
                color: scheme.onSurface.withValues(alpha: 0.2),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.getTextStyle(11).copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  int get _maxDotCount => 26;

  String _formatNum(dynamic v) {
    if (v == null) return '-';
    if (v is num) return v.toDouble() == v.roundToDouble()
        ? '${v.round()}'
        : v.toStringAsFixed(1);
    return v.toString();
  }

  String _formatDec(dynamic v) {
    if (v == null) return '-';
    if (v is num) return v.toStringAsFixed(2);
    return v.toString();
  }

  Widget _uploadButton(BuildContext context, ColorScheme scheme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onUploadAnother,
        icon: Icon(
          Icons.add_photo_alternate_outlined,
          size: 16.sp,
        ),
        label: Text(
          LocaleKeys.aiScanRejectedUploadAnother.tr(),
          style: AppTextStyles.getTextStyle(13).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: _accentColor(scheme),
          side: BorderSide(
            color: _accentColor(scheme).withValues(alpha: 0.4),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Color _accentColor(ColorScheme scheme) =>
      const Color(0xFFE6A817);

  Color _bgColor(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark
          ? const Color(0xFF2A2410)
          : const Color(0xFFFFF8E1);

  Color _borderColor(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark
          ? const Color(0xFF4A3E1A)
          : const Color(0xFFF0D78C);
}
