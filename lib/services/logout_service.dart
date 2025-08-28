import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/massage_model.dart';

class LogoutService {
  Future<MassageModel> logout() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/logout',
      token: sharedPreferences!.getString('token'),
    );
    return MassageModel.fromJson(data);
  }
}
