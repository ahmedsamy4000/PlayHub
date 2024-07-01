import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/common/fade_in_slide.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/screens/playgroundScreen/playgroundscreen.dart';

class FavoritesPlaygrounds extends StatelessWidget {
  const FavoritesPlaygrounds({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) => state
                is GetFavoritesPlaygroundsLoadingState
            ? const Center(child: CircularProgressIndicator())
            : cubit.favoritesPlaygrounds.isEmpty
                ? const Center(
                    child: Text('No Favorites Playgrounds Yet.'),
                  )
                : ListView.builder(
                    itemCount: cubit.favoritesPlaygrounds.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayGroundScreen(
                                  cubit.favoritesPlaygrounds[index]['Name'] ?? '',
                                  cubit.favoritesPlaygrounds[index]['City'] ?? '',
                                  cubit.favoritesPlaygrounds[index]['Image'] ?? '',
                                  cubit.favoritesId[index],
                                  cubit.favoritesPlaygrounds[index]['Map'] ?? ''),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: FadeInSlide(
                            duration: 0.5 + (index / 10),
                            child: Container(
                              margin: 5.padVertical,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10.0,
                                    offset: const Offset(3, 5),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10.0,
                                    offset: const Offset(-1, -1),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  cubit.favoritesPlaygrounds[index]['Image'] !=
                                          null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                              cubit.favoritesPlaygrounds[index]
                                                  ['Image'],
                                              width: 120,
                                              height: 100,
                                              fit: BoxFit.cover),
                                        )
                                      : const Icon(Icons.image, size: 100),
                                  10.horizontalSpace,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cubit.favoritesPlaygrounds[index]
                                            ['Name'],
                                        style: const TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${cubit.favoritesPlaygrounds[index]['Region']}, ${cubit.favoritesPlaygrounds[index]['City']}",
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
                                      cubit
                                          .deletePlaygroundFromFavorites(
                                              cubit.favoritesId[index])
                                          .then((_) {
                                        if (cubit.state
                                            is DeletePlaygroundFromFavoritesSuccessState) {
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
                    }));
  }
}
