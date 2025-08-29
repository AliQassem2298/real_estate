import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/List_Ratings_for_Property_model.dart';

class ListRatingsForPropertyService {
  Future<ListRatingsForPropertyModel> listRatingsForProperty(
      {required int id}) async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/property/ratings/$id',
      token: sharedPreferences!.getString('token'),
    );
    return ListRatingsForPropertyModel.fromJson(data);
  }
}
