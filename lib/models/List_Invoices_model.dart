// models/invoice_model.dart

class ListInvoicesModel {
  final List<InvoiceModel> invoices;

  const ListInvoicesModel({
    required this.invoices,
  });

  factory ListInvoicesModel.fromJson(List<dynamic> jsonList) {
    final List<InvoiceModel> invoices = jsonList
        .map((item) => InvoiceModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return ListInvoicesModel(invoices: invoices);
  }
}

class InvoiceModel {
  final int id;
  final int paymentId;
  final String amount;
  final String status;
  final String? notes;
  final String createdAt;
  final String updatedAt;

  // العلاقة
  final PaymentModel payment;

  const InvoiceModel({
    required this.id,
    required this.paymentId,
    required this.amount,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.payment,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: (json['id'] as num).toInt(),
      paymentId: (json['payment_id'] as num).toInt(),
      amount: json['amount'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      payment: PaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
    );
  }
}

class PaymentModel {
  final int id;
  final String amount;
  final String status;
  final String paymentMethod;
  final String paymentReference;
  final String date;
  final String createdAt;
  final String updatedAt;
  final int reservationId;
  final int bankId;

  const PaymentModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.paymentReference,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.reservationId,
    required this.bankId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: (json['id'] as num).toInt(),
      amount: json['amount'] as String,
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentReference: json['payment_reference'] as String,
      date: json['date'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      reservationId: (json['reservation_id'] as num).toInt(),
      bankId: (json['bank_id'] as num).toInt(),
    );
  }
}
