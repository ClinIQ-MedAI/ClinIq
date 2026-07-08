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
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      firstName: parseFirstName(json),
      lastName: parseLastName(json),
      email: json['email'] ?? '',
      userName: json['userName'],
      phoneNumber: json['mobile'] ??
          json['phoneNumber'] ??
          json['phone'] ??
          '',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] ?? json['birthDate'],
      bloodGroup: json['bloodGroup'] ?? json['bloodType'],
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      ailments: json['ailments'] ?? json['chronicConditions'],
      profilePic:
          json['profilePic'] ?? json['profilePicUrl'] ?? json['avatar'],
      role: json['role'],
      emailConfirmed: json['emailConfirmed'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'],
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
    );
  }

  UserProfileModel copyWith({
    int? id,
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
      phoneNumberConfirmed:
          phoneNumberConfirmed ?? this.phoneNumberConfirmed,
    );
  }
}
