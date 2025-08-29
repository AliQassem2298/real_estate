import 'package:flutter/material.dart';
import 'package:real_estate/services/List_Banks_service.dart';
import 'package:real_estate/models/List_Banks_model.dart';
import 'bank_detail.dart';

class BanksPage extends StatefulWidget {
  const BanksPage({super.key});

  @override
  State<BanksPage> createState() => _BanksPageState();
}

class _BanksPageState extends State<BanksPage> {
  final ListBanksService _service = ListBanksService();
  late Future<ListBanksModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.listBanks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البنوك')),
      body: FutureBuilder<ListBanksModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          final banks = snapshot.data!.data;
          return ListView.separated(
            itemCount: banks.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final bank = banks[index];
              return ListTile(
                title: Text(bank.name),
                subtitle: Text('رقم الحساب: ${bank.accountNumber}')
                    .applyTextDirection(TextDirection.rtl),
                trailing: const Icon(Icons.chevron_left),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BankDetailPage(bankId: bank.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

extension _Dir on Widget {
  Widget applyTextDirection(TextDirection dir) =>
      Directionality(textDirection: dir, child: this);
}
