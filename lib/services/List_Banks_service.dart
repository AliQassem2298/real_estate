import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/List_Banks_model.dart';

class ListBanksService {
  Future<ListBanksModel> listBanks() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/banks',
      token: sharedPreferences!.getString('token'),
    );
    return ListBanksModel.fromJson(data);
  }
}
