import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/chat/domain/entities/attachment_type.dart';
import 'package:cliniq/features/chat/presentation/widgets/attachment_option_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScanModalityBottomSheet extends StatelessWidget {
  const ScanModalityBottomSheet({super.key, required this.onModalitySelected});

  final ValueChanged<String> onModalitySelected;

  static const _scanModalities = [
    AttachmentType.boneXRay,
    AttachmentType.chestXRay,
    AttachmentType.dentalXRay,
    AttachmentType.dentalPhoto,
  ];

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) => ScanModalityBottomSheet(
        onModalitySelected: (modality) {
          Navigator.pop(context, modality);
        },
      ),
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
            LocaleKeys.aiChatModalityTitle.tr(),
            style: AppTextStyles.getTextStyle(20).copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPalette.primaryColor,
              letterSpacing: -0.5,
            ),
          ),
          const VerticalGap(8),
          Text(
            LocaleKeys.aiChatModalityDescription.tr(),
            style: AppTextStyles.getTextStyle(14).copyWith(
              color: context.textPalette.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const VerticalGap(24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.2,
            ),
            itemCount: _scanModalities.length,
            itemBuilder: (context, index) {
              final type = _scanModalities[index];
              return AttachmentOptionCard(
                type: type,
                onTap: () {
                  final modality = _modalityValue(type);
                  onModalitySelected(modality);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _modalityValue(AttachmentType type) {
    if (type == AttachmentType.boneXRay) return 'BONE';
    if (type == AttachmentType.chestXRay) return 'CHEST';
    if (type == AttachmentType.dentalXRay) return 'DENTAL_XRAY';
    if (type == AttachmentType.dentalPhoto) return 'DENTAL_PHOTO';
    return 'BONE';
  }
}
