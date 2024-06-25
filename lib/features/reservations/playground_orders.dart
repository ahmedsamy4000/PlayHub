import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';

class PlaygroundOrdersScreen extends StatelessWidget {
  const PlaygroundOrdersScreen({super.key, required this.id, required this.name});
  final String id;
  final String name;

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    cubit.getPlaygroundReservations(id);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('$name Reservations'),
          ),
          body: ListView.builder(
              itemCount: cubit.playgroundReservations.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.green,
                    color: AppColors.darkGreen,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User Name: ${cubit.playgroundReservations[index]['UserName']}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Date: ${cubit.playgroundReservations[index]['Date']}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Time: ${cubit.playgroundReservations[index]['Time']}:00 PM",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
