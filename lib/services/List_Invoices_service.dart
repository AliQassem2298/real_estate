// services/ListInvoicesService.dart

import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/List_Invoices_model.dart';

class ListInvoicesService {
  Future<List<InvoiceModel>> listInvoices() async {
    final List<dynamic> jsonResponse = await Api().get(
      url: '$baseUrl/invoices',
      token: sharedPreferences!.getString('token'),
    );

    return jsonResponse
        .map((item) => InvoiceModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
