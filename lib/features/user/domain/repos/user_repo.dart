import 'package:dartz/dartz.dart';
import 'package:cliniq/core/errors/failures.dart';
import 'package:cliniq/features/user/domain/entities/user_profile_entity.dart';

abstract class UserRepo {
  Future<Either<Failure, UserProfileEntity>> getMe();
  Future<Either<Failure, UserProfileEntity>> updateMe({
    required Map<String, dynamic> data,
  });
  Future<Either<Failure, void>> completeProfile({
    required Map<String, dynamic> data,
  });
}
