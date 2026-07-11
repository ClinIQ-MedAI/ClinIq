class ExaminationAppointmentEntity {
  final String id;
  final String doctorName;
  final String doctorSpeciality;
  final String doctorImage;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentStatus;

  ExaminationAppointmentEntity({
    required this.id,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.doctorImage,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentStatus,
  });
}
