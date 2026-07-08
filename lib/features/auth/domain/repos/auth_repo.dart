import 'package:dartz/dartz.dart';
import 'package:cliniq/core/errors/failures.dart';

abstract class AuthRepo {
  Future<Either<Failure, void>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> signUp({required Map<String, dynamic> data});
  Future<Either<Failure, void>> logOut();

  // verify email
  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String code,
  });
  Future<Either<Failure, void>> resendVerifyEmail({required String email});

  Future<Either<Failure,void>> sendEmailOtp({required String email});

  // forget password
  Future<Either<Failure, void>> forgetPassword({required String email});

  Future<Either<Failure, void>> verifyResetCode({
    required String email,
    required String code,
  });

  Future<Either<Failure, void>> resendResetCode({required String email});

  Future<Either<Failure, void>> resetPassword({
    required String newPassword,
    required String email,
    required String otp,
  });

  Future<Either<Failure, void>> completeUserProfile({
    required Map<String, dynamic> data,
  });
}
