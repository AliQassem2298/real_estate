// models/property_model.dart

class MyPropertiesModel {
  final List<PropertyModel> data;

  const MyPropertiesModel({required this.data});

  factory MyPropertiesModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] as List<dynamic>;
    final properties = dataList
        .map((item) => PropertyModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return MyPropertiesModel(data: properties);
  }
}

class PropertyModel {
  final int id;
  final int userId;
  final int typeId;
  final int subtypeId;
  final String title;
  final String status;
  final String description;
  final double price;
  final int area;
  final int? floor;
  final int? roomsCount;
  final double latitude;
  final double longitude;
  final bool hasPool;
  final bool hasGarden;
  final bool hasElevator;
  final bool solarEnergy;
  final String? features;
  final String? nearbyServices;
  final bool approved;
  final DateTime createdAt;
  final DateTime updatedAt;

  // العلاقات
  final TypeModel type;
  final SubtypeModel subtype;
  final List<ImageModel> images;

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
      typeId: json['type_id'] as int,
      subtypeId: json['subtype_id'] as int,
      title: json['title'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      price: double.parse((json['price'] ?? '0').toString()),
      area: (json['area'] as num).toInt(),
      floor: json['floor'] != null ? (json['floor'] as num).toInt() : null,
      roomsCount: json['rooms_count'] != null
          ? (json['rooms_count'] as num).toInt()
          : null,
      latitude: double.parse((json['latitude'] ?? '0').toString()),
      longitude: double.parse((json['longitude'] ?? '0').toString()),
      hasPool: json['has_pool'] == true || json['has_pool'] == 1,
      hasGarden: json['has_garden'] == true || json['has_garden'] == 1,
      hasElevator: json['has_elevator'] == true || json['has_elevator'] == 1,
      solarEnergy: json['solar_energy'] == true || json['solar_energy'] == 1,
      features: json['features'] as String?,
      nearbyServices: json['nearby_services'] as String?,
      approved: json['approved'] == true || json['approved'] == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      type: TypeModel.fromJson(json['type'] as Map<String, dynamic>),
      subtype: SubtypeModel.fromJson(json['subtype'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>)
          .map((img) => ImageModel.fromJson(img as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TypeModel {
  final int id;
  final String type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

class SubtypeModel {
  final int id;
  final String subtype;
  final int typeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

class ImageModel {
  final int id;
  final String imagePath;
  final int propertyId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ImageModel({
    required this.id,
    required this.imagePath,
    required this.propertyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as int,
      imagePath: json['image_path'] as String,
      propertyId: json['property_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
