import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key, this.bottomSpacing = 16});

  final double bottomSpacing;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, widget.bottomSpacing.h),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Row(
          children: [
            _ChatIconButton(icon: Icons.add_rounded, onPressed: () {}),
            const HorizontalGap(10),
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                style: AppTextStyles.getTextStyle(14).copyWith(
                  color: context.textPalette.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: LocaleKeys.chatInputHint.tr(),
                  filled: true,
                  fillColor: context.inputTheme.backgroundColor,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 12.h,
                  ),
                  suffixIcon: Icon(
                    Icons.sentiment_satisfied_alt_rounded,
                    color: context.inputTheme.iconColor,
                    size: 20.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.r),
                    borderSide: BorderSide(
                      color: context.inputTheme.borderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.r),
                    borderSide: BorderSide(
                      color: context.inputTheme.borderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.r),
                    borderSide: BorderSide(
                      color: context.inputTheme.focusedBorderColor,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            const HorizontalGap(10),
            _ChatIconButton(icon: Icons.mic_none_rounded, onPressed: () {}),
            const HorizontalGap(8),
            _ChatIconButton(
              icon: Icons.send_rounded,
              isPrimary: true,
              onPressed: () {
                _controller.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatIconButton extends StatelessWidget {
  const _ChatIconButton({
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: isPrimary
              ? context.colorScheme.primary
              : context.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Icon(
          icon,
          color: isPrimary
              ? context.colorScheme.onPrimary
              : context.colorScheme.primary,
          size: 21.sp,
        ),
      ),
    );
  }
}
