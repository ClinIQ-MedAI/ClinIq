import 'package:cliniq/features/appointments/data/models/doctor_date_model.dart';
import 'package:cliniq/features/appointments/data/models/doctor_weekly_schedule_model.dart';
import 'package:cliniq/features/appointments/domain/entities/doctor_schedule_entity.dart';

class DoctorScheduleModel extends DoctorScheduleEntity {
  DoctorScheduleModel({
    required super.weeklySchedule,
    required super.dates,
  });

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    final weeklySchedule = (json['weeklySchedule'] as List)
        .map((e) =>
            DoctorWeeklyScheduleModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final dates = (json['dates'] as List)
        .map((e) => DoctorDateModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return DoctorScheduleModel(weeklySchedule: weeklySchedule, dates: dates);
  }
}
