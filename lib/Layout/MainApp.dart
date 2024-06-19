import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/screens/HomeScreen/home.dart';

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'PlayHub',
                textAlign: TextAlign.left,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite),
                )
              ],
            ),
            body: AppCubit.get(context)
                .pages[AppCubit.get(context).currentScreenIdx],
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(Icons.search),
              label: Text('Browse all courts'),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentScreenIdx,
              onTap: (index) {
                AppCubit.get(context).changeScreenIdx(index);
              },
              backgroundColor: Colors.blueGrey,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
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
      ),
    );
  }
}
