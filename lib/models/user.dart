class User {
  final int id;
  final String name;
  final String phoneNumber;
  final String location;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.location,
  });
// fucntion to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      location: json['location'],
    );
  }
}
