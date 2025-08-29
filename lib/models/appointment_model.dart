// models/appointment_model.dart

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
      mediatorId: int.parse((json['mediator_id'] ?? '0').toString()),
      userId: (json['user_id'] as num).toInt(),
      propertyId: int.parse((json['property_id'] ?? '0').toString()),
      status: json['status'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
