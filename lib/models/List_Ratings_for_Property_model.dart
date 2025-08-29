// models/rating_model.dart

class ListRatingsForPropertyModel {
  final String message;
  final List<RatingItem> data;

  const ListRatingsForPropertyModel({
    required this.message,
    required this.data,
  });

  factory ListRatingsForPropertyModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonData = json['data'] ?? [];
    final List<RatingItem> ratings =
        jsonData.map((item) => RatingItem.fromJson(item)).toList();

    return ListRatingsForPropertyModel(
      message: json['message'] as String,
      data: ratings,
    );
  }
}

class RatingItem {
  final int id;
  final int rating;
  final String? comment;
  final String createdAt;
  final String updatedAt;
  final int userId;
  final int propertyId;
  final UserModel user;

  const RatingItem({
    required this.id,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.propertyId,
    required this.user,
  });

  factory RatingItem.fromJson(Map<String, dynamic> json) {
    return RatingItem(
      id: json['id'] as int,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      userId: json['user_id'] as int,
      propertyId: json['property_id'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final int phoneNumber;
  final bool isVerified;
  final String? location;
  final String createdAt;
  final String updatedAt;

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
      emailVerifiedAt: json['email_verified_at'] as String?,
      phoneNumber: (json['phone_number'] as num).toInt(),
      isVerified: json['is_verified'] == 1 || json['is_verified'] == true,
      location: json['location'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
