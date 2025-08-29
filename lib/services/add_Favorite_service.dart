import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/massage_model.dart';

class AddFavoriteService {
  Future<MassageModel> addFavorite({
    required int propertyId,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/favorites/store',
      body: {
        "property_id": propertyId,
      },
      token: sharedPreferences!.getString("token"),
    );
    return MassageModel.fromJson(data);
  }
}
