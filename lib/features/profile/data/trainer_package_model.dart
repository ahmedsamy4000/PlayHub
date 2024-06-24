class TrainingPackage {
  // final String id;
  // final String title;
  final String description;
  final double price;
  final int duration;
  final String trainerId;

  TrainingPackage({
    // required this.id,
    // required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.trainerId,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      // 'title': title,
      'description': description,
      'price': price,
      'duration': duration,
      'trainerId': trainerId,
    };
  }

  factory TrainingPackage.fromJson(Map<String, dynamic> json) {
    return TrainingPackage(
      // id: json['id'] as String,
      // title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      duration: json['duration'] as int,
      trainerId: json['trainerId'] as String,
    );
  }
}
