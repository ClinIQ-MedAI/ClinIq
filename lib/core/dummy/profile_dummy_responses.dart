import 'package:cliniq/core/api/end_points.dart';

abstract final class ProfileDummyResponses {
  static dynamic getResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    switch (path) {
      case EndPoints.getMe:
        return {
          "success": true,
          "data": {
            "id": 1,
            "firstName": "Mohamed",
            "lastName": "Ahmed",
            "email": "test@test.com",
            "userName": "mohamed_ahmed",
            "phoneNumber": "+20 123 456 7890",
            "emailConfirmed": true,
            "phoneNumberConfirmed": false,
            "gender": "male",
            "bloodGroup": "O+",
            "height": "180",
            "weight": "75",
            "ailments": "None",
            "role": "customer",
          },
        };

      default:
        return null;
    }
  }
}
