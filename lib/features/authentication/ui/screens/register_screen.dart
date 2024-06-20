import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/features/authentication/cubits/auth_cubit.dart';
import 'package:playhub/features/authentication/ui/screens/login_screen.dart';
import 'package:playhub/features/authentication/ui/widgets/custom_signup_form.dart';

import '../../../../core/enums/type_enum.dart';
import '../widgets/background_login.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, required this.type});
  final UserType type;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AuthCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: 1000.h,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomBackgroundLogin(
                    flex: 10,
                    text: "Do you have already an account? ",
                    link: "Login",
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));

                    },
                  ),
                ),
                Positioned(
                    //bottom: 100.h,
                    left: 20.w,
                    right: 20.w,
                    top:140.h,
                    child: SignupForm(type: type,),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
