// services/create_property_service.dart

import 'package:real_estate/helper/api.dart';
import 'package:real_estate/models/create_property_model.dart'; // نفترض أنك سميته كذا
import 'package:real_estate/main.dart'; // للوصول إلى sharedPreferences

class CreatePropertyService {
  final Api _api = Api();

  Future<CreatePropertyResponse> createProperty({
    required String typeId,
    required String subtypeId,
    required String title,
    required String status, // 'rent', 'sale', 'reserved'
    required String description,
    required String price,
    required String area,
    String? floor,
    String? roomsCount,
    required String latitude,
    required String longitude,
    bool hasPool = false,
    bool hasGarden = false,
    bool hasElevator = false,
    bool solarEnergy = false,
    String? features,
    String? nearbyServices,
  }) async {
    // جمع البيانات
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
      "has_pool": hasPool ? 1 : 0,
      "has_garden": hasGarden ? 1 : 0,
      "has_elevator": hasElevator ? 1 : 0,
      "solar_energy": solarEnergy ? 1 : 0,
      if (features != null) "features": features,
      if (nearbyServices != null) "nearby_services": nearbyServices,
    };

    // الحصول على التوكن
    final token = sharedPreferences!.getString('token');
    if (token == null) {
      throw 'لم يتم العثور على توكن المستخدم';
    }

    // إرسال الطلب
    final data = await _api.post(
      url: '$baseUrl/property/create',
      body: body,
      token: token,
    );

    // تحويل الناتج إلى نموذج
    return CreatePropertyResponse.fromJson(data);
  }
}
