import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/screens/SearchScreen/search.dart';

class FloatingActionMenu extends StatelessWidget {
  const FloatingActionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          backgroundColor: AppColors.darkGreen,
          foregroundColor: Colors.white),
      distance: 60,
      children: [
        FloatingActionButton(
          heroTag: null,
          backgroundColor: AppColors.darkGreen,
          onPressed: () {},
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
        FloatingActionButton(
          heroTag: null,
          backgroundColor: AppColors.darkGreen,
          onPressed: () {
            AppCubit.get(context).searchFunction().then((_) {
              if (AppCubit.get(context).state is AppChangeSearchFunction) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              }
            });
          },
          child: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

// AppCubit.get(context).searchFunction().then((_) {
//                 if (AppCubit.get(context).state is AppChangeSearchFunction) {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Search()));