import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';

class PackageReservation extends StatelessWidget {
  const PackageReservation({super.key, required this.trainerId, required this.packageId});
  final String trainerId;
  final String packageId;


  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Reservations'),
          ),
          body: ListView.builder(
              itemCount: cubit.packageBooked.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 8,
                    shadowColor: AppColors.green,
                    color: AppColors.darkGreen,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User Name: ${cubit.packageBooked[index]['playerName']}",
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "User Email: ${cubit.packageBooked[index]['playerEmail']}",
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   "Date: ${cubit.packageBooked[index]['Date']}",
                          //   style: const TextStyle(
                          //       color: AppColors.white,
                          //       fontSize: 20,
                          //       fontFamily: 'Open Sans',
                          //       fontWeight: FontWeight.bold),
                          // ),
                          // Text(
                          //   "Time: ${cubit.playgroundReservations[index]['Time']}:00 PM",
                          //   style: const TextStyle(
                          //       color: AppColors.white,
                          //       fontSize: 20,
                          //       fontFamily: 'Open Sans',
                          //       fontWeight: FontWeight.bold),
                          // ),
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
