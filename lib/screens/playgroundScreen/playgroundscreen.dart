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
  const PlayGroundScreen(this.name, this.city, this.image, this.id,
      {super.key});

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
              child: DatesPerWeek(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }
}
