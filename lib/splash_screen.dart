import 'package:flutter/material.dart';
import 'package:playhub/Layout/MainApp.dart';
import 'package:playhub/common/data/local/local_storage.dart';

import 'features/authentication/ui/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalStorage().userData!=null?Main():LoginScreen();
  }
}
