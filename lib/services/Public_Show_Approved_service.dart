import 'package:real_estate/helper/api.dart';
import 'package:real_estate/models/property_models.dart'; // ← الملف الجديد
import 'package:real_estate/main.dart';

class PublicShowApprovedService {
  Future<PublicShowApprovedModel> publicShowApproved({required int id}) async {
    try {
      final data = await Api().get(
        url: '$baseUrl/property/show/$id',
        token: sharedPreferences!.getString('token'),
      );

      print("استجابة API للعقار: $data");

      if (data['data'] == null) {
        throw Exception("لم يتم العثور على بيانات العقار");
      }

      return PublicShowApprovedModel.fromJson(data);
    } catch (e) {
      print("خطأ في جلب تفاصيل العقار: $e");
      rethrow;
    }
  }
}
