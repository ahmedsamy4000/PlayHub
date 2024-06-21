import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:playhub/models/ordermodel.dart';

class PlaygroundModel {
  String? id;
  String? name;
  String? image;
  String? ownerId;
  String? region;
  String? city;
  List<Ordermodel> orders;

  PlaygroundModel(
      this.id, this.name, this.image, this.ownerId, this.orders, this.region, this.city);

  factory PlaygroundModel.fromJson(Map<String, dynamic> json, String id,
      List<DocumentSnapshot> ordersSnapShot) {
    List<Ordermodel> orders = ordersSnapShot
        .map((doc) => Ordermodel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return PlaygroundModel(
      id,
      json["Name"],
      json["Image"],
      json["Owner_Id"],
      orders,
      json["Region"],
      json["City"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Image": image,
        "Owner_Id": ownerId,
        "Region": region,
        "City": city,
      };
}
