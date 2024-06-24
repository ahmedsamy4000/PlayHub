class CategoryModel {
  final String id;
  final String image;
  final String name;

  CategoryModel({
    required this.id,
    required this.image,
    required this.name,
  });

  // Factory constructor to create a RoomModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['Id'] as String,
      image: json['Image'] as String,
      name: json['Name'] as String,
    );
  }

  // Method to convert a RoomModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Image': image,
      'Name': name,
    };
  }
}
