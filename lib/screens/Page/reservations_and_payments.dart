// screens/reservations_and_payments_page.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:real_estate/models/List_Reservations_model.dart';
import 'package:real_estate/models/View_Wallet_model.dart';
import 'package:real_estate/models/List_Banks_model.dart';
import 'package:real_estate/services/List_Reservations_service.dart';
import 'package:real_estate/services/Create_Reservation_service.dart';
import 'package:real_estate/services/List_Banks_service.dart';
import 'package:real_estate/services/Upload_Document_service.dart';
import 'package:real_estate/services/View_Wallet_service.dart';
import 'package:real_estate/services/create_payment_service.dart';
import 'package:real_estate/constans/color.dart';

class ReservationsAndPaymentsPage extends StatefulWidget {
  final int propertyId;
  final String propertyTitle;
  final String propertyPrice;

  const ReservationsAndPaymentsPage({
    super.key,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyPrice,
  });

  @override
  State<ReservationsAndPaymentsPage> createState() =>
      _ReservationsAndPaymentsPageState();
}

class _ReservationsAndPaymentsPageState
    extends State<ReservationsAndPaymentsPage> {
  final ListReservationsService _reservationsService =
      ListReservationsService();
  final CreateReservationService _createReservationService =
      CreateReservationService();
  final ViewWalletService _walletService = ViewWalletService();
  final CreatePaymentService _paymentService = CreatePaymentService();
  final ListBanksService _banksService = ListBanksService();
  final OwnershipDocumentService _documentService = OwnershipDocumentService();

  late Future<ListReservationsModel> _reservationsFuture;
  late Future<ViewWalletModel> _walletFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _reservationsFuture = _reservationsService.listReservations();
    _walletFuture = _walletService.viewWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "حجوزات ودفعات - ${widget.propertyTitle}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColor.blue,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _refreshData();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildWalletHeader(),
              _buildQuickActions(),
              _buildReservationsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletHeader() {
    return FutureBuilder<ViewWalletModel>(
      future: _walletFuture,
      builder: (context, snapshot) {
        final balance = snapshot.hasData ? snapshot.data!.balance : "...";
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.blue,
                AppColor.blue.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "رصيد المحفظة",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$balance ريال",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "سعر العقار: ${widget.propertyPrice} ريال",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () => _showCreateReservationDialog(),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text("إنشاء حجز جديد"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildReservationsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "الحجوزات",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<ListReservationsModel>(
            future: _reservationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.blue),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: Colors.red[300]),
                      const SizedBox(height: 8),
                      Text("خطأ في تحميل الحجوزات",
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.reservation.isEmpty) {
                return _buildEmptyReservations();
              }

              final reservations = snapshot.data!.reservation;
              return Column(
                children: reservations
                    .map((reservation) => _buildReservationCard(reservation))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyReservations() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.bookmark_border, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text("لا توجد حجوزات بعد",
              style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text("قم بإنشاء حجز جديد للبدء",
              style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildReservationCard(ReservationModel reservation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
            color: _getStatusColor(reservation.status).withOpacity(0.3)),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(reservation.status).withOpacity(0.1),
          child:
              Icon(Icons.bookmark, color: _getStatusColor(reservation.status)),
        ),
        title: Text(
          "حجز #${reservation.id}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مبلغ الحجز: ${reservation.depositAmount} ريال",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(reservation.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusText(reservation.status),
                style: TextStyle(
                  fontSize: 12,
                  color: _getStatusColor(reservation.status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الدفعات (${reservation.payments.length})",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                if (reservation.payments.isEmpty)
                  Text(
                    "لا توجد دفعات بعد",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  )
                else
                  ...reservation.payments
                      .map((payment) => _buildPaymentCard(payment)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showCreatePaymentDialog(reservation.id),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("إضافة دفعة"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.blue,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      _uploadDocument(reservation.id, 'reservation'),
                  icon: const Icon(Icons.upload, size: 18),
                  label: const Text("رفع مستند للحجز"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(PaymentModel payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: _getPaymentStatusColor(payment.status).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.payment, color: AppColor.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "مبلغ: ${payment.amount} ريال",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  "طريقة الدفع: ${payment.paymentMethod}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Text(
                  "التاريخ: ${payment.date}",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getPaymentStatusColor(payment.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getPaymentStatusText(payment.status),
              style: TextStyle(
                fontSize: 12,
                color: _getPaymentStatusColor(payment.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _uploadDocument(int id, String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    try {
      await _documentService.uploadDocument(
        reservationId: id,
        filePath: pickedFile.path,
        fileName: 'doc_${DateTime.now().millisecondsSinceEpoch}.pdf',
        documentType: type,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم رفع المستند للـ $type #$id")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل الرفع: $e")),
      );
    }
  }

  void _showCreateReservationDialog() {
    final depositController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_circle, color: Colors.green),
              SizedBox(width: 8),
              Text("إنشاء حجز جديد"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: depositController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "مبلغ الحجز",
                  hintText: "أدخل مبلغ الحجز",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "سيتم إنشاء حجز للعقار: ${widget.propertyTitle}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (depositController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("يرجى إدخال مبلغ الحجز"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setDialogState(() => isLoading = true);

                      try {
                        await _createReservationService.createReservation(
                          propertyId: widget.propertyId,
                          depositAmount: int.parse(depositController.text),
                        );

                        Navigator.pop(context);

                        setState(() {
                          _refreshData();
                        });

                        _walletFuture = _walletService.viewWallet();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم إنشاء الحجز بنجاح"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        setDialogState(() => isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("خطأ: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("إنشاء"),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePaymentDialog(int reservationId) {
    final amountController = TextEditingController();
    final paymentMethodController = TextEditingController();
    final referenceController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    int? selectedBankId; // ✅ تم التصحيح: استخدام int بدل BankModel
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.payment, color: Colors.blue),
              SizedBox(width: 8),
              Text("إضافة دفعة جديدة"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "المبلغ",
                  hintText: "أدخل المبلغ",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: paymentMethodController,
                decoration: const InputDecoration(
                  labelText: "طريقة الدفع",
                  hintText: "مثال: بطاقة ائتمان، تحويل بنكي",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: referenceController,
                decoration: const InputDecoration(
                  labelText: "رقم المرجع",
                  hintText: "رقم العملية أو المرجع",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: AppColor.blue),
                title: const Text("التاريخ"),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd').format(selectedDate),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null && picked != selectedDate) {
                    setDialogState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.access_time, color: AppColor.blue),
                title: const Text("الوقت"),
                subtitle: Text(
                  selectedTime
                      .format(context)
                      .replaceAll('ص', '')
                      .replaceAll('م', '')
                      .trim(),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null && picked != selectedTime) {
                    setDialogState(() {
                      selectedTime = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              FutureBuilder<ListBanksModel>(
                future: _banksService.listBanks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "خطأ في تحميل البنوك",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final banks = snapshot.data!.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "اختر البنك",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColor.blue.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[50],
                        ),
                        child: DropdownButtonFormField<int>(
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          value: selectedBankId,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            hintText: "اختر البنك",
                          ),
                          items: banks.map((bank) {
                            return DropdownMenuItem<int>(
                              value: bank.id,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.account_balance,
                                    color: AppColor.blue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${bank.name}-${bank.accountNumber}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (int? value) {
                            setDialogState(() {
                              selectedBankId = value;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (amountController.text.isEmpty ||
                          paymentMethodController.text.isEmpty ||
                          referenceController.text.isEmpty ||
                          selectedBankId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("يرجى ملء جميع الحقول واختيار البنك"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setDialogState(() => isLoading = true);

                      try {
                        await _paymentService.createPayment(
                          amount: amountController.text,
                          paymentMethod: paymentMethodController.text,
                          reservationId: reservationId.toString(),
                          bankId: selectedBankId.toString(),
                          paymentReference: referenceController.text,
                          date: DateFormat('yyyy-MM-dd').format(selectedDate),
                        );

                        Navigator.pop(context);

                        setState(() {
                          _refreshData();
                        });

                        _walletFuture = _walletService.viewWallet();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم إنشاء الدفعة بنجاح"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        setDialogState(() => isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("خطأ: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.blue,
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("إنشاء"),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColor.blue;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'مؤكد';
      case 'pending':
        return 'في الانتظار';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return AppColor.blue;
    }
  }

  String _getPaymentStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'مكتمل';
      case 'pending':
        return 'في الانتظار';
      case 'failed':
        return 'فشل';
      default:
        return status;
    }
  }
}
