import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/Profile_model.dart';

class ProfileService {
  Future<ProfileModel> profile() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/user',
      token: sharedPreferences!.getString('token'),
    );
    return ProfileModel.fromJson(data);
  }
}
