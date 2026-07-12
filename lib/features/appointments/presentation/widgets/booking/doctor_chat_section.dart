import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/presentation/arguments/chat_details_arguments.dart';
import 'package:cliniq/features/chat/presentation/providers/start_chat_provider.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorChatSection extends ConsumerStatefulWidget {
  const DoctorChatSection({super.key, required this.doctor});

  final DoctorEntity doctor;

  @override
  ConsumerState<DoctorChatSection> createState() => _DoctorChatSectionState();
}

class _DoctorChatSectionState extends ConsumerState<DoctorChatSection> {
  bool _isLoading = false;

  Future<void> _startChat() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final useCase = ref.read(startChatUseCaseProvider);
      final conversation = await useCase(
        doctorId: widget.doctor.id,
        doctorName: widget.doctor.name,
      );

      if (!mounted) return;

      await Navigator.pushNamed(
        context,
        Routes.chatDetailsScreen,
        arguments: ChatDetailsArguments(conversationId: conversation.id),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.12),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChatSectionHeader(),
          const VerticalGap(16),
          Text(
            LocaleKeys.bookingChatWithDoctorSubtitle.tr(),
            style: AppTextStyles.getTextStyle(13).copyWith(
              color: context.textPalette.secondaryColor,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const VerticalGap(20),
          _StartChatButton(isLoading: _isLoading, onPressed: _startChat),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 650.ms)
        .slideY(begin: 0.08, curve: Curves.easeOut);
  }
}

class _ChatSectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            Icons.chat_bubble_rounded,
            color: context.colorScheme.primary,
            size: 22.sp,
          ),
        ),
        const HorizontalGap(14),
        Expanded(
          child: Text(
            LocaleKeys.bookingChatWithDoctorTitle.tr(),
            style: AppTextStyles.getTextStyle(15).copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPalette.primaryColor,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _StartChatButton extends StatelessWidget {
  const _StartChatButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
          disabledBackgroundColor:
              context.colorScheme.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 4,
          shadowColor: context.colorScheme.primary.withValues(alpha: 0.3),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: context.colorScheme.onPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_rounded, size: 18.sp),
                  const HorizontalGap(8),
                  Text(
                    LocaleKeys.bookingStartChatButton.tr(),
                    style: AppTextStyles.getTextStyle(15).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const HorizontalGap(6),
                  Icon(Icons.arrow_forward_ios_rounded, size: 14.sp),
                ],
              ),
      ),
    );
  }
}
