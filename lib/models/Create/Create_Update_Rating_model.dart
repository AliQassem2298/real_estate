// models/rating_model.dart

class CreateUpdateRatingModel {
  final String message;
  final RatingData data;

  const CreateUpdateRatingModel({
    required this.message,
    required this.data,
  });

  factory CreateUpdateRatingModel.fromJson(Map<String, dynamic> json) {
    return CreateUpdateRatingModel(
      message: json['message'] as String,
      data: RatingData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class RatingData {
  final int id;
  final int rating;
  final String? comment;
  final String createdAt;
  final String updatedAt;
  final int userId;
  final int propertyId;

  const RatingData({
    required this.id,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.propertyId,
  });

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      id: json['id'] as int,
      rating: int.parse(json['rating'].toString()), // لأن "rating": "4" (نص)
      comment: json['comment'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      userId: json['user_id'] as int,
      propertyId: json['property_id'] as int,
    );
  }
}
