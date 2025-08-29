// services/appointment_service.dart

import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/appointment_model.dart';

class AppointmentService {
  final Api _api = Api();

  Future<AppointmentModel> createAppointment({
    required int mediatorId,
    required String date,
    required String time,
    required int propertyId,
  }) async {
    final Map<String, dynamic> body = {
      'mediator_id': mediatorId,
      'date': date,
      'time': time,
      'property_id': propertyId,
    };

    final Map<String, dynamic> response = await _api.post(
      url: '$baseUrl/appointments/create',
      body: body,
      token: sharedPreferences!.getString('token'),
    );

    return AppointmentModel.fromJson(response);
  }

  Future<List<AppointmentModel>> getAppointments() async {
    final List<dynamic> jsonResponse = await _api.get(
      url: '$baseUrl/appointments',
      token: sharedPreferences!.getString('token'),
    );

    return jsonResponse
        .map((item) => AppointmentModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
