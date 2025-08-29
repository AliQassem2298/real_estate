import 'package:flutter/material.dart';
import 'package:real_estate/services/Show_Bank_service.dart';
import 'package:real_estate/models/Show_Bank_model.dart';

class BankDetailPage extends StatefulWidget {
  final int bankId;
  const BankDetailPage({super.key, required this.bankId});

  @override
  State<BankDetailPage> createState() => _BankDetailPageState();
}

class _BankDetailPageState extends State<BankDetailPage> {
  final ShowBankService _service = ShowBankService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل البنك')),
      body: FutureBuilder<ShowBankModel>(
        future: _service.showBank(id: widget.bankId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          final bank = snapshot.data!.data;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                title: const Text('الاسم'),
                subtitle: Text(bank.name),
              ),
              ListTile(
                title: const Text('رقم الحساب'),
                subtitle: Text(bank.accountNumber),
              ),
            ],
          );
        },
      ),
    );
  }
}
