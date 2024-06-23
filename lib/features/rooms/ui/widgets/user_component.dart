import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';

import '../../../authentication/data/user_model.dart';

class UserComponent extends StatelessWidget {
  const UserComponent({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: 10.padVertical,
      padding: 10.padAll,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10.0,
            offset: const Offset(3, 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          user.image == null
              ? CircleAvatar(
            backgroundColor: AppColors.darkGreen,
            radius: 50.r,
            child: Text(
              user.fullName == null
                  ? ''
                  : '${user.fullName![0]}',
              style: const TextStyle(
                  fontSize: 50,
                  color: AppColors.white),
            ),
          )
              : CircleAvatar(
            backgroundColor: AppColors.darkGreen,
            backgroundImage:
            NetworkImage(user.image!),
            radius: 50.r,
          ),
          10.horizontalSpace,
          Column(
            children: [
              Text(user.fullName??"",
                style: TextStyle(
                    fontSize: 30
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}