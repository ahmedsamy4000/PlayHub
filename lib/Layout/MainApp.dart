import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/common/data/local/local_storage.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/favorites/ui/screens/favorites_playgrounds_screen.dart';
import 'package:playhub/screens/HomeScreen/home.dart';
import 'package:playhub/screens/SearchScreen/search.dart';

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (BuildContext context, AppStates state) {
        return Scaffold(
          body: AppCubit.get(context)
              .pages[AppCubit.get(context).currentScreenIdx],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: AppCubit.get(context).currentScreenIdx,
            onTap: (index) {
              AppCubit.get(context).changeScreenIdx(index);
            },
            backgroundColor: AppColors.green3,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.darkGray,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              if (LocalStorage().userData?.type == UserType.player)
              const BottomNavigationBarItem(
                icon: Icon(Icons.groups),
                label: "Rooms",
              ),
              if (LocalStorage().userData?.type == UserType.admin)
              const BottomNavigationBarItem(
                icon: Icon(Icons.sports_baseball_rounded),
                label: "Statistics",
              ),
              if (LocalStorage().userData?.type == UserType.admin)
              const BottomNavigationBarItem(
                icon: Icon(Icons.sports_baseball_rounded),
                label: "Feedbacks",
              ),
              if (LocalStorage().userData?.type == UserType.player || LocalStorage().userData?.type == UserType.trainer || LocalStorage().userData?.type == UserType.playgroundOwner)
              const BottomNavigationBarItem(
                icon: Icon(Icons.sports_soccer),
                label: "Booking",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}
