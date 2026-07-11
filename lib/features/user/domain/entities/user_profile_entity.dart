class UserProfileEntity {
  final String? id;
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
  final String? status;
  final bool? hasDiabetes;
  final bool? hasPressureIssues;
  final String? allergies;
  final String? chronicConditions;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

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
    this.status,
    this.hasDiabetes,
    this.hasPressureIssues,
    this.allergies,
    this.chronicConditions,
    this.emergencyContactName,
    this.emergencyContactPhone,
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

  bool get isProfileCompleted {
    return (height != null && height!.isNotEmpty) ||
        (weight != null && weight!.isNotEmpty) ||
        (bloodGroup != null && bloodGroup!.isNotEmpty) ||
        (emergencyContactName != null && emergencyContactName!.isNotEmpty) ||
        (emergencyContactPhone != null && emergencyContactPhone!.isNotEmpty);
  }
}
