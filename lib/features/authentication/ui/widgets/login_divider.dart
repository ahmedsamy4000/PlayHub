import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key, required this.colorDivider,
  });
  final Color colorDivider;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80.w),
      height: 4.h,
      decoration: BoxDecoration(
        color: colorDivider,
        borderRadius: BorderRadius.circular(10.r), // Adjust the radius as needed
      ),
    );
  }
}