class Playground {
  final String categoryId;
  final String city;
  final String image;
  final String name;
  final String ownerId;
  final String region;

  Playground({
    required this.categoryId,
    required this.city,
    required this.image,
    required this.name,
    required this.ownerId,
    required this.region,
  });

  factory Playground.fromJson(Map<String, dynamic> json) {
    return Playground(
      categoryId: json['CategoryId'] ?? '',
      city: json['City'] ?? '',
      image: json['Image'] ?? '',
      name: json['Name'] ?? '',
      ownerId: json['Owner_Id'] ?? '',
      region: json['Region'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CategoryId': categoryId,
      'City': city,
      'Image': image,
      'Name': name,
      'Owner_Id': ownerId,
      'Region': region,
    };
  }
}