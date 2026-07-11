import 'package:cliniq/features/home/domain/entities/doctor_entity.dart';

class BookingEntity {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorImage;
  final String date;
  final String time;
  final String status;
  final String? bookingNumber;

  BookingEntity({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorImage,
    required this.date,
    required this.time,
    required this.status,
    this.bookingNumber,
  });
}

class ScheduleSlotEntity {
  final String id;
  final String time;
  final String period;
  final bool isBooked;

  ScheduleSlotEntity({
    required this.id,
    required this.time,
    required this.period,
    this.isBooked = false,
  });
}

class WeeklyDayRangeEntity {
  final String day;
  final String range;

  WeeklyDayRangeEntity({required this.day, required this.range});
}

class DoctorSchedulesEntity {
  final List<WeeklyDayRangeEntity> weeklySchedule;
  final List<ScheduleSlotEntity> availableSlots;
  final DoctorEntity? doctor;

  DoctorSchedulesEntity({
    required this.weeklySchedule,
    required this.availableSlots,
    this.doctor,
  });
}
