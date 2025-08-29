import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/Show_Bank_model.dart';

class ShowBankService {
  Future<ShowBankModel> showBank({required int id}) async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/banks/show/$id',
      token: sharedPreferences!.getString('token'),
    );
    return ShowBankModel.fromJson(data);
  }
}
