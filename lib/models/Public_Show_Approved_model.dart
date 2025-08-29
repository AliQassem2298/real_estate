// models/property_model.dart

class PublicShowApprovedModel {
  final PropertyModel data;

  const PublicShowApprovedModel({
    required this.data,
  });

  factory PublicShowApprovedModel.fromJson(Map<String, dynamic> json) {
    dynamic raw = json['data'];
    if (raw == null) {
      throw Exception("No data found in response");
    }
    if (raw is List && raw.isNotEmpty) {
      raw = raw.first;
    }
    if (raw is! Map<String, dynamic>) {
      throw Exception("Unexpected 'data' shape: not an object");
    }
    return PublicShowApprovedModel(
      data: PropertyModel.fromJson(raw),
    );
  }
}

class PropertyModel {
  final int id;
  final int userId;
  final int typeId;
  final int subtypeId;
  final String title;
  final String status;
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
  final String? description;
  final String? features;
  final String? nearbyServices;
  final bool approved;
  final String createdAt;
  final String updatedAt;
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
    this.description,
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
    final dynamic typeRaw = json['type'];
    final dynamic subtypeRaw = json['subtype'];

    TypeModel safeType;
    if (typeRaw is Map<String, dynamic>) {
      safeType = TypeModel.fromJson(typeRaw);
    } else if (typeRaw is List &&
        typeRaw.isNotEmpty &&
        typeRaw.first is Map<String, dynamic>) {
      safeType = TypeModel.fromJson(typeRaw.first as Map<String, dynamic>);
    } else {
      safeType = const TypeModel(
          id: 0, type: 'غير معروف', createdAt: '', updatedAt: '');
    }

    SubtypeModel safeSubtype;
    if (subtypeRaw is Map<String, dynamic>) {
      safeSubtype = SubtypeModel.fromJson(subtypeRaw);
    } else if (subtypeRaw is List &&
        subtypeRaw.isNotEmpty &&
        subtypeRaw.first is Map<String, dynamic>) {
      safeSubtype =
          SubtypeModel.fromJson(subtypeRaw.first as Map<String, dynamic>);
    } else {
      safeSubtype = const SubtypeModel(
          id: 0, subtype: 'غير معروف', typeId: 0, createdAt: '', updatedAt: '');
    }

    return PropertyModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      typeId: (json['type_id'] as num).toInt(),
      subtypeId: (json['subtype_id'] as num).toInt(),
      title: json['title'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      price: json['price'].toString(),
      area: (json['area'] as num).toInt(),
      floor: json['floor'] != null ? (json['floor'] as num).toInt() : null,
      roomsCount: json['rooms_count'] != null
          ? (json['rooms_count'] as num).toInt()
          : null,
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
      type: safeType,
      subtype: safeSubtype,
      images: (json['images'] as List?)
              ?.map((e) => ImageModel.fromJson(e))
              .toList() ??
          <ImageModel>[],
      documents: (json['documents'] as List?)
              ?.map((e) => DocumentModel.fromJson(e))
              .toList() ??
          <DocumentModel>[],
    );
  }
}

class TypeModel {
  final int id;
  final String type;
  final String createdAt;
  final String updatedAt;
  const TypeModel(
      {required this.id,
      required this.type,
      required this.createdAt,
      required this.updatedAt});
  factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
        id: (json['id'] as num).toInt(),
        type: json['type'] as String,
        createdAt: (json['created_at'] ?? '').toString(),
        updatedAt: (json['updated_at'] ?? '').toString(),
      );
}

class SubtypeModel {
  final int id;
  final String subtype;
  final int typeId;
  final String createdAt;
  final String updatedAt;
  const SubtypeModel(
      {required this.id,
      required this.subtype,
      required this.typeId,
      required this.createdAt,
      required this.updatedAt});
  factory SubtypeModel.fromJson(Map<String, dynamic> json) => SubtypeModel(
        id: (json['id'] as num).toInt(),
        subtype: json['subtype'] as String,
        typeId: (json['type_id'] as num).toInt(),
        createdAt: (json['created_at'] ?? '').toString(),
        updatedAt: (json['updated_at'] ?? '').toString(),
      );
}

class ImageModel {
  final int id;
  final String imagePath;
  final int propertyId;
  final String createdAt;
  final String updatedAt;
  const ImageModel(
      {required this.id,
      required this.imagePath,
      required this.propertyId,
      required this.createdAt,
      required this.updatedAt});
  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: (json['id'] as num).toInt(),
        imagePath: json['image_path'] as String,
        propertyId: (json['property_id'] as num).toInt(),
        createdAt: (json['created_at'] ?? '').toString(),
        updatedAt: (json['updated_at'] ?? '').toString(),
      );
}

class DocumentModel {
  final int id;
  final String documentType;
  final String filePath;
  final String createdAt;
  final String updatedAt;
  final int propertyId;
  const DocumentModel(
      {required this.id,
      required this.documentType,
      required this.filePath,
      required this.createdAt,
      required this.updatedAt,
      required this.propertyId});
  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: (json['id'] as num).toInt(),
        documentType: json['document_type'] as String,
        filePath: json['file_path'] as String,
        createdAt: (json['created_at'] ?? '').toString(),
        updatedAt: (json['updated_at'] ?? '').toString(),
        propertyId: (json['property_id'] as num).toInt(),
      );
}
