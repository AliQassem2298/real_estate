// services/ListMediatorsService.dart

import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/List_Mediators_model.dart';

class ListMediatorsService {
  Future<List<MediatorModel>> listMediators() async {
    final List<dynamic> jsonResponse = await Api().get(
      url: '$baseUrl/mediators',
      token: sharedPreferences!.getString('token'),
    );

    return jsonResponse
        .map((item) => MediatorModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
