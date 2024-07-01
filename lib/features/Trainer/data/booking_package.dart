class PackageBooking {
  String packageId;
  String trainerId;
  String? trainerName;
  String? playerId;
  String? playerName;
  String playerEmail;

  PackageBooking({
    required this.packageId,
    required this.trainerId,
    this.trainerName,
    this.playerId,
    this.playerName,
    required this.playerEmail,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'trainerId': trainerId,
      'trainerName': trainerName,
      'playerId': playerId,
      'playerName': playerName,
      'playerEmail': playerEmail,
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

    );
  }
}
