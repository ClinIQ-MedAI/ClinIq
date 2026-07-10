import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

extension DoctorSpecialityX on String {
  String get localizedSpeciality {
    final map = {
      'Cardiology': LocaleKeys.specialitiesCardiology,
      'Neurology': LocaleKeys.specialitiesNeurology,
      'Pediatrics': LocaleKeys.specialitiesPediatrics,
      'Dentistry': LocaleKeys.specialitiesDentistry,
      'Dermatology': LocaleKeys.specialitiesDermatology,
      'Orthopedics': LocaleKeys.specialitiesOrthopedics,
      'Ophthalmology': LocaleKeys.specialitiesOphthalmology,
      'Ear, Nose & Throat': LocaleKeys.specialitiesEnt,
      'ENT': LocaleKeys.specialitiesEnt,
      'Psychiatry': LocaleKeys.specialitiesPsychiatry,
      'General Surgery': LocaleKeys.specialitiesGeneralSurgery,
      'Internal Medicine': LocaleKeys.specialitiesInternalMedicine,
      'Obstetrics & Gynecology': LocaleKeys.specialitiesObstetricsGynecology,
      'Radiology': LocaleKeys.specialitiesRadiology,
      'Anesthesia': LocaleKeys.specialitiesAnesthesia,
      'Emergency Medicine': LocaleKeys.specialitiesEmergencyMedicine,
      'Family Medicine': LocaleKeys.specialitiesFamilyMedicine,
      'Gastroenterology': LocaleKeys.specialitiesGastroenterology,
      'Nephrology': LocaleKeys.specialitiesNephrology,
      'Oncology': LocaleKeys.specialitiesOncology,
      'Pulmonology': LocaleKeys.specialitiesPulmonology,
      'Rheumatology': LocaleKeys.specialitiesRheumatology,
      'Urology': LocaleKeys.specialitiesUrology,
      'Endocrinology': LocaleKeys.specialitiesEndocrinology,
      'Hematology': LocaleKeys.specialitiesHematology,
      'Infectious Disease': LocaleKeys.specialitiesInfectiousDisease,
    };

    return map[this]?.tr() ?? this;
  }
}
