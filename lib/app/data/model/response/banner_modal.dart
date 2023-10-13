class BannerModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  BannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image'],
    );
  }
}
