import 'package:real_estate/helper/api.dart';
import 'package:real_estate/models/Public_List_Approved_model.dart';

class PublicListApprovedService {
  Future<PublicListApprovedModel> publicListApproved() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/property/getall',
    );
    return PublicListApprovedModel.fromJson(data);
  }
}
