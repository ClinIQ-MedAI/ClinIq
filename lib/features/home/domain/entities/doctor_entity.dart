class DoctorEntity {
  final String id;
  final String name;
  final String image;
  final String speciality;
  final String experience;
  final String rating;
  final String numberOfAppointments;
  final String city;
  final String? bio;
  final String? consultationFee;
  final String? languages;
  final String? education;

  DoctorEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.speciality,
    required this.experience,
    required this.rating,
    required this.numberOfAppointments,
    required this.city,
    this.bio,
    this.consultationFee,
    this.languages,
    this.education,
  });
}
