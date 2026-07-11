import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  DoctorModel({
    required super.id,
    required super.name,
    required super.image,
    required super.speciality,
    required super.experience,
    required super.rating,
    required super.numberOfAppointments,
    required super.city,
    super.bio,
    super.consultationFee,
    super.languages,
    super.education,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      speciality: json['speciality'],
      experience: json['experience'],
      rating: json['rating'],
      numberOfAppointments: json['numberOfAppointments'],
      city: json['city'],
      bio: json['bio'],
      consultationFee: json['consultationFee'],
      languages: json['languages'],
      education: json['education'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'speciality': speciality,
      'experience': experience,
      'rating': rating,
      'numberOfAppointments': numberOfAppointments,
      'city': city,
      if (bio != null) 'bio': bio,
      if (consultationFee != null) 'consultationFee': consultationFee,
      if (languages != null) 'languages': languages,
      if (education != null) 'education': education,
    };
  }

  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      speciality: entity.speciality,
      experience: entity.experience,
      rating: entity.rating,
      numberOfAppointments: entity.numberOfAppointments,
      city: entity.city,
      bio: entity.bio,
      consultationFee: entity.consultationFee,
      languages: entity.languages,
      education: entity.education,
    );
  }

  toEntity() {
    return DoctorEntity(
      id: id,
      name: name,
      image: image,
      speciality: speciality,
      experience: experience,
      rating: rating,
      numberOfAppointments: numberOfAppointments,
      city: city,
      bio: bio,
      consultationFee: consultationFee,
      languages: languages,
      education: education,
    );
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? image,
    String? speciality,
    String? experience,
    String? rating,
    String? numberOfAppointments,
    String? city,
    String? bio,
    String? consultationFee,
    String? languages,
    String? education,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      speciality: speciality ?? this.speciality,
      experience: experience ?? this.experience,
      rating: rating ?? this.rating,
      numberOfAppointments: numberOfAppointments ?? this.numberOfAppointments,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      consultationFee: consultationFee ?? this.consultationFee,
      languages: languages ?? this.languages,
      education: education ?? this.education,
    );
  }
}
