import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/categories/ui/screens/category_screen.dart';
import 'package:playhub/features/favorites/ui/screens/favorites_screen.dart';
import 'package:playhub/features/favorites/ui/widgets/favorites_playgrounds.dart';
import 'package:playhub/generated/l10n.dart';
import 'package:playhub/screens/FeedbackScreen/feedbackscreen.dart';
import 'package:playhub/screens/HomeScreen/CategoryCard.dart';
import 'package:playhub/screens/HomeScreen/floatingactionmenu.dart';
import 'package:playhub/screens/playgroundScreen/playgroundscreen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: AppColors.greenBackground,
            appBar: AppBar(
              backgroundColor: AppColors.greenBackground,
              title: const Text(
                'PlayHub',
                textAlign: TextAlign.left,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FeedBackScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.feedback_outlined,
                    color: AppColors.darkGreen,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cubit.getFavoritesPlaygrounds().then((_) {
                      if (cubit.state is GetFavoritesPlaygroundsSuccessState) {
                        cubit.getFavoritesTrainers().then((_) {
                          if (cubit.state is GetFavoritesTrainersSuccessState) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FavoritesScreen(),
                              ),
                            );
                          }
                        });
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: AppColors.darkGreen,
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: const FloatingActionMenu(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Welcome Reem Hatem'),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).Categories,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                       SizedBox(
                            height: 320.0,
                            child: PageView.builder(
                              itemCount: cubit.categories.length,
                              physics: const BouncingScrollPhysics(),
                              padEnds: false,
                              pageSnapping: true,
                              itemBuilder: (context, index) {
                                final category = cubit.categories[index];
                                final name = category.name;
                                final imageUrl = category.image;
                                final categoryId = category.id;

                                return CategoryCard(
                                  imageUrl: imageUrl,
                                  name: name,
                                  onTap: () {
                                    cubit.getFavoritesPlaygrounds().then((_) {
                                      if (cubit.state
                                          is GetFavoritesPlaygroundsSuccessState) {
                                        cubit
                                            .getCategoryPlaygrounds(categoryId)
                                            .then((_) {
                                          if (cubit.state
                                              is GetCategoryPlaygroundsSuccessState) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryScreen(
                                                  categoryId: categoryId,
                                                  name: name,
                                                  favorites: cubit.favoritesId,
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          )
                      ,
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).Playgrounds,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: BlocProvider.of<AppCubit>(context)
                            .homePlaygrounds
                            .length,
                        itemBuilder: (context, index) {
                          final playground = BlocProvider.of<AppCubit>(context)
                              .homePlaygrounds[index];
                          final name = playground.name;
                          final city = playground.city;
                          final imageUrl = playground.image;
                          final playgroundId =
                              BlocProvider.of<AppCubit>(context)
                                  .homePlaygroundsIds[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayGroundScreen(
                                          name,
                                          city,
                                          imageUrl,
                                          playgroundId,
                                          playground.location)));
                            },
                            child: Container(
                              width: 200.w,
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.green2,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.green2,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      imageUrl != null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Image.network(
                                                  imageUrl,
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child:
                                                  Icon(Icons.image, size: 70),
                                            ),
                                      const SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            city,
                                            style: const TextStyle(
                                              color: AppColors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.green1,
                                      radius: 15,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: AppColors.white,
                                          size: 15,
                                        ),
                                        onPressed: () {
                                          cubit.addPlaygroundToFavorites(
                                              playgroundId);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
