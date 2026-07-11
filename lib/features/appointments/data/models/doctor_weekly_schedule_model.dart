import 'package:cliniq/features/appointments/domain/entities/doctor_schedule_entity.dart';

class DoctorWeeklyScheduleModel extends WorkingDayRangeEntity {
  DoctorWeeklyScheduleModel({
    required super.day,
    required super.range,
  });

  factory DoctorWeeklyScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorWeeklyScheduleModel(
      day: json['day'],
      range: json['range'],
    );
  }
}
