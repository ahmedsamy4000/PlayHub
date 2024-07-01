class PackageBooking {
  String packageId;
  String trainerId;
  String? trainerName;
  String? playerId;
  String? playerName;
  String playerEmail;
  String description;
  int duration;
  double price;

  PackageBooking({
    required this.packageId,
    required this.trainerId,
    this.trainerName,
    this.playerId,
    this.playerName,
    required this.playerEmail,
    required this.description,
    required this.duration,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'trainerId': trainerId,
      'trainerName': trainerName,
      'playerId': playerId,
      'playerName': playerName,
      'playerEmail': playerEmail,
      'description': description,
      'price': price,
      'duration': duration,
    };
  }

  factory PackageBooking.fromJson(Map<String, dynamic> json) {
    return PackageBooking(
      packageId: json['packageId'] as String,
      trainerId: json['trainerId'] as String,
      trainerName: json['trainerName'] as String?,
      playerId: json['playerId'] as String?,
      playerName: json['playerName'] as String?,
      playerEmail: json['playerEmail'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as int,
    );
  }
}
