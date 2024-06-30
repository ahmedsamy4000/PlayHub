import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

const String projectId = 'playhub-e2ca5';
const String firebaseAdminScope = 'https://www.googleapis.com/auth/firebase.messaging';

Future<void> sendAndRetrieveMessage(String title, String body, BuildContext context) async {
  await firebaseMessaging.requestPermission(
    sound: true,
    badge: true,
    alert: true,
    provisional: false,
  );

  final serviceAccount = jsonDecode(await DefaultAssetBundle.of(context).loadString('assets/playhub-e2ca5-firebase-adminsdk-inped-df527cddbd.json'));

  final auth.ServiceAccountCredentials credentials = auth.ServiceAccountCredentials.fromJson(serviceAccount);

  final auth.AutoRefreshingAuthClient client = await auth.clientViaServiceAccount(credentials, [firebaseAdminScope]);

  final response = await client.post(
    Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
      <String, dynamic>{
        'message': {
          'notification': {
            'title': title,
            'body': body,
          },
          'android': {
            'notification': {
              'sound': 'default',
            },
          },
          'apns': {
            'payload': {
              'aps': {
                'sound': 'default',
              },
            },
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
          'topic': 'all',
        },
      },
    ),
  );

  if (response.statusCode == 200) {
    print('Message sent successfully.');
  } else {
    print('Failed to send message: ${response.body}');
  }
}
