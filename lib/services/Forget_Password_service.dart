// ignore_for_file: missing_required_param

import 'package:real_estate/helper/api.dart';
import 'package:real_estate/models/massage_model.dart';

class ForgetPasswordService {
  Future<MassageModel> forgetPassword({
    required String email,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/forgetpassword',
      body: {
        "email": email,
      },
    );
    return MassageModel.fromJson(data);
  }
}
