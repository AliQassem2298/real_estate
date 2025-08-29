// models/reservation_item_model.dart

class CreateReservationModel {
  final int id;
  final int userId;
  final int propertyId;
  final String depositAmount;
  final String createdAt;
  final String updatedAt;

  const CreateReservationModel({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.depositAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreateReservationModel.fromJson(Map<String, dynamic> json) {
    return CreateReservationModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      propertyId: int.parse((json['property_id'] ?? '0').toString()),
      depositAmount: json['deposit_amount'].toString(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
