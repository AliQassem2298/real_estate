import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';

class DeleteImageService {
  Future<void> deleteImage({
    required int id,
  }) async {
    Map<String, dynamic> data = await Api().delete(
      url: '$baseUrl/property/image/delete/$id',
      token: sharedPreferences!.getString("token"),
    );
  }
}
