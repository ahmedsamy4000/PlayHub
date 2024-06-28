import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:playhub/Layout/MainApp.dart';
import 'package:playhub/common/data/local/local_storage.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/features/authentication/ui/screens/login_screen.dart';
import 'package:playhub/features/authentication/ui/screens/type_screen.dart';
import 'package:playhub/features/rooms/ui/screens/rooms_screen.dart';
import 'package:playhub/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:playhub/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: AppColors.red,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ));
    }
  });

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.high,
            color: AppColors.red,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          )));
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.subscribeToTopic("all");
  PaymobPayment.instance.initialize(
      apiKey:
      "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RjMU5UazJMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuUXBJbHZLc1ppaFNocDVpZXhUWTJBckdKMnlObC1aYWdoT2d6d3AwNkd1TlFJeVpFeHJ1NGpNWFUyX0VYU2p6ejB2elBIV05WcDVpaWJ0SXZHM01mYlE=",
      iFrameID: 845256,
      integrationID: 4572113);
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widgets is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit()..fillWeek(),
        child: ScreenUtilInit(
            designSize: const Size(360, 960),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              log("userDataInMain: ${LocalStorage().userData}");
              return MaterialApp(
                locale: const Locale('ar'),
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  colorScheme:
                  ColorScheme.fromSeed(seedColor: AppColors.darkGreen),
                  textTheme: TextTheme(
                    bodyLarge: TextStyle(fontFamily: 'Open Sans'),
                    bodyMedium:TextStyle(fontFamily: 'Open Sans'),
                    bodySmall: TextStyle(fontFamily: 'Open Sans'),
                    displayLarge:TextStyle(fontFamily: 'Open Sans'),
                    displayMedium: TextStyle(fontFamily: 'Open Sans'),
                    displaySmall: TextStyle(fontFamily: 'Open Sans'),
                    headlineLarge: TextStyle(fontFamily: 'Open Sans'),
                    headlineMedium: TextStyle(fontFamily: 'Open Sans'),
                    headlineSmall: TextStyle(fontFamily: 'Open Sans'),
                    labelLarge: TextStyle(fontFamily: 'Open Sans'),
                    labelMedium: TextStyle(fontFamily: 'Open Sans'),
                    labelSmall: TextStyle(fontFamily: 'Open Sans'),
                    titleLarge: TextStyle(fontFamily: 'Open Sans'),
                    titleMedium: TextStyle(fontFamily: 'Open Sans'),
                    titleSmall: TextStyle(fontFamily: 'Open Sans'),
                  ),
                  useMaterial3: true,
                ),
                home: LocalStorage().userData != null ? Main() : LoginScreen(),
              );
            }));
  }
}
