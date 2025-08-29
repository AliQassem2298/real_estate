import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/View_Wallet_model.dart';

class ViewWalletService {
  Future<ViewWalletModel> viewWallet() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/wallet',
      token: sharedPreferences!.getString('token'),
    );
    return ViewWalletModel.fromJson(data);
  }
}
