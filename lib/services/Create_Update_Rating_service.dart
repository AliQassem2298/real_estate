import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/Create/Create_Update_Rating_model.dart';

class CreateUpdateRatingService {
  Future<CreateUpdateRatingModel> createUpdateRating({
    required int propertyId,
    required int rating,
    required String comment,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/ratings/store',
      body: {
        "property_id": propertyId,
        "rating": rating,
        "comment": comment,
      },
      token: sharedPreferences!.getString("token"),
    );
    return CreateUpdateRatingModel.fromJson(data);
  }
}
