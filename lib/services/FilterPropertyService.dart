// services/filter_property_service.dart

import 'package:real_estate/helper/api.dart';
import 'package:real_estate/models/Filter_Properties.dart';

class FilterPropertyService {
  final Api _api = Api();

  Future<FilterPropertyResponse> filterProperties({
    int? userId,
    int? typeId,
    int? subtypeId,
    String? title,
    String? status,
    num? minPrice,
    num? maxPrice,
    num? minArea,
    num? maxArea,
    int? minFloor,
    int? maxFloor,
    int? minCount,
    int? maxCount,
    bool? hasPool,
    bool? hasGarden,
    bool? hasElevator,
    bool? solarEnergy,
    int? perPage = 15,
  }) async {
    final body = {
      if (userId != null) "user_id": userId,
      if (typeId != null) "type_id": typeId,
      if (subtypeId != null) "subtype_id": subtypeId,
      if (title != null) "title": title,
      if (status != null) "status": status,
      if (minPrice != null) "min_price": minPrice,
      if (maxPrice != null) "max_price": maxPrice,
      if (minArea != null) "min_area": minArea,
      if (maxArea != null) "max_area": maxArea,
      if (minFloor != null) "min_floor": minFloor,
      if (maxFloor != null) "max_floor": maxFloor,
      if (minCount != null) "min_count": minCount,
      if (maxCount != null) "max_count": maxCount,
      if (hasPool != null) "has_pool": hasPool ? 1 : 0,
      if (hasGarden != null) "has_garden": hasGarden ? 1 : 0,
      if (hasElevator != null) "has_elevator": hasElevator ? 1 : 0,
      if (solarEnergy != null) "solar_energy": solarEnergy ? 1 : 0,
      "per_page": perPage,
    };

    final data = await _api.post(
      url: '$baseUrl/property/filter',
      body: body,
    );

    return FilterPropertyResponse.fromJson(data);
  }
}
