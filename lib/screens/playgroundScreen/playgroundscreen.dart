import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:playhub/common/data/local/local_storage.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/models/playgroundmodel.dart';
import 'package:playhub/screens/playgroundScreen/book_screen.dart';
import 'package:playhub/widgets/datestable.dart';

class PlayGroundScreen extends StatefulWidget {
  final String? name;
  final String? image;
  final String? city;
  final String? id;
  final String location;
  const PlayGroundScreen(this.name, this.city, this.image, this.id, this.location,
      {super.key});

  @override
  State<PlayGroundScreen> createState() => _PlayGroundScreenState();
}

class _PlayGroundScreenState extends State<PlayGroundScreen> {
  String date = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppCubit>(context).getPlaygroundById(widget.id!, date);
  }

  void handleDateSelected(String newdate) {
    setState(() {
      date = newdate;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    var userData = LocalStorage().userData;
    return Scaffold(
      backgroundColor: AppColors.greenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.greenBackground,
        title: Text(widget.name!),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            cubit.openGoogleMaps(widget.location);
          }, icon:  const Icon(Icons.location_on, size: 30,), color: AppColors.darkGreen)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DatesPerWeek(widget.id, handleDateSelected),
          ),
          // List.generate(12, (index) {
          //     return Container(
          //       margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin around each button
          //       padding: const EdgeInsets.all(8.0), // Padding inside each button
          //       child: SizedBox(
          //         width: 200, // Set the width of the button
          //         height: 50, // Set the height of the button
          //         child: ElevatedButton(
          //           onPressed: () {
          //             // Button press action
          //           },
          //           style: ButtonStyle(
          //             backgroundColor: MaterialStateProperty.all(
          //               index == 0 ? Colors.red : Colors.white,
          //             ),
          //           ),
          //           child: Text('Name ${index + 1}'),
          //         ),
          //       ),
          //     );
          //   }),
          Expanded(
            child: BlocBuilder<AppCubit, AppStates>(
              builder: (context, state) {
                if (state is GetPlaygroundDataSuccessState) {
                  return ListView.builder(
                      itemCount: cubit.playground?.orders.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0), // Margin around each button
                          padding: const EdgeInsets.all(
                              8.0), // Padding inside each button
                          child: SizedBox(
                            width: 200, // Set the width of the button
                            height: 50, // Set the height of the button
                            child: ElevatedButton(
                              onPressed: () {
                                if (cubit.playground!.orders[index].booked ==
                                    false) {
                                  showAnimatedDialog(
                                      context,
                                      widget.id,
                                      widget.name!,
                                      userData?.fullName,
                                      cubit.playground!.orders[index].time
                                          .toString(),
                                      date,
                                      "10",
                                      "200Egp");
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  cubit.playground?.orders[index].booked == true
                                      ? AppColors.red1
                                      : AppColors.green2,
                                ),
                              ),
                              child: Text('${index + 1}:00  PM'),
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
