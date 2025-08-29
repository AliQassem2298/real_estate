// models/mediator_model.dart

class ListMediatorsModel {
  final List<MediatorModel> mediators;

  const ListMediatorsModel({
    required this.mediators,
  });

  factory ListMediatorsModel.fromJson(List<dynamic> jsonList) {
    final List<MediatorModel> mediators = jsonList
        .map((item) => MediatorModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return ListMediatorsModel(mediators: mediators);
  }
}

class MediatorModel {
  final int id;
  final String name;
  final String contactInfo;
  final String location;
  final String createdAt;
  final String updatedAt;

  // العلاقة: المواعيد
  final List<AppointmentModel> appointments;

  const MediatorModel({
    required this.id,
    required this.name,
    required this.contactInfo,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.appointments,
  });

  factory MediatorModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> appointmentsJson = json['appointments'] ?? [];
    final List<AppointmentModel> appointments = appointmentsJson
        .map((item) => AppointmentModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return MediatorModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      contactInfo: json['contact_info'] as String,
      location: json['location'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      appointments: appointments,
    );
  }
}

class AppointmentModel {
  final int id;
  final int mediatorId;
  final int userId;
  final int propertyId;
  final String status;
  final String date;
  final String time;
  final String createdAt;
  final String updatedAt;

  const AppointmentModel({
    required this.id,
    required this.mediatorId,
    required this.userId,
    required this.propertyId,
    required this.status,
    required this.date,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: (json['id'] as num).toInt(),
      mediatorId: (json['mediator_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      propertyId: (json['property_id'] as num).toInt(),
      status: json['status'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
