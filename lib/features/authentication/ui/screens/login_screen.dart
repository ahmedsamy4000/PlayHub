import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/features/authentication/ui/screens/register_screen.dart';
import 'package:playhub/features/authentication/ui/screens/type_screen.dart';
import '../../cubits/auth_cubit.dart';
import '../widgets/background_login.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AuthCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
                child: CustomBackgroundLogin(
                  flex: 3,
                  text: "Don't have an account? ",
                  link: "Register",
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TypeScreen()));
                  },
                ),
            ),
            Positioned(
              top: 220.h,
                left: 20.w,
                right: 20.w,
                child: CustomLoginForm()),

          ],
        ),
      ),
    );
  }
}







