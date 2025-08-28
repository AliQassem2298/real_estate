// user_model.dart

class ProfileModel {
  final UserModel data;
  final String message;

  const ProfileModel({
    required this.data,
    required this.message,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      data: UserModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final int phoneNumber;
  final bool isVerified;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.phoneNumber,
    required this.isVerified,
    this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      phoneNumber: json['phone_number'] as int,
      isVerified: json['is_verified'] == 1 || json['is_verified'] == true,
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
