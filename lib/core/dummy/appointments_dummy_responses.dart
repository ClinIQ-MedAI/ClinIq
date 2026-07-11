import 'package:cliniq/core/api/end_points.dart';

abstract final class AppointmentsDummyResponses {
  static dynamic getResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    switch (path) {
      case EndPoints.examinationAppointments:
      case EndPoints.getDoctorsByDate:
        List<Map<String, dynamic>> selectedDoctors = [];
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
            "name": "Dr. David Martinez",
            "spec": "Psychiatrist",
            "img":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
          {
            "name": "Dr. Mohamed Ahmed",
            "spec": "Cardiology",
            "img":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
          {
            "name": "Dr. Emily Davis",
            "spec": "Dermatology",
            "img":
                "https://img.freepik.com/free-photo/portrait-successful-mid-adult-doctor-with-crossed-arms_1262-12865.jpg",
          },
          {
            "name": "Dr. James Wilson",
            "spec": "Neurology",
            "img":
                "https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-isolated-on-white_651396-974.jpg",
          },
          {
            "name": "Dr. Maria Garcia",
            "spec": "Dentist",
            "img":
                "https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827715.jpg",
          },
          {
            "name": "Dr. Robert Chen",
            "spec": "Orthopedic",
            "img":
                "https://img.freepik.com/free-photo/portrait-successful-mid-adult-doctor-with-crossed-arms_1262-12865.jpg",
          },
          {
            "name": "Dr. Sophia Miller",
            "spec": "Oncology",
            "img":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
          {
            "name": "Dr. William Taylor",
            "spec": "Urology",
            "img":
                "https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-isolated-on-white_651396-974.jpg",
          },
          {
            "name": "Dr. Chloe Hall",
            "spec": "Gynecologist",
            "img":
                "https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg",
          },
          {
            "name": "Dr. David Martinez",
            "spec": "Psychiatrist",
            "img":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
          {
            "name": "Dr. Isabella Ross",
            "spec": "Opthalmologist",
            "img":
                "https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827715.jpg",
          },
          {
            "name": "Dr. Michael Lee",
            "spec": "Gastroenterologist",
            "img":
                "https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-isolated-on-white_651396-974.jpg",
          },
          {
            "name": "Dr. Ava Thompson",
            "spec": "Endocrinologist",
            "img":
                "https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg",
          },
          {
            "name": "Dr. Lucas Scott",
            "spec": "Pulmonologist",
            "img":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
          {
            "name": "Dr. Mia White",
            "spec": "Rheumatologist",
            "img":
                "https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827715.jpg",
          },
          {
            "name": "Dr. Ethan Green",
            "spec": "Nephrologist",
            "img":
                "https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-isolated-on-white_651396-974.jpg",
          },
          {
            "name": "Dr. Mason Hill",
            "spec": "General Surgeon",
            "img":
                "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
          },
        ];

        for (int j = 0; j < 5; j++) {
          int doctorIndex = (seed + j) % doctorsPool.length;
          var doc = doctorsPool[doctorIndex];

          int startHour = 9 + (seed % 3) + j;
          int endHour = startHour + 8;

          selectedDoctors.add({
            "id": "${seed}_$j",
            "name": doc["name"],
            "specialization": doc["spec"],
            "imageUrl": doc["img"],
            "rating": (4.0 + (seed % 10) * 0.1),
            "reviewCount": 50 + (seed % 200),
            "startTime":
                "${startHour % 12 == 0 ? 12 : startHour % 12}:00 ${startHour >= 12 ? 'PM' : 'AM'}",
            "endTime":
                "${endHour % 12 == 0 ? 12 : endHour % 12}:00 ${endHour >= 12 ? 'PM' : 'AM'}",
          });
        }

        return {
          "success": true,
          "message": "Data fetched successfully",
          "data": selectedDoctors,
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
