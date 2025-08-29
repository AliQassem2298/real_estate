import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/Get_Image_URL_model.dart';

class GetImageUrlService {
  Future<GetImageUrlModel> getImageUrl({required int id}) async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/property/image/geturl/$id',
      token: sharedPreferences!.getString('token'),
    );
    return GetImageUrlModel.fromJson(data);
  }
}
