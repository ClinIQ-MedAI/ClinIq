import 'package:cliniq/features/booking/domain/entities/booking_entity.dart';
import 'package:cliniq/features/home/data/models/doctor_model.dart';
import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.id,
    required super.doctorId,
    required super.doctorName,
    required super.doctorImage,
    required super.date,
    required super.time,
    required super.status,
    super.bookingNumber,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      doctorImage: json['doctorImage'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      bookingNumber: json['bookingNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorImage': doctorImage,
      'date': date,
      'time': time,
      'status': status,
      if (bookingNumber != null) 'bookingNumber': bookingNumber,
    };
  }
}

class ScheduleSlotModel extends ScheduleSlotEntity {
  ScheduleSlotModel({
    required super.id,
    required super.time,
    required super.period,
    super.isBooked = false,
  });

  factory ScheduleSlotModel.fromJson(Map<String, dynamic> json) {
    return ScheduleSlotModel(
      id: json['id'],
      time: json['time'],
      period: json['period'],
      isBooked: json['isBooked'] ?? false,
    );
  }
}

class DoctorSchedulesModel extends DoctorSchedulesEntity {
  DoctorSchedulesModel({
    required super.weeklySchedule,
    required super.availableSlots,
    super.doctor,
  });

  factory DoctorSchedulesModel.fromJson(Map<String, dynamic> json) {
    final weeklySchedule = (json['weeklySchedule'] as List)
        .map((e) => WeeklyDayRangeEntity(
              day: e['day'],
              range: e['range'],
            ))
        .toList();

    final availableSlots = (json['availableSlots'] as List)
        .map((e) => ScheduleSlotModel.fromJson(e as Map<String, dynamic>))
        .toList();

    DoctorEntity? doctor;
    if (json['doctor'] != null) {
      doctor = DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>);
    }

    return DoctorSchedulesModel(
      weeklySchedule: weeklySchedule,
      availableSlots: availableSlots,
      doctor: doctor,
    );
  }
}
