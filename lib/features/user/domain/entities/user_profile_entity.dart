class UserProfileEntity {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? userName;
  final String? phoneNumber;
  final String? gender;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? height;
  final String? weight;
  final String? ailments;
  final String? profilePic;
  final String? role;
  final bool? emailConfirmed;
  final bool? phoneNumberConfirmed;

  UserProfileEntity({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.userName,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.bloodGroup,
    this.height,
    this.weight,
    this.ailments,
    this.profilePic,
    this.role,
    this.emailConfirmed,
    this.phoneNumberConfirmed,
  });

  String get fullName {
    final f = firstName.trim();
    final l = lastName.trim();
    if (f.isEmpty && l.isEmpty) return email;
    return '$f $l'.trim();
  }

  bool get hasMedicalInfo =>
      (gender != null && gender!.isNotEmpty) ||
      (bloodGroup != null && bloodGroup!.isNotEmpty) ||
      (height != null && height!.isNotEmpty) ||
      (weight != null && weight!.isNotEmpty) ||
      (ailments != null && ailments!.isNotEmpty) ||
      (dateOfBirth != null && dateOfBirth!.isNotEmpty);
}
