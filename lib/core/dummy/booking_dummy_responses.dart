import 'package:cliniq/core/api/end_points.dart';

abstract final class BookingDummyResponses {
  static dynamic getResponse(String path, {Map<String, dynamic>? queryParameters}) {
    switch (path) {
      case _ when path.startsWith('patient/doctors/'):
        return {
          "success": true,
          "data": {
            "doctor": {
              "id": "1",
              "name": "Dr. Mohamed Ahmed",
              "image":
                  "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
              "speciality": "Cardiology",
              "experience": "10 years",
              "rating": "4.8",
              "numberOfAppointments": "1500+",
              "city": "Cairo",
              "bio":
                  "Dr. Mohamed Ahmed is a highly experienced cardiologist with over 10 years of practice in interventional cardiology. He has successfully treated thousands of patients with various heart conditions and is known for his compassionate approach to patient care.",
              "consultationFee": "200 EGP",
              "languages": "Arabic, English",
              "education": "MD - Cairo University, 2014",
            },
            "schedule": {
              "weeklySchedule": [
                {"day": "Sun", "range": "09:00 - 13:00"},
                {"day": "Tue", "range": "09:00 - 13:00"},
                {"day": "Thu", "range": "09:00 - 13:00"},
              ],
              "dates": [
                {
                  "day": "Sun",
                  "date": "27",
                  "month": "Jan",
                  "fullDate": "2026-01-27",
                  "patientCount": "2/10",
                  "isFull": false,
                },
                {
                  "day": "Tue",
                  "date": "29",
                  "month": "Jan",
                  "fullDate": "2026-01-29",
                  "patientCount": "Full",
                  "isFull": true,
                },
                {
                  "day": "Thu",
                  "date": "1",
                  "month": "Feb",
                  "fullDate": "2026-02-01",
                  "patientCount": "5/10",
                  "isFull": false,
                },
                {
                  "day": "Sun",
                  "date": "4",
                  "month": "Feb",
                  "fullDate": "2026-02-04",
                  "patientCount": "0/10",
                  "isFull": false,
                },
              ],
            },
          },
        };

      case _ when path.startsWith('patient/bookings/doctors/'):
        return {
          "success": true,
          "data": {
            "weeklySchedule": [
              {"day": "Sun", "range": "09:00 - 13:00"},
              {"day": "Tue", "range": "09:00 - 13:00"},
              {"day": "Thu", "range": "09:00 - 13:00"},
            ],
            "availableSlots": [
              {"id": "s1", "time": "09:00", "period": "Morning"},
              {"id": "s2", "time": "10:00", "period": "Morning"},
              {"id": "s3", "time": "11:00", "period": "Morning"},
              {"id": "s4", "time": "12:00", "period": "Afternoon"},
              {"id": "s5", "time": "14:00", "period": "Afternoon"},
              {"id": "s6", "time": "15:00", "period": "Afternoon"},
            ],
          },
        };

      case EndPoints.createBooking:
        return {
          "success": true,
          "message": "Booking created successfully",
          "data": {
            "id": "bk_001",
            "bookingNumber": "BK-2026-001",
            "status": "confirmed",
          },
        };

      case EndPoints.getMyBookings:
        return {
          "success": true,
          "data": [
            {
              "id": "bk_001",
              "doctorId": "1",
              "doctorName": "Dr. Mohamed Ahmed",
              "doctorImage":
                  "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
              "date": "2026-07-15",
              "time": "10:00",
              "status": "confirmed",
              "bookingNumber": "BK-2026-001",
            },
          ],
        };

      case EndPoints.getDoctorsByDate:
        return {
          "success": true,
          "data": [
            {
              "id": "2",
              "name": "Dr. Emily Davis",
              "image":
                  "https://img.freepik.com/free-photo/portrait-successful-mid-adult-doctor-with-crossed-arms_1262-12865.jpg",
              "speciality": "Dermatology",
              "experience": "8 years",
              "rating": "4.6",
              "numberOfAppointments": "900+",
              "city": "Alexandria",
            },
          ],
        };

      default:
        return null;
    }
  }
}
