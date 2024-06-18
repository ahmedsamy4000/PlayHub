import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/features/authentication/ui/screens/register_screen.dart';

import '../../../../core/app_colors.dart';
import '../widgets/custom_card_user.dart';
import 'login_screen.dart';

class TypeScreen extends StatelessWidget {
  const TypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login.jpg",
              height: 500.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 400.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(40))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomCardUser(
                        text: "Player",
                        img: "assets/images/football.png",
                        backgroundColor: AppColors.green1,
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(type: UserType.player,)));
                        },
                      ),
                      CustomCardUser(
                        text: "Trainer",
                        img: "assets/images/coach.png",
                        backgroundColor: AppColors.green2,
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(type: UserType.trainer,)));

                        },
                      ),
                    ],
                  ),
                  30.verticalSpace,
                  CustomCardUser(
                    text: "Playground Owner",
                    img: "assets/images/playground.png",
                    backgroundColor: AppColors.green3,
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(type: UserType.playgroundOwner,)));
                    },

                  ),
                  30.verticalSpace,
                  RichText(
                      text: TextSpan(
                        style: TextStyle(color: AppColors.black),
                    children: [
                      TextSpan(text:"Do you already have an account? ",
                      ),
                      TextSpan(
                          text: "Login",
                          style: TextStyle(color: AppColors.green),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            }),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


