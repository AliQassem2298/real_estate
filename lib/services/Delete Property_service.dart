import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';

class DeletepropertyService {
  Future<void> deleteproperty({required int id}) async {
    await Api().delete(
      url: '$baseUrl/property/delete/$id',
      token: sharedPreferences!.getString('token'),
    );
  }
}
