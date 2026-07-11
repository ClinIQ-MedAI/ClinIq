import 'package:cliniq/core/api/end_points.dart';

abstract final class AppointmentsDummyResponses {
  static dynamic getResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    switch (path) {
      case EndPoints.examinationAppointments:
      case EndPoints.getDoctorsByDate:
        List<Map<String, dynamic>> items = [];
        String? requestedDate = queryParameters?['date'];

        int seed = 0;
        if (requestedDate != null) {
          for (int i = 0; i < requestedDate.length; i++) {
            seed += requestedDate.codeUnits[i];
          }
        } else {
          DateTime now = DateTime.now();
          requestedDate =
              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
          for (int i = 0; i < requestedDate.length; i++) {
            seed += requestedDate.codeUnits[i];
          }
        }

        List<Map<String, String>> doctorsPool = [
          {
            "doctorName": "Dr. David Martinez",
            "doctorSpeciality": "Psychiatrist",
            "doctorImage":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
          {
            "doctorName": "Dr. Mohamed Ahmed",
            "doctorSpeciality": "Cardiology",
            "doctorImage":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
          {
            "doctorName": "Dr. Emily Davis",
            "doctorSpeciality": "Dermatology",
            "doctorImage":
                "https://img.freepik.com/free-photo/portrait-successful-mid-adult-doctor-with-crossed-arms_1262-12865.jpg",
          },
          {
            "doctorName": "Dr. James Wilson",
            "doctorSpeciality": "Neurology",
            "doctorImage":
                "https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-isolated-on-white_651396-974.jpg",
          },
          {
            "doctorName": "Dr. Maria Garcia",
            "doctorSpeciality": "Dentist",
            "doctorImage":
                "https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827715.jpg",
          },
          {
            "doctorName": "Dr. Robert Chen",
            "doctorSpeciality": "Orthopedic",
            "doctorImage":
                "https://img.freepik.com/free-photo/portrait-successful-mid-adult-doctor-with-crossed-arms_1262-12865.jpg",
          },
          {
            "doctorName": "Dr. Sophia Miller",
            "doctorSpeciality": "Oncology",
            "doctorImage":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
          {
            "doctorName": "Dr. William Taylor",
            "doctorSpeciality": "Urology",
            "doctorImage":
                "https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-isolated-on-white_651396-974.jpg",
          },
          {
            "doctorName": "Dr. Chloe Hall",
            "doctorSpeciality": "Gynecologist",
            "doctorImage":
                "https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg",
          },
          {
            "doctorName": "Dr. Isabella Ross",
            "doctorSpeciality": "Opthalmologist",
            "doctorImage":
                "https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827715.jpg",
          },
          {
            "doctorName": "Dr. Michael Lee",
            "doctorSpeciality": "Gastroenterologist",
            "doctorImage":
                "https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-isolated-on-white_651396-974.jpg",
          },
          {
            "doctorName": "Dr. Ava Thompson",
            "doctorSpeciality": "Endocrinologist",
            "doctorImage":
                "https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg",
          },
          {
            "doctorName": "Dr. Lucas Scott",
            "doctorSpeciality": "Pulmonologist",
            "doctorImage":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
          {
            "doctorName": "Dr. Mia White",
            "doctorSpeciality": "Rheumatologist",
            "doctorImage":
                "https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827715.jpg",
          },
          {
            "doctorName": "Dr. Ethan Green",
            "doctorSpeciality": "Nephrologist",
            "doctorImage":
                "https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-isolated-on-white_651396-974.jpg",
          },
          {
            "doctorName": "Dr. Mason Hill",
            "doctorSpeciality": "General Surgeon",
            "doctorImage":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
        ];

        List<String> statuses = ["Upcoming", "Completed", "Cancelled", "Pending"];

        for (int j = 0; j < 5; j++) {
          int doctorIndex = (seed + j) % doctorsPool.length;
          var doc = doctorsPool[doctorIndex];

          int appointmentHour = 9 + (seed % 8) + j;
          String time =
              "${appointmentHour % 12 == 0 ? 12 : appointmentHour % 12}:00 ${appointmentHour >= 12 ? 'PM' : 'AM'}";
          String status = statuses[j % statuses.length];

          items.add({
            "id": "${seed}_$j",
            "doctorName": doc["doctorName"],
            "doctorSpeciality": doc["doctorSpeciality"],
            "doctorImage": doc["doctorImage"],
            "appointmentDate": requestedDate,
            "appointmentTime": time,
            "appointmentStatus": status,
          });
        }

        return {
          "success": true,
          "message": "Data fetched successfully",
          "data": items,
        };

      case _ when path.startsWith('patient/bookings/doctors/') && path.endsWith('/schedules'):
        return {
          "success": true,
          "message": "Working hours fetched successfully",
          "data": {
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
        };
      case EndPoints.createBooking:
        return {"success": true, "message": "Appointment booked successfully"};

      default:
        return null;
    }
  }
}
