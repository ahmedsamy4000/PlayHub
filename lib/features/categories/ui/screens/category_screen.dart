import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/screens/playgroundScreen/playgroundscreen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.categoryId, required this.name});
  final String categoryId;
  final String name;

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    cubit.getCategoryPlaygrounds(categoryId);
    return BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) => state is GetPlaygroundDataLoadingState
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  title: Text('$name Playgrounds'),
                ),
                body: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cubit.categoryPlaygrounds.length,
                    itemBuilder: (context, index) {
                      final playground = cubit.categoryPlaygrounds[index];
                      final name = playground['Name'];
                      final city = playground['City'];
                      final imageUrl = playground['Image'];
                      final playgroundId = cubit.playgroundsId[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlayGroundScreen(
                                      name, city, imageUrl, playgroundId)));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              imageUrl != null
                                  ? Image.network(imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover)
                                  : Icon(Icons.image, size: 100),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(city),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
              )
              );
  }
}
