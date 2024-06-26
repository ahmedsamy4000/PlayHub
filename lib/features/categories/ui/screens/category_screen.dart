
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/common/fade_in_slide.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/screens/playgroundScreen/playgroundscreen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen(
      {super.key, required this.categoryId, required this.name, required this.favorites});
  final String categoryId;
  final String name;
  final List<String> favorites;

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) => state is GetPlaygroundDataLoadingState
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
            backgroundColor: AppColors.greenBackground,
            appBar: AppBar(
              backgroundColor: AppColors.greenBackground,
              title: Text('$name Playgrounds'),
            ),
            body: cubit.categoryPlaygrounds.isEmpty
                ? const Center(
              child: Text(
                'No playgrounds in this category.',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cubit.categoryPlaygrounds.length,
              itemBuilder: (context, index) {
                log('hiiii $favorites');
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
                            name, city, imageUrl, playgroundId, playground['Map']),),);
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
                            imageUrl != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(imageUrl,
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
                            !cubit.favoritesId.contains(playgroundId) ? IconButton(
                              icon: const Icon(
                                Icons.favorite_border_rounded,
                                color: AppColors.darkGreen,
                                size: 30,
                              ),
                              onPressed: () {
                                cubit.addPlaygroundToFavorites(playgroundId).then((_){
                                  if(cubit.state is AddPlaygroundToFavoritesSuccessState)
                                  {
                                    cubit.getFavoritesPlaygrounds();
                                  }
                                });
                              },
                            ) : IconButton(
                              icon: const Icon(
                                Icons.favorite_rounded,
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
        )
    );
  }
}
