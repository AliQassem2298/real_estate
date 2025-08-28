// models/update_property_model.dart

class UpdatePropertyResponse {
  final String message;
  final PropertyModel property;

  const UpdatePropertyResponse({
    required this.message,
    required this.property,
  });

  factory UpdatePropertyResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePropertyResponse(
      message: json['message'] as String,
      property:
          PropertyModel.fromJson(json['property'] as Map<String, dynamic>),
    );
  }
}

class PropertyModel {
  final int id;
  final int userId;
  final String typeId;
  final String subtypeId;
  final String title;
  final String status;
  final String description;
  final String price;
  final String area;
  final String? floor;
  final String? roomsCount;
  final String latitude;
  final String longitude;
  final bool hasPool;
  final bool hasGarden;
  final bool hasElevator;
  final bool solarEnergy;
  final String? features;
  final String? nearbyServices;
  final bool approved;
  final String createdAt;
  final String updatedAt;

  // العلاقات
  final TypeModel type;
  final SubtypeModel subtype;
  final List<dynamic> images; // يمكن تحويلها لـ ImageModel لاحقًا

  const PropertyModel({
    required this.id,
    required this.userId,
    required this.typeId,
    required this.subtypeId,
    required this.title,
    required this.status,
    required this.description,
    required this.price,
    required this.area,
    this.floor,
    this.roomsCount,
    required this.latitude,
    required this.longitude,
    required this.hasPool,
    required this.hasGarden,
    required this.hasElevator,
    required this.solarEnergy,
    this.features,
    this.nearbyServices,
    required this.approved,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.subtype,
    required this.images,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      typeId: json['type_id'] as String,
      subtypeId: json['subtype_id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      area: json['area'] as String,
      floor: json['floor'] as String?,
      roomsCount: json['rooms_count'] as String?,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      hasPool: json['has_pool'] == true || json['has_pool'] == 1,
      hasGarden: json['has_garden'] == true || json['has_garden'] == 1,
      hasElevator: json['has_elevator'] == true || json['has_elevator'] == 1,
      solarEnergy: json['solar_energy'] == true || json['solar_energy'] == 1,
      features: json['features'] as String?,
      nearbyServices: json['nearby_services'] as String?,
      approved: json['approved'] == true || json['approved'] == 1,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      type: TypeModel.fromJson(json['type'] as Map<String, dynamic>),
      subtype: SubtypeModel.fromJson(json['subtype'] as Map<String, dynamic>),
      images: List<dynamic>.from(json['images'] ?? []),
    );
  }
}

class TypeModel {
  final int id;
  final String type;
  final String? createdAt;
  final String? updatedAt;

  const TypeModel({
    required this.id,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(
      id: json['id'] as int,
      type: json['type'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class SubtypeModel {
  final int id;
  final String subtype;
  final int typeId;
  final String? createdAt;
  final String? updatedAt;

  const SubtypeModel({
    required this.id,
    required this.subtype,
    required this.typeId,
    this.createdAt,
    this.updatedAt,
  });

  factory SubtypeModel.fromJson(Map<String, dynamic> json) {
    return SubtypeModel(
      id: json['id'] as int,
      subtype: json['subtype'] as String,
      typeId: json['type_id'] as int,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
