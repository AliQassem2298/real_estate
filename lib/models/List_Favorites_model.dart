import 'package:real_estate/models/property_models.dart'; // ✅ استيراد النموذج الرئيسي

class ListFavoritesModel {
  final String message;
  final List<SavedPropertyItem> data;

  const ListFavoritesModel({
    required this.message,
    required this.data,
  });

  factory ListFavoritesModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] ?? [];
    final List<SavedPropertyItem> items =
        dataList.map((item) => SavedPropertyItem.fromJson(item)).toList();

    return ListFavoritesModel(
      message: json['message'] as String,
      data: items,
    );
  }
}

class SavedPropertyItem {
  final int id;
  final String createdAt;
  final String updatedAt;
  final int userId;
  final int propertyId;
  final PropertyModel property;

  const SavedPropertyItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.propertyId,
    required this.property,
  });

  factory SavedPropertyItem.fromJson(Map<String, dynamic> json) {
    return SavedPropertyItem(
      id: json['id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      userId: json['user_id'] as int,
      propertyId: json['property_id'] as int,
      property:
          PropertyModel.fromJson(json['property'] as Map<String, dynamic>),
    );
  }
}
