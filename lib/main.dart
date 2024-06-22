import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/Layout/MainApp.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/features/authentication/ui/screens/login_screen.dart';
import 'package:playhub/features/authentication/ui/screens/type_screen.dart';
import 'package:playhub/features/rooms/ui/screens/rooms_screen.dart';
import 'package:playhub/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home: Main(),
              );
            }));
  }
}
