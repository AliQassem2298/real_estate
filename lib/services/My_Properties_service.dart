import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/My_Properties_model.dart';

class MyPropertiesService {
  Future<MyPropertiesModel> myProperties() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/property/me',
      token: sharedPreferences!.getString('token'),
    );
    return MyPropertiesModel.fromJson(data);
  }
}
