// models/farmer.dart
class Farmer {
  String name;
  String address;
  double farmLandArea;
  DateTime dob;
  String gender;
  String image1Path;
  String image2Path;
  String videoPath;
  double latitude;
  double longitude;

  Farmer({
    required this.name,
    required this.address,
    required this.farmLandArea,
    required this.dob,
    required this.gender,
    required this.image1Path,
    required this.image2Path,
    required this.videoPath,
    required this.latitude,
    required this.longitude,
  });

  set temperature(temperature) {}

  set city(city) {}
}
