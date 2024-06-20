import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(12, (index) {
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
                              backgroundColor: MaterialStateProperty.all(
                                index == 0 ? Colors.red : Colors.white,
                              ),
                            ),
                            child: Text('Name ${index + 1}'),
                          ),
                        ),
                      );
                    }),
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
