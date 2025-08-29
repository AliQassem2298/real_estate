import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';

class DeleteFavoriteService {
  Future<void> deleteFavorite({required int id}) async {
    await Api().delete(
      url: '$baseUrl/favorites/delete/$id',
      token: sharedPreferences!.getString("token"),
    );
  }
}
