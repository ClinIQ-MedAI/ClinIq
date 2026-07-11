import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';

class ExaminationAppointmentModel extends ExaminationAppointmentEntity {
  ExaminationAppointmentModel({
    required super.id,
    required super.doctorName,
    required super.doctorSpeciality,
    required super.doctorImage,
    required super.appointmentDate,
    required super.appointmentTime,
    required super.appointmentStatus,
  });

  factory ExaminationAppointmentModel.fromJson(Map<String, dynamic> json) {
    return ExaminationAppointmentModel(
      id: json['id'].toString(),
      doctorName: json['doctorName'] ?? json['name'] ?? '',
      doctorSpeciality: json['doctorSpeciality'] ?? json['specialization'] ?? '',
      doctorImage: json['doctorImage'] ?? json['imageUrl'] ?? '',
      appointmentDate: json['appointmentDate'] ?? '',
      appointmentTime: json['appointmentTime'] ?? '',
      appointmentStatus: json['appointmentStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'doctorSpeciality': doctorSpeciality,
      'doctorImage': doctorImage,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'appointmentStatus': appointmentStatus,
    };
  }

  factory ExaminationAppointmentModel.fromEntity(
    ExaminationAppointmentEntity entity,
  ) {
    return ExaminationAppointmentModel(
      id: entity.id,
      doctorName: entity.doctorName,
      doctorSpeciality: entity.doctorSpeciality,
      doctorImage: entity.doctorImage,
      appointmentDate: entity.appointmentDate,
      appointmentTime: entity.appointmentTime,
      appointmentStatus: entity.appointmentStatus,
    );
  }

  toEntity() {
    return ExaminationAppointmentEntity(
      id: id,
      doctorName: doctorName,
      doctorSpeciality: doctorSpeciality,
      doctorImage: doctorImage,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      appointmentStatus: appointmentStatus,
    );
  }

  ExaminationAppointmentModel copyWith({
    String? id,
    String? doctorName,
    String? doctorSpeciality,
    String? doctorImage,
    String? appointmentDate,
    String? appointmentTime,
    String? appointmentStatus,
  }) {
    return ExaminationAppointmentModel(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      doctorSpeciality: doctorSpeciality ?? this.doctorSpeciality,
      doctorImage: doctorImage ?? this.doctorImage,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
    );
  }
}
