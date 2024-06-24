import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/screens/playgroundScreen/playgroundscreen.dart';

class FavoritesPlaygroundsScreen extends StatelessWidget {
  const FavoritesPlaygroundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    cubit.getFavoritesPlaygrounds();
    return BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) =>
            state is GetFavoritesPlaygroundsLoadingState
                ? const CircularProgressIndicator()
                : Scaffold(
                    appBar: AppBar(
                      title: const Text('Favorites'),
                    ),
                    body: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cubit.favoritesPlaygrounds.length,
                      itemBuilder: (context, index) {
                        final playground = cubit.favoritesPlaygrounds[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayGroundScreen(
                                  playground['Name'],
                                  playground['City'],
                                  playground['Image'],
                                  playground['Id'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                playground['Image'] != null
                                    ? Image.network(playground['Image'],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover)
                                    : Icon(Icons.image, size: 100),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      playground['Name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(playground['City'] ?? ''),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      cubit.deletePlaygroundFromFavorites(
                                          playground['Id']);
                                    },
                                    icon: const Icon(Icons.close)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ));
  }
}
