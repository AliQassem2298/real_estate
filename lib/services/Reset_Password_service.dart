// ignore_for_file: missing_required_param

import 'package:real_estate/helper/api.dart';
import 'package:real_estate/models/massage_model.dart';

class ResetPasswordService {
  Future<MassageModel> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/resetpassword',
      body: {
        "email": email,
        "otp": otp,
        "password": password,
        "password_confirmation": passwordConfirmation
      },
    );
    return MassageModel.fromJson(data);
  }
}