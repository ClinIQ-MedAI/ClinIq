import 'package:cliniq/features/appointments/data/models/doctor_schedule_model.dart';
import 'package:cliniq/features/appointments/domain/entities/doctor_detail_entity.dart';
import 'package:cliniq/features/home/data/models/doctor_model.dart';

class DoctorDetailsModel extends DoctorDetailEntity {
  DoctorDetailsModel({
    required super.doctor,
    required super.schedule,
  });

  factory DoctorDetailsModel.fromJson(Map<String, dynamic> json) {
    final doctorData = json['doctor'] as Map<String, dynamic>;
    final scheduleData = json['schedule'] as Map<String, dynamic>;
    return DoctorDetailsModel(
      doctor: DoctorModel.fromJson(doctorData),
      schedule: DoctorScheduleModel.fromJson(scheduleData),
    );
  }
}
