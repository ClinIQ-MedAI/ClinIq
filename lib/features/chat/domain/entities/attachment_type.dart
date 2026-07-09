import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:flutter/material.dart';

class AttachmentType {
  final String titleKey;
  final String descriptionKey;
  final IconData icon;
  final List<String> extensions;

  const AttachmentType({
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.extensions,
  });

  static const dentalXRay = AttachmentType(
    titleKey: LocaleKeys.chatDentalXRay,
    descriptionKey: LocaleKeys.chatDentalXRayDesc,
    icon: Icons.splitscreen_rounded,
    extensions: ['jpg', 'jpeg', 'png', 'dcm'],
  );

  static const boneXRay = AttachmentType(
    titleKey: LocaleKeys.chatBoneXRay,
    descriptionKey: LocaleKeys.chatBoneXRayDesc,
    icon: Icons.accessibility_new_rounded,
    extensions: ['jpg', 'jpeg', 'png', 'dcm'],
  );

  static const chestXRay = AttachmentType(
    titleKey: LocaleKeys.chatChestXRay,
    descriptionKey: LocaleKeys.chatChestXRayDesc,
    icon: Icons.healing_rounded,
    extensions: ['jpg', 'jpeg', 'png', 'dcm'],
  );

  static const dentalPhoto = AttachmentType(
    titleKey: LocaleKeys.chatDentalPhoto,
    descriptionKey: LocaleKeys.chatDentalPhotoDesc,
    icon: Icons.photo_camera_rounded,
    extensions: ['jpg', 'jpeg', 'png'],
  );

  static const medicalPrescription = AttachmentType(
    titleKey: LocaleKeys.chatMedicalPrescription,
    descriptionKey: LocaleKeys.chatMedicalPrescriptionDesc,
    icon: Icons.description_rounded,
    extensions: ['jpg', 'jpeg', 'png'],
  );

  static const pdfReport = AttachmentType(
    titleKey: LocaleKeys.chatPdfReport,
    descriptionKey: LocaleKeys.chatPdfReportDesc,
    icon: Icons.picture_as_pdf_rounded,
    extensions: ['pdf'],
  );

  static const List<AttachmentType> values = [
    dentalXRay,
    boneXRay,
    chestXRay,
    dentalPhoto,
    medicalPrescription,
    pdfReport,
  ];
}
