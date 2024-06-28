import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/common/fade_in_slide.dart';
import 'package:playhub/core/app_colors.dart';
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
                ? const Scaffold(body: Center(child: CircularProgressIndicator()))
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
                                          name, city, imageUrl, playgroundId),),);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8),
                              child: FadeInSlide(
                                duration: 0.5 + (index / 10),
                                child: Card(
                                  color: AppColors.white,
                                  child: Row(
                                    children: [
                                      imageUrl != null
                                          ? Image.network(imageUrl,
                                              width: 120,
                                              height: 100,
                                              fit: BoxFit.cover)
                                          : const Icon(Icons.image, size: 100),
                                      10.horizontalSpace,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${playground['Region']}, $city",
                                            style: const TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontSize: 15,
                                              color: AppColors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: AppColors.darkGreen,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        cubit.deletePlaygroundFromFavorites(playgroundId).then((_){
                                          if(cubit.state is DeletePlaygroundFromFavoritesSuccessState)
                                          {
                                            cubit.getFavoritesPlaygrounds();
                                          }
                                        });
                                      },
                                    ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                  ));
  }
}


