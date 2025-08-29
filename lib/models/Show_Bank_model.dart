// models/office_model.dart

class ShowBankModel {
  final Bank data;

  const ShowBankModel({
    required this.data,
  });

  factory ShowBankModel.fromJson(Map<String, dynamic> json) {
    return ShowBankModel(
      data: Bank.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class Bank {
  final int id;
  final String name;
  final String accountNumber;
  final String? createdAt;
  final String? updatedAt;

  const Bank({
    required this.id,
    required this.name,
    required this.accountNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'] as int,
      name: json['name'] as String,
      accountNumber: json['account_number'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
