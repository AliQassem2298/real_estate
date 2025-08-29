class DepositToWalletModel {
  final String message;
  final int balance;

  DepositToWalletModel({required this.message, required this.balance});
  factory DepositToWalletModel.fromJson(Map<String, dynamic> json) {
    return DepositToWalletModel(
        message: json['message'], balance: json['balance']);
  }
}
