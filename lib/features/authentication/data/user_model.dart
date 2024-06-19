import 'dart:convert';

import '../../../core/enums/type_enum.dart';

UserModel welcomeFromJson(String str) => UserModel.fromJson(json.decode(str));

String welcomeToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? password;
  final UserType? type;
  final String? city;
  final String? region;
  final String? image;
  UserModel(
      {this.id,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.password,
      this.type,
      this.city,
      this.region,
      this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["Id"],
      fullName: json["Name"],
      email: json["Email"],
      phoneNumber: json["PhoneNumber"],
      password: json["Password"],
      type: json["Type"],
      city: json["City"],
      region: json["Region"],
      image: json["image"]);

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": fullName,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "Type": type == UserType.trainer
            ? "Trainer"
            : type == UserType.player
                ? "Player"
                : "Owner",
        "City": city,
        "Region": region,
        "Image": image,
      };
}
