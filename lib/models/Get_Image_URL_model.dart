class GetImageUrlModel {
  final String url;
  GetImageUrlModel({required this.url});
  factory GetImageUrlModel.fromJson(Map<String, dynamic> json) {
    return GetImageUrlModel(url: json['url']);
  }
}
