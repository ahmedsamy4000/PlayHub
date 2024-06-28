import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/common/data/local/local_storage.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/favorites/ui/screens/favorites_playgrounds_screen.dart';
import 'package:playhub/generated/l10n.dart';
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
            backgroundColor: AppColors.darkGreen,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.grey,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: S.of(context).Home,
              ),
              if (LocalStorage().userData?.type == UserType.player)
             BottomNavigationBarItem(
                icon: const Icon(Icons.groups),
                label: S.of(context).Rooms,
              ),
              if (LocalStorage().userData?.type == UserType.admin)
               BottomNavigationBarItem(
                icon: const Icon(Icons.sports_baseball_rounded),
                label: S.of(context).Statistics,
              ),
              if (LocalStorage().userData?.type == UserType.admin)
               BottomNavigationBarItem(
                icon: const Icon(Icons.sports_baseball_rounded),
                label: S.of(context).Feedbacks,
              ),
              if (LocalStorage().userData?.type == UserType.player || LocalStorage().userData?.type == UserType.trainer || LocalStorage().userData?.type == UserType.playgroundOwner)
               BottomNavigationBarItem(
                icon: const Icon(Icons.sports_soccer),
                label: S.of(context).Reservations,
              ),
               BottomNavigationBarItem(
                icon: const Icon(Icons.account_circle),
                label: S.of(context).Profile,
              ),
            ],
          ),
        );
      },
    );
  }
}
