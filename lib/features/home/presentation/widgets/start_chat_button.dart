import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
import 'package:cliniq/core/utils/app_routes.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/features/chat/presentation/arguments/chat_details_arguments.dart';
import 'package:cliniq/features/chat/presentation/providers/start_chat_provider.dart';
import 'package:cliniq/features/home/presentation/providers/bottom_nav_index_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartChatButton extends ConsumerStatefulWidget {
  const StartChatButton({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  final String doctorId;
  final String doctorName;

  @override
  ConsumerState<StartChatButton> createState() => _StartChatButtonState();
}

class _StartChatButtonState extends ConsumerState<StartChatButton> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final useCase = ref.read(startChatUseCaseProvider);
      final conversation = await useCase(
        doctorId: widget.doctorId,
        doctorName: widget.doctorName,
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return FilledButton.icon(
      onPressed: _isLoading ? null : _handleTap,
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      icon: _isLoading
          ? SizedBox(
              width: 18.w,
              height: 18.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: scheme.onPrimary,
              ),
            )
          : const Icon(Icons.chat_bubble_outline, size: 18),
      label: Text(
        _isLoading ? '' : LocaleKeys.homeStartChat.tr(),
        style: AppTextStyles.getTextStyle(13).copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
