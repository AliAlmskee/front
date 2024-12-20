class Newsfeed {
  final int id;
  final List<String> images;
  final String titleEn;
  final String descriptionEn;
  final String titleAr;
  final String descriptionAr;

  Newsfeed({
    required this.id,
    required this.images,
    required this.titleEn,
    required this.descriptionEn,
    required this.titleAr,
    required this.descriptionAr,
  });

  // Factory method to parse JSON data into the Newsfeed model
  factory Newsfeed.fromJson(Map<String, dynamic> json) {
    return Newsfeed(
      id: json['id'],
      images: List<String>.from(json['images']),
      titleEn: json['title_en'],
      descriptionEn: json['description_en'],
      titleAr: json['title_ar'],
      descriptionAr: json['description_ar'],
    );
  }
}
