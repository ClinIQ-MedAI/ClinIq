import 'package:cliniq/core/api/end_points.dart';

abstract final class AuthDummyResponses {
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

      case EndPoints.userSignUp:
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

      default:
        return null;
    }
  }
}
