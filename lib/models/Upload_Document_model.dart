// models/ownership_document_model.dart

class OwnershipDocumentModel {
  final int id;
  final int reservationId;
  final String documentType;
  final String? uploadAt;
  final String createdAt;
  final String updatedAt;

  const OwnershipDocumentModel({
    required this.id,
    required this.reservationId,
    required this.documentType,
    this.uploadAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OwnershipDocumentModel.fromJson(Map<String, dynamic> json) {
    return OwnershipDocumentModel(
      id: (json['id'] as num).toInt(),
      reservationId: int.parse((json['reservation_id'] ?? '0').toString()),
      documentType: json['document_type'] as String,
      uploadAt: json['upload_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
