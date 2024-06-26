import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app_colors.dart';
import '../../../authentication/data/user_model.dart';

class PlayersListItem extends StatelessWidget {
  const PlayersListItem({
    super.key,
    required this.item,  this.owner=false,
  });

  final UserModel item;
  final bool owner;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          item.image == null
              ? CircleAvatar(
            backgroundColor: AppColors.darkGreen,
            radius: 35.r,
            child: Text(
              item.fullName == null ? '' : '${item.fullName![0]}',
              style: const TextStyle(fontSize: 30, color: AppColors.white),
            ),
          )
              : CircleAvatar(
            backgroundColor: AppColors.darkGreen,
            backgroundImage: NetworkImage(item.image!),
            radius: 35.r,
          ),
          owner?SizedBox.shrink():Text(
            "${item.fullName}",
            style: TextStyle(color: Colors.black),
          ),]
    );
  }
}