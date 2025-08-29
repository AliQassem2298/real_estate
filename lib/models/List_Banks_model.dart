// models/office_model.dart

class ListBanksModel {
  final List<BankModel> data;

  const ListBanksModel({
    required this.data,
  });

  factory ListBanksModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonData = json['data'] ?? [];
    final List<BankModel> offices =
        jsonData.map((item) => BankModel.fromJson(item)).toList();

    return ListBanksModel(
      data: offices,
    );
  }
}

class BankModel {
  final int id;
  final String name;
  final String accountNumber;
  final String? createdAt;
  final String? updatedAt;

  const BankModel({
    required this.id,
    required this.name,
    required this.accountNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'] as int,
      name: json['name'] as String,
      accountNumber: json['account_number'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
