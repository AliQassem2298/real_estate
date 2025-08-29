import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';

class DeleteRatingService {
  Future<void> deleteRating({required int id}) async {
    await Api().delete(
      url: '$baseUrl/ratings/delete/$id',
      token: sharedPreferences!.getString('token'),
    );
  }
}
