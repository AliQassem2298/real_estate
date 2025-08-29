// services/add_image_service.dart

import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/massage_model.dart';

class AddImageService {
  final Api _api = Api();

  Future<MassageModel> addImage({
    required int propertyId,
    required String filePath,
    required String fileName,
  }) async {
    final url =
        '$baseUrl/property/image/add/$propertyId'; // يحتوي على id في الرابط

    try {
      final data = await _api.postImage(
        url: url,
        filePath: filePath,
        fileName: fileName,
        fileKey: 'image', // اسم الحقل في الـ form-data
        body: {
          'property_id': propertyId, // نقله كحقل نصي
        },
        token: sharedPreferences!.getString('token'),
      );

      return MassageModel.fromJson(data);
    } catch (e) {
      rethrow; // أو عدّل حسب الحاجة
    }
  }
}
