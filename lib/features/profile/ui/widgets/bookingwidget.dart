import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';

class BookingList extends StatelessWidget {
  final String? categoryId;
  const BookingList(this.categoryId, {super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    cubit.getbookingByCategories(categoryId!);
    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
      if (state is GetBookingListLoadingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListView.builder(
            itemCount: cubit.bookings.length,
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
                          cubit.bookings[index].playGroundName.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        Text(
                          "Time : ${cubit.bookings[index].time}:00 Pm",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          "Date : ${cubit.bookings[index].date}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }
    });
  }
}
