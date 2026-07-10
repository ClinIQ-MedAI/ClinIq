import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/horizontal_gap.dart';
import 'package:cliniq/features/chat/presentation/widgets/chat_icon_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    super.key,
    required this.onMessageSubmitted,
    required this.onTypingChanged,
    this.onAttachmentTap,
    this.hasAttachment = false,
    this.isSendDisabled = false,
    this.bottomSpacing = 16,
  });

  final ValueChanged<String> onMessageSubmitted;
  final ValueChanged<bool> onTypingChanged;
  final VoidCallback? onAttachmentTap;
  final bool hasAttachment;
  final bool isSendDisabled;
  final double bottomSpacing;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_isTyping) {
      widget.onTypingChanged(false);
    }
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleTextChanged(String value) {
    final isTyping = value.trim().isNotEmpty;
    if (_isTyping != isTyping) {
      _isTyping = isTyping;
      widget.onTypingChanged(isTyping);
    }
  }

  bool get _canSend => _hasText || widget.hasAttachment;

  void _submitMessage() {
    if (widget.isSendDisabled) return;
    final text = _controller.text.trim();
    if (!_canSend) return;

    widget.onMessageSubmitted(text);
    _controller.clear();
    _hasText = false;
    _handleTextChanged('');
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
            ChatIconButton(
              icon: Icons.add_rounded,
              onPressed: widget.onAttachmentTap ?? () {},
            ),
            const HorizontalGap(10),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _handleTextChanged,
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
            ChatIconButton(icon: Icons.mic_none_rounded, onPressed: () {}),
            const HorizontalGap(8),
            ChatIconButton(
              icon: widget.isSendDisabled
                  ? Icons.hourglass_top_rounded
                  : Icons.send_rounded,
              isPrimary: true,
              onPressed: _canSend && !widget.isSendDisabled
                  ? _submitMessage
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
