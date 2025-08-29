// services/ownership_document_service.dart

import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/List_Reservations_model.dart';

class OwnershipDocumentService {
  final Api _api = Api();

  Future<List<OwnershipDocumentModel>> getDocuments(int reservationId) async {
    final List<dynamic> jsonResponse = await _api.get(
      url: '$baseUrl/reservations/$reservationId/documents',
      token: sharedPreferences!.getString('token'),
    );

    return jsonResponse
        .map((item) =>
            OwnershipDocumentModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<OwnershipDocumentModel> uploadDocument({
    required int reservationId,
    required String filePath,
    required String fileName,
    required String documentType,
  }) async {
    final Map<String, dynamic> body = {
      'reservation_id': reservationId,
      'document_type': documentType,
    };

    final response = await _api.postImage(
      url: '$baseUrl/documents/create',
      filePath: filePath,
      fileName: fileName,
      fileKey: 'document',
      body: body,
      token: sharedPreferences!.getString('token'),
    );

    return OwnershipDocumentModel.fromJson(response);
  }
}
