import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/favorites/ui/screens/favorites_playgrounds_screen.dart';
import 'package:playhub/screens/HomeScreen/home.dart';
import 'package:playhub/screens/SearchScreen/search.dart';

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        return Scaffold(
          body: AppCubit.get(context)
              .pages[AppCubit.get(context).currentScreenIdx],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AppCubit.get(context).searchFunction().then((_){
                if(AppCubit.get(context).state is AppChangeSearchFunction){
                  Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
                }
                
              });
              
            },
            child: Icon(Icons.search, color: AppColors.white,),
            backgroundColor: AppColors.darkGreen,
            // label: Text('Browse all courts'),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups),
                label: "Rooms",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_soccer),
                label: "Booking",
              ),
              BottomNavigationBarItem(
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
