class Trip {
  final int id;
  final String pickupLocationAr;
  final String destinationAr;
  final String pickupLocationEn;
  final String destinationEn;
  final List<String> images;
  final String descriptionEn;
  final String descriptionAr;
  final double price;

  Trip(
      {required this.id,
      required this.pickupLocationAr,
      required this.destinationAr,
      required this.pickupLocationEn,
      required this.destinationEn,
      required this.images,
      required this.descriptionEn,
      required this.descriptionAr,
      required this.price});

  // Factory method to parse JSON data into the Trip model
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      pickupLocationAr: json['pickup_location_ar'],
      destinationAr: json['destination_ar'],
      pickupLocationEn: json['pickup_location_en'],
      destinationEn: json['destination_en'],
      images: List<String>.from(json['images']),
      descriptionEn: json['description_en'],
      descriptionAr: json['description_ar'],
      price: json['price'].toDouble(),
    );
  }
}
