import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/massage_model.dart';

class DeleteAccountService {
  Future<MassageModel> deleteAccount({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/delete-account',
      body: {
        "identifier": email,
        "password": password,
      },
      token: sharedPreferences!.getString("token"),
    );
    return MassageModel.fromJson(data);
  }
}
