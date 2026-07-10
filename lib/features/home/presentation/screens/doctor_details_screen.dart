import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/extensions/doctor_speciality_extension.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/presentation/arguments/chat_details_arguments.dart';
import 'package:cliniq/features/chat/presentation/providers/chat_repo_provider.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:cliniq/features/home/presentation/widgets/doctor_avatar.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsScreen extends ConsumerWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final DoctorEntity doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: ProfileAppBar(
        title: LocaleKeys.homeDoctorDetailsTitle.tr(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildDoctorHeader(context),
            const VerticalGap(24),
            _buildAboutSection(context),
            const VerticalGap(20),
            _buildInfoSection(context),
            const VerticalGap(20),
            _buildEducationSection(context),
            const VerticalGap(20),
            _buildWorkingHoursSection(context),
            const VerticalGap(32),
            _buildChatCta(context, ref),
            const VerticalGap(40),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorHeader(BuildContext context) {
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final avatarSize = constraints.maxWidth < 360 ? 90.0 : 120.0;

          return Column(
            children: [
              DoctorAvatar(
                imageUrl: doctor.image,
                name: doctor.name,
                size: avatarSize,
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
          );
        },
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

  Widget _buildAboutSection(BuildContext context) {
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
              '${doctor.name} is a highly skilled ${doctor.speciality.localizedSpeciality} specialist with ${doctor.experience} years of experience. Committed to providing comprehensive and compassionate care.',
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

  Widget _buildInfoSection(BuildContext context) {
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
                  LocaleKeys.homeAvailable.tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.05);
  }

  Widget _buildEducationSection(BuildContext context) {
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
                        'Faculty of Medicine',
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

  Widget _buildWorkingHoursSection(BuildContext context) {
    final weekDays = [
      ('Mon', '9:00 AM - 5:00 PM'),
      ('Tue', '9:00 AM - 5:00 PM'),
      ('Wed', '9:00 AM - 5:00 PM'),
      ('Thu', '9:00 AM - 5:00 PM'),
      ('Fri', '10:00 AM - 3:00 PM'),
      ('Sat', '10:00 AM - 2:00 PM'),
      ('Sun', 'Closed'),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, LocaleKeys.homeWorkingHours.tr()),
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
              children: weekDays.map((day) {
                final isClosed = day.$2 == 'Closed';
                return Padding(
                  padding: EdgeInsets.only(bottom: day == weekDays.last ? 0 : 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        day.$1,
                        style: AppTextStyles.getTextStyle(14).copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.textPalette.primaryColor,
                        ),
                      ),
                      Text(
                        day.$2,
                        style: AppTextStyles.getTextStyle(14).copyWith(
                          fontWeight: FontWeight.w600,
                          color: isClosed
                              ? context.colorScheme.error
                              : context.textPalette.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.05);
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

  Widget _buildChatCta(BuildContext context, WidgetRef ref) {
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
                  onTap: () => _startChat(context, ref),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.colorScheme.primary,
                          context.colorScheme.primaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
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
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: context.colorScheme.onPrimary,
                          size: 20.sp,
                        ),
                        const HorizontalGap(10),
                        Text(
                          LocaleKeys.homeStartChat.tr(),
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

  Future<void> _startChat(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(chatRepoProvider);

    try {
      final conversation = await repo.createConversation(doctorId: doctor.id);

      if (!context.mounted) return;

      Navigator.pushNamed(
        context,
        Routes.chatDetailsScreen,
        arguments: ChatDetailsArguments(
          conversationId: conversation.id,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.messagesFailuresUnexpectedError.tr())),
      );
    }
  }
}
