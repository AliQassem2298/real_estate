import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/List_Workshops_model.dart';

class ListWorkshopsService {
  Future<ListWorkshopsModel> myProperties() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/workshops/get',
      token: sharedPreferences!.getString('token'),
    );
    return ListWorkshopsModel.fromJson(data);
  }
}
