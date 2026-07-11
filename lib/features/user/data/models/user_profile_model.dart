import 'package:cliniq/features/user/domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.userName,
    super.phoneNumber,
    super.gender,
    super.dateOfBirth,
    super.bloodGroup,
    super.height,
    super.weight,
    super.ailments,
    super.profilePic,
    super.role,
    super.emailConfirmed,
    super.phoneNumberConfirmed,
    super.status,
    super.hasDiabetes,
    super.hasPressureIssues,
    super.allergies,
    super.chronicConditions,
    super.emergencyContactName,
    super.emergencyContactPhone,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    String parseFirstName(Map<String, dynamic> j) {
      if ((j['firstName'] ?? '').isNotEmpty) return j['firstName'];
      final fallback = j['fullName'] ?? j['name'] ?? '';
      if (fallback.isEmpty) return '';
      final parts = fallback.toString().trim().split(RegExp(r'\s+'));
      return parts.first;
    }

    String parseLastName(Map<String, dynamic> j) {
      if ((j['lastName'] ?? '').isNotEmpty) return j['lastName'];
      final fallback = j['fullName'] ?? j['name'] ?? '';
      if (fallback.isEmpty) return '';
      final parts = fallback.toString().trim().split(RegExp(r'\s+'));
      if (parts.length > 1) return parts.sublist(1).join(' ');
      return parts.first;
    }

    return UserProfileModel(
      id: json['id'],
      firstName: parseFirstName(json),
      lastName: parseLastName(json),
      email: json['email'] ?? '',
      userName: json['userName'],
      phoneNumber: json['mobile'] ?? json['phoneNumber'] ?? json['phone'] ?? '',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] ?? json['birthDate'],
      bloodGroup: json['bloodGroup'] ?? json['bloodType'],
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      ailments: json['ailments'],
      profilePic: json['profilePic'] ?? json['profilePicUrl'] ?? json['avatar'],
      role: json['role'],
      emailConfirmed: json['emailConfirmed'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'],
      status: json['status'],
      hasDiabetes: json['hasDiabetes'],
      hasPressureIssues: json['hasPressureIssues'],
      allergies: json['allergies'],
      chronicConditions: json['chronicConditions'],
      emergencyContactName: json['emergencyContactName'],
      emergencyContactPhone: json['emergencyContactPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      if (userName != null) 'userName': userName,
      if (phoneNumber != null && phoneNumber!.isNotEmpty)
        'phoneNumber': phoneNumber,
      if (gender != null && gender!.isNotEmpty) 'gender': gender,
      if (dateOfBirth != null && dateOfBirth!.isNotEmpty)
        'dateOfBirth': dateOfBirth,
      if (bloodGroup != null && bloodGroup!.isNotEmpty)
        'bloodGroup': bloodGroup,
      if (height != null && height!.isNotEmpty) 'height': height,
      if (weight != null && weight!.isNotEmpty) 'weight': weight,
      if (ailments != null && ailments!.isNotEmpty) 'ailments': ailments,
      if (profilePic != null && profilePic!.isNotEmpty)
        'profilePic': profilePic,
      if (role != null && role!.isNotEmpty) 'role': role,
      if (emailConfirmed != null) 'emailConfirmed': emailConfirmed,
      if (phoneNumberConfirmed != null)
        'phoneNumberConfirmed': phoneNumberConfirmed,
      if (status != null && status!.isNotEmpty) 'status': status,
      if (hasDiabetes != null) 'hasDiabetes': hasDiabetes,
      if (hasPressureIssues != null) 'hasPressureIssues': hasPressureIssues,
      if (allergies != null && allergies!.isNotEmpty) 'allergies': allergies,
      if (chronicConditions != null && chronicConditions!.isNotEmpty)
        'chronicConditions': chronicConditions,
      if (emergencyContactName != null && emergencyContactName!.isNotEmpty)
        'emergencyContactName': emergencyContactName,
      if (emergencyContactPhone != null && emergencyContactPhone!.isNotEmpty)
        'emergencyContactPhone': emergencyContactPhone,
    };
  }

  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      userName: entity.userName,
      phoneNumber: entity.phoneNumber,
      gender: entity.gender,
      dateOfBirth: entity.dateOfBirth,
      bloodGroup: entity.bloodGroup,
      height: entity.height,
      weight: entity.weight,
      ailments: entity.ailments,
      profilePic: entity.profilePic,
      role: entity.role,
      emailConfirmed: entity.emailConfirmed,
      phoneNumberConfirmed: entity.phoneNumberConfirmed,
      status: entity.status,
      hasDiabetes: entity.hasDiabetes,
      hasPressureIssues: entity.hasPressureIssues,
      allergies: entity.allergies,
      chronicConditions: entity.chronicConditions,
      emergencyContactName: entity.emergencyContactName,
      emergencyContactPhone: entity.emergencyContactPhone,
    );
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      userName: userName,
      phoneNumber: phoneNumber,
      gender: gender,
      dateOfBirth: dateOfBirth,
      bloodGroup: bloodGroup,
      height: height,
      weight: weight,
      ailments: ailments,
      profilePic: profilePic,
      role: role,
      emailConfirmed: emailConfirmed,
      phoneNumberConfirmed: phoneNumberConfirmed,
      status: status,
      hasDiabetes: hasDiabetes,
      hasPressureIssues: hasPressureIssues,
      allergies: allergies,
      chronicConditions: chronicConditions,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
    );
  }

  UserProfileModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? userName,
    String? phoneNumber,
    String? gender,
    String? dateOfBirth,
    String? bloodGroup,
    String? height,
    String? weight,
    String? ailments,
    String? profilePic,
    String? role,
    bool? emailConfirmed,
    bool? phoneNumberConfirmed,
    String? status,
    bool? hasDiabetes,
    bool? hasPressureIssues,
    String? allergies,
    String? chronicConditions,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      ailments: ailments ?? this.ailments,
      profilePic: profilePic ?? this.profilePic,
      role: role ?? this.role,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
      phoneNumberConfirmed: phoneNumberConfirmed ?? this.phoneNumberConfirmed,
      status: status ?? this.status,
      hasDiabetes: hasDiabetes ?? this.hasDiabetes,
      hasPressureIssues: hasPressureIssues ?? this.hasPressureIssues,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
    );
  }
}
