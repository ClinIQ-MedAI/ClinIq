import 'package:cliniq/core/api/api_features.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/extensions/doctor_speciality_extension.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/booking/domain/entities/booking_entity.dart';
import 'package:cliniq/features/booking/presentation/providers/booking_providers.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:cliniq/features/booking/presentation/widgets/booking_success_dialog.dart';
import 'package:cliniq/features/booking/presentation/widgets/schedule_bottom_sheet.dart';
import 'package:cliniq/features/chat/presentation/arguments/chat_details_arguments.dart';
import 'package:cliniq/features/chat/presentation/providers/start_chat_provider.dart';
import 'package:cliniq/features/home/presentation/providers/bottom_nav_index_provider.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_avatar.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsScreen extends ConsumerStatefulWidget {
  const DoctorDetailsScreen({super.key, required this.doctorId});

  final String doctorId;

  @override
  ConsumerState<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends ConsumerState<DoctorDetailsScreen> {
  bool _isChatLoading = false;
  bool _isBookingLoading = false;

  @override
  Widget build(BuildContext context) {
    final doctorAsync = ref.watch(doctorDetailsProvider(widget.doctorId));

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: ProfileAppBar(
        title: LocaleKeys.homeDoctorDetailsTitle.tr(),
      ),
      body: doctorAsync.when(
        data: (doctor) => _buildContent(context, doctor),
        error: (error, _) => _buildError(context, error),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: context.textPalette.secondaryColor,
            ),
            const VerticalGap(16),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(14).copyWith(
                color: context.textPalette.secondaryColor,
              ),
            ),
            const VerticalGap(24),
            FilledButton.icon(
              onPressed: () => ref.invalidate(doctorDetailsProvider(widget.doctorId)),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(LocaleKeys.notificationsRetry.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DoctorEntity doctor) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildDoctorHeader(context, doctor),
          const VerticalGap(24),
          _buildAboutSection(context, doctor),
          if (ApiFeatures.booking) ...[
            const VerticalGap(20),
            _buildBookingCard(context, doctor),
          ],
          const VerticalGap(20),
          _buildInfoSection(context, doctor),
          const VerticalGap(20),
          if (doctor.education != null) ...[
            _buildEducationSection(context, doctor),
            const VerticalGap(20),
          ],
          const VerticalGap(32),
          _buildChatCta(context, ref, doctor),
          const VerticalGap(40),
        ],
      ),
    );
  }

  Widget _buildDoctorHeader(BuildContext context, DoctorEntity doctor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          DoctorAvatar(
            imageUrl: doctor.image,
            name: doctor.name,
            size: 120.r,
          ),
          const VerticalGap(20),
          Text(
            doctor.name,
            textAlign: TextAlign.center,
            style: AppTextStyles.getTextStyle(24).copyWith(
              fontWeight: FontWeight.w900,
              color: context.textPalette.primaryColor,
              letterSpacing: -0.5,
            ),
          ),
          const VerticalGap(8),
          Text(
            doctor.speciality.localizedSpeciality,
            textAlign: TextAlign.center,
            style: AppTextStyles.getTextStyle(16).copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const VerticalGap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              const HorizontalGap(6),
              Text(
                doctor.rating,
                style: AppTextStyles.getTextStyle(16).copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.textPalette.primaryColor,
                ),
              ),
              const HorizontalGap(24),
              Icon(
                Icons.work_history_rounded,
                color: context.colorScheme.primary,
                size: 20,
              ),
              const HorizontalGap(6),
              Text(
                '${doctor.experience} ${LocaleKeys.homeYearsExp.tr()}',
                style: AppTextStyles.getTextStyle(14).copyWith(
                  color: context.textPalette.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: AppTextStyles.getTextStyle(18).copyWith(
          fontWeight: FontWeight.w800,
          color: context.textPalette.primaryColor,
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, DoctorEntity doctor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, LocaleKeys.homeAbout.tr()),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: context.colorScheme.primary.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              doctor.bio ??
                  '${doctor.name} is a skilled ${doctor.speciality.localizedSpeciality} specialist with ${doctor.experience} of experience.',
              style: AppTextStyles.getTextStyle(14).copyWith(
                color: context.textPalette.secondaryColor,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }

  Widget _buildInfoSection(BuildContext context, DoctorEntity doctor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, LocaleKeys.homeDetails.tr()),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: context.colorScheme.primary.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _infoRow(
                  context,
                  Icons.location_on_rounded,
                  LocaleKeys.homeLocation.tr(),
                  doctor.city.isNotEmpty ? doctor.city : LocaleKeys.homeAvailable.tr(),
                ),
                const Divider(height: 24),
                _infoRow(
                  context,
                  Icons.monetization_on_rounded,
                  LocaleKeys.homeConsultationFee.tr(),
                  doctor.consultationFee ?? LocaleKeys.homeAvailable.tr(),
                ),
                if (doctor.languages != null) ...[
                  const Divider(height: 24),
                  _infoRow(
                    context,
                    Icons.language_rounded,
                    LocaleKeys.bookingLanguages.tr(),
                    doctor.languages!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.05);
  }

  Widget _buildEducationSection(BuildContext context, DoctorEntity doctor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, LocaleKeys.homeEducation.tr()),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: context.colorScheme.primary.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: context.colorScheme.primary,
                    size: 20.sp,
                  ),
                ),
                const HorizontalGap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.education ?? 'Faculty of Medicine',
                        style: AppTextStyles.getTextStyle(15).copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.textPalette.primaryColor,
                        ),
                      ),
                      const VerticalGap(4),
                      Text(
                        'Specialized in ${doctor.speciality.localizedSpeciality}',
                        style: AppTextStyles.getTextStyle(13).copyWith(
                          color: context.textPalette.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05);
  }

  Widget _buildBookingCard(BuildContext context, DoctorEntity doctor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, LocaleKeys.bookingBookAppointment.tr()),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary.withValues(alpha: 0.05),
                  context.colorScheme.primary.withValues(alpha: 0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(
                color: context.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: context.colorScheme.primary,
                    size: 28.sp,
                  ),
                ),
                const VerticalGap(16),
                Text(
                  LocaleKeys.bookingConsultDoctor.tr(),
                  style: AppTextStyles.getTextStyle(20).copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.textPalette.primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const VerticalGap(8),
                Text(
                  LocaleKeys.bookingConsultDoctorDesc.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.getTextStyle(14).copyWith(
                    color: context.textPalette.secondaryColor,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                const VerticalGap(24),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap:
                          _isBookingLoading ? null : () => _showScheduleSheet(context, doctor),
                      borderRadius: BorderRadius.circular(20.r),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: _isBookingLoading
                              ? null
                              : LinearGradient(
                                  colors: [
                                    context.colorScheme.primary,
                                    context.colorScheme.primaryContainer,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          color: _isBookingLoading
                              ? context.colorScheme.primary.withValues(alpha: 0.5)
                              : null,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: _isBookingLoading
                              ? null
                              : [
                                  BoxShadow(
                                    color: context.colorScheme.primary.withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isBookingLoading)
                              SizedBox(
                                width: 20.sp,
                                height: 20.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: context.colorScheme.onPrimary,
                                ),
                              )
                            else
                              Icon(
                                Icons.calendar_today_rounded,
                                color: context.colorScheme.onPrimary,
                                size: 20.sp,
                              ),
                            const HorizontalGap(10),
                            Text(
                              _isBookingLoading
                                  ? ''
                                  : LocaleKeys.bookingBookAppointment.tr(),
                              style: AppTextStyles.getTextStyle(16).copyWith(
                                color: context.colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 175.ms).slideY(begin: 0.05);
  }

  Future<void> _showScheduleSheet(BuildContext context, DoctorEntity doctor) async {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    try {
      final repo = ref.read(bookingRepoProvider);
      final schedulesResult = await repo.getDoctorSchedules(widget.doctorId, dateStr);
      final schedules = schedulesResult.fold(
        (failure) => throw failure.message,
        (data) => data,
      );

      if (!mounted) return;

      final result = await showModalBottomSheet<ScheduleSlotEntity>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ScheduleBottomSheet(
          schedules: schedules.availableSlots,
          weeklySchedule: schedules.weeklySchedule,
          onBook: (slot) => Navigator.of(context).pop(slot),
        ),
      );

      if (result == null || !mounted) return;

      await _createBooking(doctor, dateStr, result.time);
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(context, e.toString());
    }
  }

  Future<void> _createBooking(DoctorEntity doctor, String date, String time) async {
    setState(() => _isBookingLoading = true);

    try {
      final repo = ref.read(bookingRepoProvider);
      final bookingResult = await repo.createBooking(
        doctorId: widget.doctorId,
        date: date,
        time: time,
      );
      bookingResult.fold(
        (failure) => throw failure.message,
        (_) {},
      );

      if (!mounted) return;

      await BookingSuccessDialog.show(
        context,
        doctorName: doctor.name,
        bookingNumber: null,
      );
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(context, e.toString());
    } finally {
      if (mounted) setState(() => _isBookingLoading = false);
    }
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            icon,
            color: context.colorScheme.primary,
            size: 20.sp,
          ),
        ),
        const HorizontalGap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.getTextStyle(12).copyWith(
                  color: context.textPalette.secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const VerticalGap(2),
              Text(
                value,
                style: AppTextStyles.getTextStyle(15).copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.textPalette.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatCta(BuildContext context, WidgetRef ref, DoctorEntity doctor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colorScheme.primary.withValues(alpha: 0.05),
              context.colorScheme.primary.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: context.colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: context.colorScheme.primary,
                size: 28.sp,
              ),
            ),
            const VerticalGap(16),
            Text(
              LocaleKeys.homeStartChat.tr(),
              style: AppTextStyles.getTextStyle(20).copyWith(
                fontWeight: FontWeight.w900,
                color: context.textPalette.primaryColor,
                letterSpacing: -0.5,
              ),
            ),
            const VerticalGap(8),
            Text(
              LocaleKeys.homeChatWithDoctorDesc.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.getTextStyle(14).copyWith(
                color: context.textPalette.secondaryColor,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const VerticalGap(24),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isChatLoading ? null : () => _startChat(context, ref, doctor),
                  borderRadius: BorderRadius.circular(20.r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      gradient: _isChatLoading
                          ? null
                          : LinearGradient(
                              colors: [
                                context.colorScheme.primary,
                                context.colorScheme.primaryContainer,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      color: _isChatLoading
                          ? context.colorScheme.primary.withValues(alpha: 0.5)
                          : null,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: _isChatLoading
                          ? null
                          : [
                              BoxShadow(
                                color: context.colorScheme.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isChatLoading)
                          SizedBox(
                            width: 20.sp,
                            height: 20.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: context.colorScheme.onPrimary,
                            ),
                          )
                        else
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: context.colorScheme.onPrimary,
                            size: 20.sp,
                          ),
                        const HorizontalGap(10),
                        Text(
                          _isChatLoading ? '' : LocaleKeys.homeStartChat.tr(),
                          style: AppTextStyles.getTextStyle(16).copyWith(
                            color: context.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Future<void> _startChat(BuildContext context, WidgetRef ref, DoctorEntity doctor) async {
    if (_isChatLoading) return;
    setState(() => _isChatLoading = true);

    final useCase = ref.read(startChatUseCaseProvider);

    try {
      final conversation = await useCase(
        doctorId: doctor.id,
        doctorName: doctor.name,
      );

      if (!mounted) return;

      ref.read(bottomNavIndexProvider.notifier).setIndex(2);

      Navigator.pushNamed(
        context,
        Routes.chatDetailsScreen,
        arguments: ChatDetailsArguments(
          conversationId: conversation.id,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(context, e.toString());
    } finally {
      if (mounted) setState(() => _isChatLoading = false);
    }
  }
}
