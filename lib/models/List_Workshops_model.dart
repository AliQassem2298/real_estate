// models/maintenance_office_model.dart

class ListWorkshopsModel {
  final List<WorkshopModel> data;

  const ListWorkshopsModel({
    required this.data,
  });

  factory ListWorkshopsModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonData = json['data'] ?? [];
    final List<WorkshopModel> offices =
        jsonData.map((item) => WorkshopModel.fromJson(item)).toList();

    return ListWorkshopsModel(
      data: offices,
    );
  }
}

class WorkshopModel {
  final int id;
  final String name;
  final String workType;
  final String phoneNumber;
  final String location;
  final String createdAt;
  final String updatedAt;

  const WorkshopModel({
    required this.id,
    required this.name,
    required this.workType,
    required this.phoneNumber,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkshopModel.fromJson(Map<String, dynamic> json) {
    return WorkshopModel(
      id: json['id'] as int,
      name: json['name'] as String,
      workType: json['work_type'] as String,
      phoneNumber: json['phone_number'] as String,
      location: json['location'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
