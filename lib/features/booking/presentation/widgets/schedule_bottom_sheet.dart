import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/booking/domain/entities/booking_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({
    super.key,
    required this.schedules,
    required this.weeklySchedule,
    required this.onBook,
  });

  final List<ScheduleSlotEntity> schedules;
  final List<WeeklyDayRangeEntity> weeklySchedule;
  final void Function(ScheduleSlotEntity slot) onBook;

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  String? _selectedSlotId;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final textColor = context.textPalette;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: color.outline.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          const VerticalGap(20),
          Text(
            LocaleKeys.bookingSelectTime.tr(),
            style: AppTextStyles.getTextStyle(20).copyWith(
              fontWeight: FontWeight.w800,
              color: textColor.primaryColor,
            ),
          ),
          const VerticalGap(8),
          Text(
            LocaleKeys.bookingAvailableSlots.tr(),
            style: AppTextStyles.getTextStyle(14).copyWith(
              color: textColor.secondaryColor,
            ),
          ),
          const VerticalGap(16),
          if (widget.weeklySchedule.isNotEmpty) ...[
            _buildSectionLabel(context, LocaleKeys.bookingWorkingHours.tr()),
            const VerticalGap(8),
            _buildWeeklySchedule(context),
            const VerticalGap(16),
          ],
          _buildSectionLabel(context, LocaleKeys.bookingAvailableTimes.tr()),
          const VerticalGap(12),
          if (widget.schedules.isEmpty)
            _buildEmptySlots(context)
          else
            ...widget.schedules.map((slot) => _buildSlotCard(context, slot)),
          const VerticalGap(24),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: FilledButton(
              onPressed:
                  _selectedSlotId != null
                      ? () {
                          final slot = widget.schedules.firstWhere(
                            (s) => s.id == _selectedSlotId,
                          );
                          widget.onBook(slot);
                        }
                      : null,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                LocaleKeys.bookingConfirmBooking.tr(),
                style: AppTextStyles.getTextStyle(16).copyWith(
                  fontWeight: FontWeight.w700,
                  color: color.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: AppTextStyles.getTextStyle(13).copyWith(
        fontWeight: FontWeight.w700,
        color: context.textPalette.secondaryColor,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildWeeklySchedule(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: widget.weeklySchedule.map((day) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: day == widget.weeklySchedule.last ? 0 : 8.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day.day,
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.textPalette.primaryColor,
                  ),
                ),
                Text(
                  day.range,
                  style: AppTextStyles.getTextStyle(13).copyWith(
                    color: context.textPalette.secondaryColor,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSlotCard(BuildContext context, ScheduleSlotEntity slot) {
    final isSelected = slot.id == _selectedSlotId;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: slot.isBooked ? null : () => setState(() => _selectedSlotId = slot.id),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primary.withValues(alpha: 0.08)
                : context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.outline.withValues(alpha: 0.12),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colorScheme.primary.withValues(alpha: 0.12)
                      : context.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.textPalette.secondaryColor,
                  size: 20.sp,
                ),
              ),
              const HorizontalGap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slot.time,
                      style: AppTextStyles.getTextStyle(16).copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.textPalette.primaryColor,
                      ),
                    ),
                    Text(
                      slot.period,
                      style: AppTextStyles.getTextStyle(12).copyWith(
                        color: context.textPalette.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (slot.isBooked)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: context.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    LocaleKeys.bookingBooked.tr(),
                    style: AppTextStyles.getTextStyle(12).copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.error,
                    ),
                  ),
                )
              else if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: context.colorScheme.primary,
                  size: 24.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlots(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 40.sp,
            color: context.textPalette.secondaryColor,
          ),
          const VerticalGap(12),
          Text(
            LocaleKeys.bookingNoSlotsAvailable.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.getTextStyle(14).copyWith(
              color: context.textPalette.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
