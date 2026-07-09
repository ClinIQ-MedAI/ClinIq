import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/attachment_type.dart';
import 'package:cliniq/features/chat/presentation/widgets/attachment_option_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttachmentPickerSheet extends StatelessWidget {
  const AttachmentPickerSheet({super.key, required this.onTypeSelected});

  final ValueChanged<AttachmentType> onTypeSelected;

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<AttachmentType> onTypeSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: context.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) => AttachmentPickerSheet(onTypeSelected: onTypeSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          const VerticalGap(24),
          Text(
            LocaleKeys.chatAttachmentPickerTitle.tr(),
            style: AppTextStyles.getTextStyle(20).copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPalette.primaryColor,
              letterSpacing: -0.5,
            ),
          ),
          const VerticalGap(24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.8,
            ),
            itemCount: AttachmentType.values.length,
            itemBuilder: (context, index) {
              final type = AttachmentType.values[index];
              return AttachmentOptionCard(
                type: type,
                onTap: () {
                  Navigator.pop(context);
                  onTypeSelected(type);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
