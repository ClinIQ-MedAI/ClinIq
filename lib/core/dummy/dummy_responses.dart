import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/constants/locale_keys.dart';

class DummyResponses {
  static dynamic getResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    switch (path) {
      case EndPoints.login:
        return {
          "success": true,
          "message": "Login successful",
          "data": {
            "token": "dummy_access_token_123",
            "refreshToken": "dummy_refresh_token_456",
            "user": {
              "id": 1,
              "name": "Mohamed Ahmed",
              "email": "test@test.com",
              "role": "customer",
            },
          },
        };

      case EndPoints.getMe:
        return {
          "success": true,
          "data": {
            "id": 1,
            "name": "Mohamed Ahmed",
            "email": "test@test.com",
            "role": "customer",
          },
        };

      case EndPoints.userSignUp:
      case EndPoints.doctorSignUp:
        return {
          "success": true,
          "message": "Account created successfully",
          "data": {"email": "test@test.com"},
        };

      case EndPoints.verifyEmail:
      case EndPoints.resendVerifyEmail:
        return {"success": true, "message": "Verification email sent"};

      case EndPoints.forgetPassword:
      case EndPoints.resendResetCode:
        return {"success": true, "message": "Reset code sent"};

      case EndPoints.verifyResetCode:
        return {"success": true, "message": "Code verified"};

      case EndPoints.resetPassword:
        return {"success": true, "message": "Password reset successfully"};

      case EndPoints.logOut:
        return {"success": true, "message": "Logged out"};

      case EndPoints.specializations:
        return {
          "success": true,
          "message": "Specializations fetched successfully",
          "data": [
            {
              "id": "1",
              "name": "Cardiology",
              "image":
                  "https://img.freepik.com/free-vector/heart-attack-concept-illustration_114360-1014.jpg",
            },
            {
              "id": "2",
              "name": "Dermatology",
              "image":
                  "https://img.freepik.com/free-vector/skin-layer-diagram-medical-educational-poster_1308-59648.jpg",
            },
            {
              "id": "3",
              "name": "Neurology",
              "image":
                  "https://img.freepik.com/free-vector/brain-anatomy-concept-illustration_114360-1049.jpg",
            },
            {
              "id": "4",
              "name": "Pediatrics",
              "image":
                  "https://img.freepik.com/free-vector/hand-drawn-pediatrician-concept_23-2148492044.jpg",
            },
            {
              "id": "5",
              "name": "Orthopedics",
              "image":
                  "https://img.freepik.com/free-vector/orthopedics-rehabilitation-center-flat-composition-with-physicians-helping-patients-orthopedic-devices_1284-59695.jpg",
            },
            {
              "id": "6",
              "name": "Dentistry",
              "image":
                  "https://img.freepik.com/free-vector/dentist-with-patient-concept-illustration_114360-4493.jpg",
            },
          ],
        };

      case EndPoints.suggestedDoctors:
        return {
          "success": true,
          "message": "Doctors fetched successfully",
          "data": [
            {
              "id": "1",
              "name": "Dr. Mohamed Ahmed",
              "image":
                  "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
              "speciality": "Cardiology",
              "experience": "10 years",
              "rating": "4.8",
              "numberOfAppointments": "1200",
              "city": "Cairo",
            },
            {
              "id": "2",
              "name": "Dr. Emily Davis",
              "image":
                  "https://img.freepik.com/free-photo/portrait-successful-mid-adult-doctor-with-crossed-arms_1262-12865.jpg",
              "speciality": "Pediatrics",
              "experience": "6 years",
              "rating": "4.6",
              "numberOfAppointments": "450",
              "city": "Mansoura",
            },
            {
              "id": "3",
              "name": "Dr. James Wilson",
              "image":
                  "https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-isolated-on-white_651396-974.jpg",
              "speciality": "Neurology",
              "experience": "15 years",
              "rating": "4.7",
              "numberOfAppointments": "2100",
              "city": "Giza",
            },
            {
              "id": "4",
              "name": "Dr. Emily Davis",
              "image":
                  "https://img.freepik.com/free-photo/portrait-successful-mid-adult-doctor-with-crossed-arms_1262-12865.jpg",
              "speciality": "Pediatrics",
              "experience": "6 years",
              "rating": "4.6",
              "numberOfAppointments": "450",
              "city": "Mansoura",
            },
          ],
        };

      case EndPoints.news:
        return {
          "success": true,
          "message": "News fetched successfully",
          "data": [
            {
              "id": "1",
              "title": "Breakthrough in Heart Research",
              "image":
                  "https://img.freepik.com/free-vector/heart-anatomy-concept-illustration_114360-1014.jpg",
              "description":
                  "Scientists have discovered a new way to regenerate heart tissue using stem cells.",
            },
            {
              "id": "2",
              "title": "The Benefits of Daily Exercise",
              "image":
                  "https://img.freepik.com/free-photo/flat-lay-health-still-life-with-copy-space_23-2148854031.jpg",
              "description":
                  "Regular physical activity can significantly reduce the risk of chronic diseases.",
            },
            {
              "id": "3",
              "title": "New Mental Health Support App",
              "image":
                  "https://img.freepik.com/free-vector/mental-health-concept-illustration_114360-1014.jpg",
              "description":
                  "A revolutionary mobile application aims to provide 24/7 support for mental well-being.",
            },
            {
              "id": "4",
              "title": "Nutrition Tips for a Stronger Immune System",
              "image":
                  "https://img.freepik.com/free-photo/healthy-food-background_23-2148854031.jpg",
              "description":
                  "Learn which foods can help boost your body's natural defenses.",
            },
          ],
        };

      case EndPoints.examinationAppointments:
      case EndPoints.availableDoctors:
        List<Map<String, dynamic>> selectedDoctors = [];
        String? requestedDate = queryParameters?['date'];

        // Use a consistent seed based on the date string to make results stable per day
        int seed = 0;
        if (requestedDate != null) {
          // A simple hash of the date string
          for (int i = 0; i < requestedDate.length; i++) {
            seed += requestedDate.codeUnits[i];
          }
        } else {
          // Fallback to today's date format
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
          // Use the seed to pick 5 different doctors each day
          int doctorIndex = (seed + j) % doctorsPool.length;
          var doc = doctorsPool[doctorIndex];

          // Hours also vary by seed
          int hour = 9 + (seed % 3) + j;

          selectedDoctors.add({
            "id": "${seed}_$j",
            "doctorName": doc["name"],
            "doctorSpeciality": doc["spec"],
            "doctorImage": doc["img"],
            "appointmentDate": requestedDate,
            "appointmentTime":
                "${hour % 12 == 0 ? 12 : hour % 12}:00 ${hour >= 12 ? 'PM' : 'AM'}",
            "appointmentStatus": path == EndPoints.availableDoctors
                ? "Available"
                : "Upcoming",
          });
        }

        return {
          "success": true,
          "message": "Data fetched successfully",
          "data": selectedDoctors,
        };

      case EndPoints.doctorWorkingHours:
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
      case EndPoints.getDoctorById:
        return {
          "success": true,
          "message": "Doctor details fetched successfully",
          "data": {
            "doctor": {
              "id": "1",
              "name": "Dr. Mohamed Ahmed",
              "image":
                  "https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg",
              "speciality": "Cardiology",
              "experience": "10 years",
              "rating": "4.5",
              "numberOfAppointments": "100",
              "city": "Cairo",
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
      case EndPoints.bookAppointment:
        return {"success": true, "message": "Appointment booked successfully"};

      case EndPoints.getConversations:
        return {
          "success": true,
          "message": "Conversations fetched successfully",
          "data": _doctorConversations,
        };

      case EndPoints.getConversation:
        final type = queryParameters?['type'] as String?;
        return {
          "success": true,
          "message": "Conversation fetched successfully",
          "data": type == "ai" ? _aiConversation : _doctorConversations.first,
        };

      case EndPoints.getConversationById:
        final id = queryParameters?['id'] as String?;
        return {
          "success": true,
          "message": "Conversation fetched successfully",
          "data": _doctorConversations.firstWhere(
            (conversation) => conversation['id'] == id,
            orElse: () => _doctorConversations.first,
          ),
        };

      case EndPoints.sendChatMessage:
        return {
          "success": true,
          "message": "Message sent successfully",
          "data": {
            "id": "sent-message",
            "content": "",
            "sentAt": "Now",
            "sender": "user",
            "status": "delivered",
          },
        };

      default:
        return {
          "success": false,
          "message": "No dummy response for this endpoint",
        };
    }
  }

  static List<Map<String, dynamic>> get _doctorConversations => [
    {
      "id": "doctor-ahmed",
      "type": "doctor",
      "title": LocaleKeys.chatDoctorAhmedName,
      "subtitle": LocaleKeys.chatDoctorAhmedSpecialty,
      "emptyTitle": LocaleKeys.chatDoctorEmptyTitle,
      "emptyDescription": LocaleKeys.chatDoctorEmptyDescription,
      "lastMessage": LocaleKeys.chatDoctorMessage3,
      "lastMessageTime": "09:34",
      "unreadCount": 2,
      "isTyping": true,
      "isOnline": true,
      "messages": [
        {
          "id": "doctor-ahmed-message-1",
          "content": LocaleKeys.chatDoctorMessage1,
          "sentAt": "09:30",
          "sender": "doctor",
          "status": "seen",
        },
        {
          "id": "doctor-ahmed-message-2",
          "content": LocaleKeys.chatDoctorMessage2,
          "sentAt": "09:32",
          "sender": "user",
          "status": "seen",
        },
        {
          "id": "doctor-ahmed-message-3",
          "content": LocaleKeys.chatDoctorMessage3,
          "sentAt": "09:34",
          "sender": "doctor",
          "status": "delivered",
        },
      ],
    },
    {
      "id": "doctor-salma",
      "type": "doctor",
      "title": LocaleKeys.chatDoctorSalmaName,
      "subtitle": LocaleKeys.chatDoctorSalmaSpecialty,
      "emptyTitle": LocaleKeys.chatDoctorEmptyTitle,
      "emptyDescription": LocaleKeys.chatDoctorEmptyDescription,
      "lastMessage": LocaleKeys.chatDoctorSalmaMessage3,
      "lastMessageTime": "08:12",
      "unreadCount": 0,
      "isOnline": false,
      "messages": [
        {
          "id": "doctor-salma-message-1",
          "content": LocaleKeys.chatDoctorSalmaMessage1,
          "sentAt": "08:04",
          "sender": "doctor",
          "status": "seen",
        },
        {
          "id": "doctor-salma-message-2",
          "content": LocaleKeys.chatDoctorSalmaMessage2,
          "sentAt": "08:08",
          "sender": "user",
          "status": "seen",
        },
        {
          "id": "doctor-salma-message-3",
          "content": LocaleKeys.chatDoctorSalmaMessage3,
          "sentAt": "08:12",
          "sender": "doctor",
          "status": "seen",
        },
      ],
    },
    {
      "id": "doctor-youssef",
      "type": "doctor",
      "title": LocaleKeys.chatDoctorYoussefName,
      "subtitle": LocaleKeys.chatDoctorYoussefSpecialty,
      "emptyTitle": LocaleKeys.chatDoctorEmptyTitle,
      "emptyDescription": LocaleKeys.chatDoctorEmptyDescription,
      "lastMessage": LocaleKeys.chatDoctorYoussefMessage3,
      "lastMessageTime": "07:31",
      "unreadCount": 1,
      "isOnline": true,
      "messages": [
        {
          "id": "doctor-youssef-message-1",
          "content": LocaleKeys.chatDoctorYoussefMessage1,
          "sentAt": "07:20",
          "sender": "doctor",
          "status": "seen",
        },
        {
          "id": "doctor-youssef-message-2",
          "content": LocaleKeys.chatDoctorYoussefMessage2,
          "sentAt": "07:25",
          "sender": "user",
          "status": "delivered",
        },
        {
          "id": "doctor-youssef-message-3",
          "content": LocaleKeys.chatDoctorYoussefMessage3,
          "sentAt": "07:31",
          "sender": "doctor",
          "status": "delivered",
        },
      ],
    },
  ];

  static Map<String, dynamic> get _aiConversation => {
    "id": "ai-assistant",
    "type": "ai",
    "title": LocaleKeys.chatAiTitle,
    "subtitle": LocaleKeys.chatAiSubtitle,
    "emptyTitle": LocaleKeys.chatAiEmptyTitle,
    "emptyDescription": LocaleKeys.chatAiEmptyDescription,
    "lastMessage": LocaleKeys.chatAiMessage3,
    "lastMessageTime": "10:06",
    "isOnline": true,
    "messages": [
      {
        "id": "ai-message-1",
        "content": LocaleKeys.chatAiMessage1,
        "sentAt": "10:05",
        "sender": "ai",
        "status": "seen",
      },
      {
        "id": "ai-message-2",
        "content": LocaleKeys.chatAiMessage2,
        "sentAt": "10:06",
        "sender": "user",
        "status": "delivered",
      },
      {
        "id": "ai-message-3",
        "content": LocaleKeys.chatAiMessage3,
        "sentAt": "10:06",
        "sender": "ai",
        "status": "delivered",
      },
    ],
  };
}
