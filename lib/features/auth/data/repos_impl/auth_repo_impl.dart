import 'package:cliniq/core/helpers/save_json_data_locally.dart';
import 'package:cliniq/features/user/data/models/user_profile_model.dart';
import 'package:dartz/dartz.dart';
import 'package:cliniq/core/api/api_keys.dart';
import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/core/extensions/either_extensions.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/core/repos/base_repo/base_repo_impl.dart';
import 'package:cliniq/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends BaseRepoImpl implements AuthRepo {
  AuthRepoImpl({required super.api});

  @override
  Future<Either<Failure, void>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return handleApi(
      () => api.post(
        EndPoints.login,
        data: {
          ApiKeys.email: email,
          ApiKeys.password: password,
          ApiKeys.otpCode: null,
        },
      ),
      backendMessageMapping: {
        "Invalid email or password":
            LocaleKeys.messagesFailuresIncorrectCredentials,
        "Please verify your email or phone before logging in":
            LocaleKeys.messagesFailuresInactiveUser,
      },
    ).onSuccess((result) async {
      await AppStorageHelper.setSecureData(
        StorageKeys.accessToken,
        result[ApiKeys.accessToken],
      );

      await AppStorageHelper.setSecureData(
        StorageKeys.refreshToken,
        result[ApiKeys.refreshToken],
      );

      await AppStorageHelper.setBool(StorageKeys.isLoggedIn, true);

      final user = UserProfileModel.fromJson(result["user"]);
      await cacheCurrentUser(user);

      await AppStorageHelper.deleteSecureData(StorageKeys.resetToken);
    }).asVoid();
  }

  @override
  Future<Either<Failure, void>> signUp({
    required Map<String, dynamic> data,
  }) async {
    final email = data[ApiKeys.email];

    return handleApi(
      () => api.post(EndPoints.userSignUp, data: data),
      backendMessageMapping: {
        'Passwords must be at least 8 characters.':
            LocaleKeys.messagesFailuresPasswordTooShort,
        'Passwords must have at least one non alphanumeric character.':
            LocaleKeys.messagesFailuresPasswordRequiresSpecialCharacter,
        'Passwords must have at least one lowercase (\'a\'-\'z\').':
            LocaleKeys.messagesFailuresPasswordRequiresLowercase,
        'Passwords must have at least one uppercase (\'A\'-\'Z\').':
            LocaleKeys.messagesFailuresPasswordRequiresUppercase,
        'Invalid email address.': LocaleKeys.messagesFailuresInvalidEmailFormat,
        'Email \'$email\' is invalid.': LocaleKeys.messagesFailuresInvalidEmail,
        'Another user With the same Email exists':
            LocaleKeys.messagesFailuresAccountAlreadyExists,
        'Phone number is already in use':
            LocaleKeys.messagesFailuresPhoneAlreadyExists,
      },
    ).asVoid();
  }

  @override
  Future<Either<Failure, void>> sendEmailOtp({required String email}) {
    return handleApi(
      () => api.post(EndPoints.sendEmailOtp, data: {ApiKeys.email: email}),
      backendMessageMapping: {
        "User not found": LocaleKeys.messagesFailuresUserNotFound,
      },
    ).asVoid();
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String code,
  }) async {
    await sendEmailOtp(email: email);
    return await handleApi(
      () => api.post(
        EndPoints.verifyEmail,
        data: {ApiKeys.email: email, ApiKeys.code: code},
      ),
      backendMessageMapping: {
        "Invalid or expired OTP":
            LocaleKeys.messagesFailuresInvalidOrExpiredCode,
      },
    ).onSuccess((result) async {
      await AppStorageHelper.deleteSecureData(StorageKeys.resetToken);
    });
  }

  @override
  Future<Either<Failure, void>> resendVerifyEmail({required String email}) {
    return handleApi(
      () => api.post(EndPoints.resendVerifyEmail, data: {ApiKeys.email: email}),
      backendMessageMapping: {
        "Invalid email": LocaleKeys.messagesFailuresInvalidEmail,
        "user already active": LocaleKeys.messagesFailuresUserAlreadyActive,
      },
    ).asVoid();
  }

  @override
  Future<Either<Failure, void>> logOut() {
    return handleApi(() => api.post(EndPoints.logOut)).asVoid();
  }

  @override
  Future<Either<Failure, void>> forgetPassword({required String email}) {
    return handleApi(
      () => api.post(EndPoints.forgetPassword, data: {ApiKeys.email: email}),
      backendMessageMapping: {
        "If the email exists, a password reset link has been sent.":
            LocaleKeys.messagesSuccessPasswordResetLinkSent,
      },
    ).asVoid();
  }

  @override
  Future<Either<Failure, void>> verifyResetCode({
    required String email,
    required String code,
  }) {
    return handleApi(
      () => api.post(
        EndPoints.verifyResetCode,
        data: {ApiKeys.email: email, ApiKeys.code: code},
      ),
      backendMessageMapping: {
        "Invalid email or reset code": LocaleKeys.messagesFailuresInvalidEmail,
        "Reset code has expired. Please request a new one.":
            LocaleKeys.messagesFailuresVerificationCodeNotFound,
      },
    ).onSuccess((result) async {
      // await AppStorageHelper.setSecureData(
      //   StorageKeys.resetToken,
      //   result[ApiKeys.resetToken],
      // );
    }).asVoid();
  }

  @override
  Future<Either<Failure, void>> resendResetCode({required String email}) {
    return handleApi(
      () => api.post(EndPoints.resendResetCode, data: {ApiKeys.email: email}),
      backendMessageMapping: {
        "Invalid email": LocaleKeys.messagesFailuresInvalidEmail,
      },
    ).asVoid();
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String newPassword,
    required String email,
    required String otp,
  }) {
    return handleApi(
      () => api.post(
        EndPoints.resetPassword,
        data: {
          ApiKeys.email: email,
          ApiKeys.code: otp,
          ApiKeys.newPassword: newPassword,
        },
      ),
      backendMessageMapping: {
        "The user with the specified ID was not found.":
            LocaleKeys.messagesFailuresUserNotFound,
        "Invalid or expired reset code.":
            LocaleKeys.messagesFailuresResetTokenExpired,
      },
    ).onSuccess((value) async {
      await AppStorageHelper.deleteSecureData(StorageKeys.resetToken);
    }).asVoid();
  }

  @override
  Future<Either<Failure, void>> completeUserProfile({
    required Map<String, dynamic> data,
  }) {
    return handleApi(
      () => api.post(EndPoints.completeProfile, data: data),
      backendMessageMapping: {
        "Invalid email": LocaleKeys.messagesFailuresInvalidEmail,
      },
    ).onSuccess((result) async {
      await AppStorageHelper.setBool(StorageKeys.isProfileCompleted, true);
      if (result["data"] != null) {
        final user = UserProfileModel.fromJson(result["data"]);
        await cacheCurrentUser(user);
      }
    }).asVoid();
  }
}
