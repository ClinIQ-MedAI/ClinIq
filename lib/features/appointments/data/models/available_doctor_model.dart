import 'package:cliniq/features/appointments/domain/entities/available_doctor_entity.dart';

class AvailableDoctorModel extends AvailableDoctorEntity {
  const AvailableDoctorModel({
    required super.id,
    required super.name,
    required super.specialization,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.startTime,
    required super.endTime,
  });

  factory AvailableDoctorModel.fromJson(Map<String, dynamic> json) {
    return AvailableDoctorModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  AvailableDoctorModel copyWith({
    String? id,
    String? name,
    String? specialization,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    String? startTime,
    String? endTime,
  }) {
    return AvailableDoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
