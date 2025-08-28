// services/update_property_service.dart

import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/update_property_model.dart';

class UpdatePropertyService {
  final Api _api = Api();

  Future<UpdatePropertyResponse> updateProperty({
    required int id,
    required String typeId,
    required String subtypeId,
    required String title,
    required String status,
    required String description,
    required String price,
    required String area,
    String? floor,
    String? roomsCount,
    required String latitude,
    required String longitude,
  }) async {
    final body = {
      "type_id": typeId,
      "subtype_id": subtypeId,
      "title": title,
      "status": status,
      "description": description,
      "price": price,
      "area": area,
      if (floor != null) "floor": floor,
      if (roomsCount != null) "rooms_count": roomsCount,
      "latitude": latitude,
      "longitude": longitude,
      // الحقول الثابتة في المثال (يمكن تغييرها لاحقًا)
      "has_pool": 0,
      "has_garden": 0,
      "has_elevator": 0,
      "solar_energy": 0,
      // يمكن إضافة features, nearby_services إذا حاب
    };

    final token = sharedPreferences!.getString('token');
    if (token == null) {
      throw 'التوكن غير موجود. قم بتسجيل الدخول مجددًا.';
    }

    final data = await _api.post(
      url: '$baseUrl/property/update/$id', // الرابط ديناميكي
      body: body,
      token: token,
    );

    return UpdatePropertyResponse.fromJson(data);
  }
}
