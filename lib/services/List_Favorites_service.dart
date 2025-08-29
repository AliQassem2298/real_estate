import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/List_Favorites_model.dart';

class ListFavoritesService {
  Future<ListFavoritesModel> listFavorites() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/favorites/get',
      token: sharedPreferences!.getString('token'),
    );
    return ListFavoritesModel.fromJson(data);
  }
}
