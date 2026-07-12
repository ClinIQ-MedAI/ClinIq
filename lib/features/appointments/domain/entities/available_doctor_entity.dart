class AvailableDoctorEntity {
  final String id;
  final String name;
  final String specialization;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String startTime;
  final String endTime;

  const AvailableDoctorEntity({
    required this.id,
    required this.name,
    required this.specialization,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.startTime,
    required this.endTime,
  });
}
