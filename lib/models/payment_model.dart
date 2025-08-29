class PaymentModel {
  final int id;
  final String reservationId;
  final String bankId;
  final String amount;
  final String status;
  final String paymentMethod;
  final String paymentReference;
  final String date;
  final String createdAt;
  final String updatedAt;

  const PaymentModel({
    required this.id,
    required this.reservationId,
    required this.bankId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.paymentReference,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: (json['id'] as num).toInt(),
      reservationId: json['reservation_id'].toString(),
      bankId: json['bank_id'].toString(),
      amount: json['amount'].toString(),
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentReference: json['payment_reference'] as String,
      date: json['date'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'payment_method': paymentMethod,
      'reservation_id': reservationId,
      'bank_id': bankId,
      'payment_reference': paymentReference,
      'date': date,
      'status': status,
    };
  }
}
