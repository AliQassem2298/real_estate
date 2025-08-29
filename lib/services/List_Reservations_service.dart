import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/List_Reservations_model.dart';

class ListReservationsService {
  Future<ListReservationsModel> listReservations() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/reservations',
      token: sharedPreferences!.getString('token'),
    );
    return ListReservationsModel.fromJson(data);
  }
}
