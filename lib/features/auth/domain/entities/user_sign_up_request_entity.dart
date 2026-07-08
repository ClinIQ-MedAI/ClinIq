import 'package:cliniq/core/enums/gender.dart';

class UserSignUpRequestEntity {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirm;
  final String phone;
  final Gender gender;
  final DateTime birthDate;

  const UserSignUpRequestEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.phone,
    required this.gender,
    required this.birthDate,
  });
}
