import 'package:cliniq/core/api/end_points.dart';

abstract final class HomeDummyResponses {
  static dynamic getResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    switch (path) {
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

      default:
        return null;
    }
  }
}
