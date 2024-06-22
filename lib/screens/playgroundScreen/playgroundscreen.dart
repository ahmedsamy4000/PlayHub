import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/models/playgroundmodel.dart';
import 'package:playhub/widgets/datestable.dart';

class PlayGroundScreen extends StatefulWidget {
  final String? name;
  final String? image;
  final String? city;
  final String? id;
  const PlayGroundScreen(this.name, this.city, this.image, this.id, {super.key});

  @override
  State<PlayGroundScreen> createState() => _PlayGroundScreenState();
}

class _PlayGroundScreenState extends State<PlayGroundScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppCubit>(context).getPlaygroundById(widget.id!);
    
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(widget.name!),
        centerTitle: true,
      ),
      body: BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
        if (state is GetPlaygroundDataSuccessState) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DatesPerWeek(),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cubit.playground?.orders.length,
                    itemBuilder: (context, index) {
                          return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin around each button
                        padding: const EdgeInsets.all(8.0), // Padding inside each button
                        child: SizedBox(
                          width: 200, // Set the width of the button
                          height: 50, // Set the height of the button
                          child: ElevatedButton(
                            onPressed: () {
                              // Button press action
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                 cubit.playground?.orders[index].booked == true ? AppColors.red : AppColors.green3,
                              ),
                            ),
                            child: Text('Name ${index + 1}'),
                          ),
                        ),
                      );
                      }
                      )
                    ]
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
