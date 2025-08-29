// models/wallet_model.dart

class ViewWalletModel {
  final String balance;
  final List<TransactionModel> transactions;

  const ViewWalletModel({
    required this.balance,
    required this.transactions,
  });

  factory ViewWalletModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> transactionsJson = json['transactions'] ?? [];
    final List<TransactionModel> transactions = transactionsJson
        .map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return ViewWalletModel(
      balance: json['balance'] as String,
      transactions: transactions,
    );
  }
}

class TransactionModel {
  final int id;
  final String amount;
  final String method;
  final String referenceNumber;
  final bool approved;
  final String createdAt;
  final String updatedAt;
  final int walletId;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.method,
    required this.referenceNumber,
    required this.approved,
    required this.createdAt,
    required this.updatedAt,
    required this.walletId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: (json['id'] as num).toInt(),
      amount: json['amount'] as String,
      method: json['method'] as String,
      referenceNumber: json['reference_number'] as String,
      approved: _parseBool(json['approved']),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      walletId: (json['wallet_id'] as num).toInt(),
    );
  }

  // دالة مساعدة لتحويل القيم إلى bool
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final lower = value.toLowerCase();
      return ['true', '1', 'yes'].contains(lower);
    }
    return false;
  }
}
