import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/create_payment_model.dart';

class CreatePaymentService {
  Future<CreatePaymentModel> createPayment({
    required String amount,
    required String paymentMethod,
    required String reservationId,
    required String bankId,
    required String paymentReference,
    required String date,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/payments/create',
      body: {
        "amount": amount,
        "payment_method": paymentMethod,
        "reservation_id": reservationId,
        "bank_id": bankId,
        "payment_reference": paymentReference,
        "date": date,
        "status": "pending",
      },
      token: sharedPreferences!.getString("token"),
    );

    return CreatePaymentModel.fromJson(data);
  }
}
