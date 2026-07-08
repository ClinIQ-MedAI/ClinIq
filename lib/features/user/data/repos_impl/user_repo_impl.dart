import 'package:cliniq/core/api/end_points.dart';
import 'package:cliniq/core/constants/storage_keys.dart';
import 'package:cliniq/core/extensions/either_extensions.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/core/helpers/save_json_data_locally.dart';
import 'package:cliniq/core/repos/base_repo/base_repo_impl.dart';
import 'package:cliniq/features/user/data/models/user_profile_model.dart';
import 'package:cliniq/features/user/domain/entities/user_profile_entity.dart';
import 'package:cliniq/features/user/domain/repos/user_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:cliniq/core/errors/failures.dart';

class UserRepoImpl extends BaseRepoImpl implements UserRepo {
  UserRepoImpl({required super.api});

  @override
  Future<Either<Failure, UserProfileEntity>> getMe() {
    return handleApi(() async {
      final response = await api.get(EndPoints.getMe);
      final user = UserProfileModel.fromJson(response["data"]);
      await saveJsonDataLocally(
        storageKey: StorageKeys.currentUser,
        json: user.toJson(),
      );
      await _syncProfileCompletedFlag(user);
      return user;
    });
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateMe({
    required Map<String, dynamic> data,
  }) {
    return handleApi(() async {
      final response = await api.patch(EndPoints.updateMe, data: data);
      final user = UserProfileModel.fromJson(response["data"]);
      await saveJsonDataLocally(
        storageKey: StorageKeys.currentUser,
        json: user.toJson(),
      );
      await _syncProfileCompletedFlag(user);
      return user;
    });
  }

  Future<void> _syncProfileCompletedFlag(UserProfileEntity user) async {
    await AppStorageHelper.setBool(
      StorageKeys.isProfileCompleted,
      user.hasMedicalInfo,
    );
  }

  @override
  Future<Either<Failure, void>> completeProfile({
    required Map<String, dynamic> data,
  }) {
    return handleApi(
      () => api.post(EndPoints.completeProfile, data: data),
    ).onSuccess((result) async {
      await AppStorageHelper.setBool(StorageKeys.isProfileCompleted, true);
      if (result["data"] != null) {
        final user = UserProfileModel.fromJson(result["data"]);
        await saveJsonDataLocally(
          storageKey: StorageKeys.currentUser,
          json: user.toJson(),
        );
      }
    }).asVoid();
  }
}
