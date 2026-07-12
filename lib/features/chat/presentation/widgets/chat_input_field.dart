import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/helpers/show_custom_snack_bar.dart';
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
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  bool _hasText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (_isTyping) {
      widget.onTypingChanged(false);
    }
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
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
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, widget.bottomSpacing.h + 8.h),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              color: _isFocused
                  ? context.colorScheme.primary.withValues(alpha: 0.3)
                  : context.colorScheme.outlineVariant.withValues(alpha: 0.2),
              width: _isFocused ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withValues(alpha: _isFocused ? 0.12 : 0.05),
                blurRadius: _isFocused ? 32 : 16,
                offset: Offset(0, _isFocused ? 12 : 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ChatIconButton(
                icon: Icons.add_rounded,
                onPressed: widget.onAttachmentTap ?? () {},
              ),
              const HorizontalGap(4),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _handleTextChanged,
                  minLines: 1,
                  maxLines: 4,
                  style: AppTextStyles.getTextStyle(15).copyWith(
                    color: context.textPalette.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.chatInputHint.tr(),
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 12.h,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const HorizontalGap(4),
              if (!_canSend)
                ChatIconButton(
                  icon: Icons.mic_none_rounded,
                  onPressed: () {},
                  onLongPress: () {
                    showCustomSnackBar(
                      context,
                      LocaleKeys.messagesFailuresMicDisabled,
                    );
                  },
                ),
              if (_canSend)
                AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ChatIconButton(
                      icon: widget.isSendDisabled
                          ? Icons.hourglass_top_rounded
                          : Icons.arrow_upward_rounded,
                      isPrimary: true,
                      onPressed: widget.isSendDisabled ? null : _submitMessage,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
