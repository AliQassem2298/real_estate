import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/massage_model.dart';

class AddDocumentService {
  final Api _api = Api();

  Future<MassageModel> addDocument({
    required int propertyId,
    required String filePath,
    required String fileName,
    required String documentType,
  }) async {
    final url = '$baseUrl/property/document/add/$propertyId';
    final data = await _api.postImage(
      url: url,
      filePath: filePath,
      fileName: fileName,
      fileKey: 'file_path', // backend expects this key name for file
      body: {
        'document_type': documentType,
      },
      token: sharedPreferences!.getString('token'),
    );
    return MassageModel.fromJson(data);
  }
}
