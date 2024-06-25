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
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/features/authentication/ui/screens/login_screen.dart';
import 'package:playhub/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:playhub/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
                locale: const Locale('en'),
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
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home: LocalStorage().userData != null ? Main() : const LoginScreen(),
              );
            }));
  }
}
