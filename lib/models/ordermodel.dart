class Ordermodel {
  String? userName;
  int? time;
  String? date;
  bool? booked;

  Ordermodel({
    this.userName,
    this.time,
    this.date,
    this.booked,
  });

  factory Ordermodel.fromJson(Map<String, dynamic> json) {
    return Ordermodel(
      userName: json['UserName'] as String?,
      time: json['Time'] as int?,
      date: json['Date'] as String?,
      booked: json['Booked'] as bool?,
    );
  }
}
