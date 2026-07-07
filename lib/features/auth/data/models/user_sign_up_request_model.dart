import 'package:cliniq/features/auth/domain/entities/user_sign_up_request_entity.dart';

class UserSignUpRequestModel extends UserSignUpRequestEntity {
  UserSignUpRequestModel({
    required super.name,
    required super.email,
    required super.password,
    required super.passwordConfirm,
    required super.phone,
    required super.gender,
    required super.birthDate,
  });

  Map<String, dynamic> toJson() {
    final nameParts = name.trim().split(RegExp(r'\s+'));
    final firstName = nameParts.isEmpty ? name : nameParts.first;
    final lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : nameParts.first;

    return {
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'dateOfBirth': birthDate.toIso8601String().split('T').first,
      'gender': gender.name[0].toUpperCase() + gender.name.substring(1),
    };
  }

  factory UserSignUpRequestModel.fromEntity(UserSignUpRequestEntity entity) {
    return UserSignUpRequestModel(
      name: entity.name,
      email: entity.email,
      password: entity.password,
      passwordConfirm: entity.passwordConfirm,
      phone: entity.phone,
      gender: entity.gender,
      birthDate: entity.birthDate,
    );
  }
}
