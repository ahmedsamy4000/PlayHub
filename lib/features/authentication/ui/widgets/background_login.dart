import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';

class CustomBackgroundLogin extends StatelessWidget {
  const CustomBackgroundLogin({
    super.key, required this.flex, required this.text, required this.link, required this.onTap,
  });
   final int flex;
   final String text;
   final String link;
   final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right:0,
          child: Image.asset(
            "assets/images/login.jpg",
            height: 500.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 450.h,
          bottom: 0,
          left: 0,
          right:0,
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(
                  flex:flex,
                ),
                RichText(text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(text: text),
                    TextSpan(
                        text: link,
                        style: TextStyle(
                            color: AppColors.green
                        ),
                        recognizer: TapGestureRecognizer()..onTap=onTap),
                  ],
                )),
                Spacer(
                  flex: 1,
                )
              ],
            ),
          ),
        ),

      ],
    );
  }
}