import 'package:cliniq/features/appointments/domain/entities/doctor_schedule_entity.dart';

class DoctorDateModel extends DoctorDateAvailabilityEntity {
  DoctorDateModel({
    required super.day,
    required super.date,
    required super.month,
    required super.fullDate,
    required super.patientCount,
    required super.isFull,
  });

  factory DoctorDateModel.fromJson(Map<String, dynamic> json) {
    return DoctorDateModel(
      day: json['day'],
      date: json['date'],
      month: json['month'],
      fullDate: json['fullDate'],
      patientCount: json['patientCount'],
      isFull: json['isFull'],
    );
  }
}
