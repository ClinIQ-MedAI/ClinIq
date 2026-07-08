import 'package:cliniq/features/auth/domain/entities/user_sign_up_request_entity.dart';

class UserSignUpRequestModel extends UserSignUpRequestEntity {
  UserSignUpRequestModel({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.password,
    required super.passwordConfirm,
    required super.phone,
    required super.gender,
    required super.birthDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'dateOfBirth': birthDate.toIso8601String().split('T').first,
      'gender': gender.name[0].toUpperCase() + gender.name.substring(1),
    };
  }

  factory UserSignUpRequestModel.fromEntity(UserSignUpRequestEntity entity) {
    return UserSignUpRequestModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      password: entity.password,
      passwordConfirm: entity.passwordConfirm,
      phone: entity.phone,
      gender: entity.gender,
      birthDate: entity.birthDate,
    );
  }
}
