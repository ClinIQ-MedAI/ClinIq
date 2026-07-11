import 'package:cliniq/features/home/domain/entities/examination_appointment_entity.dart';

class ExaminationAppointmentModel extends ExaminationAppointmentEntity {
  ExaminationAppointmentModel({
    required super.id,
    required super.doctorName,
    required super.doctorSpeciality,
    required super.doctorImage,
    required super.rating,
    required super.reviewCount,
    required super.startTime,
    required super.endTime,
  });

  factory ExaminationAppointmentModel.fromJson(Map<String, dynamic> json) {
    return ExaminationAppointmentModel(
      id: json['id'],
      doctorName: json['name'],
      doctorSpeciality: json['specialization'],
      doctorImage: json['imageUrl'],
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating'].toString()) ?? 0.0,
      reviewCount: json['reviewCount'] is num
          ? (json['reviewCount'] as num).toInt()
          : int.tryParse(json['reviewCount'].toString()) ?? 0,
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': doctorName,
      'specialization': doctorSpeciality,
      'imageUrl': doctorImage,
      'rating': rating,
      'reviewCount': reviewCount,
      'startTime': startTime,
      'endTime': endTime,
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
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      startTime: entity.startTime,
      endTime: entity.endTime,
    );
  }

  toEntity() {
    return ExaminationAppointmentEntity(
      id: id,
      doctorName: doctorName,
      doctorSpeciality: doctorSpeciality,
      doctorImage: doctorImage,
      rating: rating,
      reviewCount: reviewCount,
      startTime: startTime,
      endTime: endTime,
    );
  }

  ExaminationAppointmentModel copyWith({
    String? id,
    String? doctorName,
    String? doctorSpeciality,
    String? doctorImage,
    double? rating,
    int? reviewCount,
    String? startTime,
    String? endTime,
  }) {
    return ExaminationAppointmentModel(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      doctorSpeciality: doctorSpeciality ?? this.doctorSpeciality,
      doctorImage: doctorImage ?? this.doctorImage,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
