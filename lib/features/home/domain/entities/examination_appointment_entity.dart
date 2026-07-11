class ExaminationAppointmentEntity {
  final String id;
  final String doctorName;
  final String doctorSpeciality;
  final String doctorImage;
  final double rating;
  final int reviewCount;
  final String startTime;
  final String endTime;

  ExaminationAppointmentEntity({
    required this.id,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.doctorImage,
    required this.rating,
    required this.reviewCount,
    required this.startTime,
    required this.endTime,
  });
}
