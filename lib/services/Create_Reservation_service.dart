import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/Create_Reservation_model.dart';

class CreateReservationService {
  Future<CreateReservationModel> createReservation({
    required int propertyId,
    required int depositAmount,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/reservations/create',
      body: {
        "property_id": propertyId,
        "deposit_amount": depositAmount,
      },
      token: sharedPreferences!.getString("token"),
    );
    return CreateReservationModel.fromJson(data);
  }
}
