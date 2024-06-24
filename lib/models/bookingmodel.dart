class BookingModel {
  String? categoryId;
  String? playGroundName;
  String? userName;
  int? time;
  String? date;
  bool? booked;

  BookingModel({
    this.categoryId,
    this.playGroundName,
    this.userName,
    this.time,
    this.date,
    this.booked,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      categoryId: json['CategoryId'],
      playGroundName: json['PlayGroundName'] as String?,
      userName: json['UserName'] as String?,
      time: json['Time'] as int?,
      date: json['Date'] as String?,
      booked: json['Booked'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CategoryId': categoryId,
      'PlayGroundName': playGroundName,
      'UserName': userName,
      'Time': time,
      'Date': date,
      'Booked': booked,
    };
  }
}
