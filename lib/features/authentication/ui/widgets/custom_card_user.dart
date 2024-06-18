import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';

class CustomCardUser extends StatelessWidget {
  const CustomCardUser({
    super.key, required this.img, required this.text, required this.backgroundColor, required this.onTap,
  });
  final String img;
  final String text;
  final Color backgroundColor;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: 15.padHorizontal+15.padVertical,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(25.r)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              img,
              height: 120.h,
            ),
            10.verticalSpace,
            Text(
              text,
              style: TextStyle(
                color: AppColors.white,

              ),
            )
          ],
        ),
      ),
    );
  }
}