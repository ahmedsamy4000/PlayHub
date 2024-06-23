class RoomModel {
  final String authUserId;
  final String playground;
  final String category;
  final String city;
  final String date;
  final String time;
  final String level;
  final String period;
  final String playersNum;
  final String? comment;
  final List<dynamic> players;

  RoomModel( {
    required this.players,
    required this.authUserId,
    required this.level,
  required this.playground,
  required this.category,
  required this.city,
  required this.date,
  required this.time,
  required this.period,
  required this.playersNum,
  required this.comment,

  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
        authUserId: json['AuthUserId'],
        playground: json['Playground'],
        category: json['Category'],
        city: json['City'],
        date: json['Date'],
        time: json['Time'],
        period: json['Period'],
        playersNum: json['PlayersNum'],
        comment: json['Comment'],
      level: json['Level'],
      players: json['Players']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AuthUserId':authUserId,
      'Playground': playground,
      'Category':category,
      'City': city,
      'Date': date,
      'Time': time,
      'Period': period,
      'PlayersNum': playersNum,
      'Comment': comment,
      'Level': level,
      'Players': players
    };
  }
}