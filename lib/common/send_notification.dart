// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
// sendAndRetrieveMessage(String title, String body,) async {
//   await firebaseMessaging.requestPermission(
//       sound: true, badge: true, alert: true, provisional: false);
//   await http.post(
//     Uri.parse('https://fcm.googleapis.com/fcm/send'),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverToken',
//     },
//     body: jsonEncode(
//       <String, dynamic>{
//         'notification': <String, dynamic>{
//           'body': body,
//           'title': title,
//           'sound': "assets/sound/notification.mp3",
//           'default_sound': true,
//           'default_vibrate_timings': true,
//           'default_light_settings': true,
//         },
//         'priority': 'high',
//         'data': <String, dynamic>{
//           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//         },
//         "to": "/topics/all",
//         //'to': token,
//       },
//     ),
//   );
// }