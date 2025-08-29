import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/Deposit_to_Wallet_model.dart';

class WithdrawFromWalletService {
  Future<DepositToWalletModel> withdrawFromWallet({
    required int amount,
    required String paymentMethod,
    required String referenceNumber,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/wallet/withdraw',
      body: {
        "amount": amount,
        "payment_method": paymentMethod,
        "reference_number": referenceNumber
      },
      token: sharedPreferences!.getString("token"),
    );

    return DepositToWalletModel.fromJson(data);
  }
}
