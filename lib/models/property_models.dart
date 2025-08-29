// models/property_models.dart

class PublicListApprovedModel {
  final List<PropertyModel> data;

  const PublicListApprovedModel({required this.data});

  factory PublicListApprovedModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonData = json['data'] ?? [];
    final List<PropertyModel> properties =
        jsonData.map((item) => PropertyModel.fromJson(item)).toList();

    return PublicListApprovedModel(data: properties);
  }
}

class PublicShowApprovedModel {
  final PropertyModel data;

  const PublicShowApprovedModel({required this.data});

  factory PublicShowApprovedModel.fromJson(Map<String, dynamic> json) {
    return PublicShowApprovedModel(
      data: PropertyModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

// النموذج الرئيسي للعقار - يستخدم في القائمة والتفاصيل
class PropertyModel {
  final int id;
  final int userId;
  final int typeId;
  final int subtypeId;
  final String title;
  final String status;
  final String description;
  final String price;
  final int area;
  final int? floor;
  final int? roomsCount;
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
  final List<ImageModel> images;
  final List<DocumentModel> documents;

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
    required this.documents,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      typeId: (json['type_id'] as num).toInt(),
      subtypeId: (json['subtype_id'] as num).toInt(),
      title: json['title'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      price: json['price'].toString(),
      area: (json['area'] as num).toInt(),
      floor: json['floor'] != null ? (json['floor'] as num).toInt() : null,
      roomsCount: json['rooms_count'] != null
          ? (json['rooms_count'] as num).toInt()
          : null,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      hasPool: _parseBool(json['has_pool']),
      hasGarden: _parseBool(json['has_garden']),
      hasElevator: _parseBool(json['has_elevator']),
      solarEnergy: _parseBool(json['solar_energy']),
      features: json['features'] as String?,
      nearbyServices: json['nearby_services'] as String?,
      approved: _parseBool(json['approved']),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      type: json['type'] != null
          ? TypeModel.fromJson(json['type'] as Map<String, dynamic>)
          : const TypeModel(
              id: 0, type: 'غير معروف', createdAt: '', updatedAt: ''),
      subtype: json['subtype'] != null
          ? SubtypeModel.fromJson(json['subtype'] as Map<String, dynamic>)
          : const SubtypeModel(
              id: 0,
              subtype: 'غير معروف',
              typeId: 0,
              createdAt: '',
              updatedAt: ''),
      images: (json['images'] as List?)
              ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <ImageModel>[],
      documents: (json['documents'] as List?)
              ?.map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <DocumentModel>[],
    );
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return ['true', '1', 'yes'].contains(value.toLowerCase());
    }
    return false;
  }
}

class TypeModel {
  final int id;
  final String type;
  final String createdAt;
  final String updatedAt;

  const TypeModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class SubtypeModel {
  final int id;
  final String subtype;
  final int typeId;
  final String createdAt;
  final String updatedAt;

  const SubtypeModel({
    required this.id,
    required this.subtype,
    required this.typeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubtypeModel.fromJson(Map<String, dynamic> json) {
    return SubtypeModel(
      id: (json['id'] as num).toInt(),
      subtype: json['subtype'] as String,
      typeId: (json['type_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class ImageModel {
  final int id;
  final String imagePath;
  final int propertyId;
  final String createdAt;
  final String updatedAt;

  const ImageModel({
    required this.id,
    required this.imagePath,
    required this.propertyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: (json['id'] as num).toInt(),
      imagePath: json['image_path'] as String,
      propertyId: (json['property_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class DocumentModel {
  final int id;
  final String documentType;
  final String filePath;
  final String createdAt;
  final String updatedAt;
  final int propertyId;

  const DocumentModel({
    required this.id,
    required this.documentType,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
    required this.propertyId,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: (json['id'] as num).toInt(),
      documentType: json['document_type'] as String,
      filePath: json['file_path'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      propertyId: (json['property_id'] as num).toInt(),
    );
  }
}
