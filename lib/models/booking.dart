class Booking {
  final int id;
  final int userId;
  final int tripId;
  final int numberOfPassengers;
  final int numberOfBagsOfWeight10;
  final int numberOfBagsOfWeight23;
  final int numberOfBagsOfWeight30;
  final DateTime date;
  final String vehicle;
  final String name;
  final String entryRequirement;
  final String passportPhoto;
  final String ticketPhoto;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  Booking({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.numberOfPassengers,
    required this.numberOfBagsOfWeight10,
    required this.numberOfBagsOfWeight23,
    required this.numberOfBagsOfWeight30,
    required this.date,
    required this.vehicle,
    required this.name,
    required this.entryRequirement,
    required this.passportPhoto,
    required this.ticketPhoto,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to parse JSON data into the Booking model
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      tripId: json['trip_id'],
      numberOfPassengers: json['number_of_passengers'],
      numberOfBagsOfWeight10: json['number_of_bags_of_wieght_10'],
      numberOfBagsOfWeight23: json['number_of_bags_of_wieght_23'],
      numberOfBagsOfWeight30: json['number_of_bags_of_wieght_30'],
      date: DateTime.parse(json['date']),
      vehicle: json['vehicle'],
      name: json['name'],
      entryRequirement: json['entry_requirement'],
      passportPhoto: json['passport_photo'],
      ticketPhoto: json['ticket_photo'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']), // Parse createdAt
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
