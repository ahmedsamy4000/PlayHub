import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/playgrounds/ui/screens/add_playground.dart';

class PlaygroundsScreen extends StatelessWidget {
  const PlaygroundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Playgrounds'),
            actions: [
              IconButton(
                onPressed: () {
                  cubit.getCategories().then((_) {
                    if (cubit.state is GetCategoriesSuccessState) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddPlaygroundScreen(
                          categories: cubit.categoriesNames,
                        );
                      }));
                    }
                  });
                },
                icon: const Icon(
                  Icons.add_home_work_rounded,
                  size: 25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
