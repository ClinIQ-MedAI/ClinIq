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
            "name": "Mohamed Ahmed",
            "email": "test@test.com",
            "role": "customer",
          },
        };

      default:
        return null;
    }
  }
}
