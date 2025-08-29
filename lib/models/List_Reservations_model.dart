// models/reservation_model.dart

class ListReservationsModel {
  final List<ReservationModel> reservation;

  const ListReservationsModel({
    required this.reservation,
  });

  factory ListReservationsModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['Reservation'] ?? [];
    final List<ReservationModel> reservations = data
        .map((item) => ReservationModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return ListReservationsModel(reservation: reservations);
  }
}

class ReservationModel {
  final int id;
  final int userId;
  final int propertyId;
  final String status;
  final String depositAmount;
  final String createdAt;
  final String updatedAt;

  // العلاقات
  final UserModel user;
  final PropertyModel property;
  final List<PaymentModel> payments;
  final List<OwnershipDocumentModel> ownershipDocuments;

  const ReservationModel({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.status,
    required this.depositAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.property,
    required this.payments,
    required this.ownershipDocuments,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> paymentsJson = json['payments'] ?? [];
    final List<dynamic> docsJson = json['ownership_documents'] ?? [];

    return ReservationModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      propertyId: (json['property_id'] as num).toInt(),
      status: json['status'] as String,
      depositAmount: json['deposit_amount'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      property:
          PropertyModel.fromJson(json['property'] as Map<String, dynamic>),
      payments: paymentsJson
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      ownershipDocuments: docsJson
          .map(
              (e) => OwnershipDocumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final int phoneNumber;
  final int isVerified;
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
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      phoneNumber: (json['phone_number'] as num).toInt(),
      isVerified: (json['is_verified'] as num).toInt(),
      location: json['location'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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
    );
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final lower = value.toLowerCase();
      return ['true', '1', 'yes'].contains(lower);
    }
    return false;
  }
}

class PaymentModel {
  final int id;
  final String amount;
  final String status;
  final String paymentMethod;
  final String paymentReference;
  final String date;
  final String createdAt;
  final String updatedAt;
  final int reservationId;
  final int bankId;

  const PaymentModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.paymentReference,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.reservationId,
    required this.bankId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: (json['id'] as num).toInt(),
      amount: json['amount'] as String,
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentReference: json['payment_reference'] as String,
      date: json['date'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      reservationId: (json['reservation_id'] as num).toInt(),
      bankId: (json['bank_id'] as num).toInt(),
    );
  }
}

class OwnershipDocumentModel {
  final int id;
  final String documentType;
  final String? documentUrl;
  final String? uploadAt;
  final String createdAt;
  final String updatedAt;
  final int reservationId;

  const OwnershipDocumentModel({
    required this.id,
    required this.documentType,
    this.documentUrl,
    this.uploadAt,
    required this.createdAt,
    required this.updatedAt,
    required this.reservationId,
  });

  factory OwnershipDocumentModel.fromJson(Map<String, dynamic> json) {
    return OwnershipDocumentModel(
      id: (json['id'] as num).toInt(),
      documentType: json['document_type'] as String,
      documentUrl: json['document_url'] as String?,
      uploadAt: json['upload_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      reservationId: (json['reservation_id'] as int),
    );
  }
}
