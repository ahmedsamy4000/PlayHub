import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/Trainer/ui/BookTrainer.dart';
import 'package:playhub/screens/SearchScreen/CityFilterDialog.dart';
import 'package:playhub/screens/playgroundScreen/playgroundscreen.dart';
import 'CategoryButton.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    // AppCubit.get(context).getTrainers();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
              title: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: AppCubit.get(context).searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: AppColors.grey),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: AppColors.black),
                      onChanged: (value) {
                        AppCubit.get(context).changeSearchQuery(value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list,
                        color: AppColors.darkGreen),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CityFilterDialog(
                            onCitySelected: (city) {
                              AppCubit.get(context).changeSelectedCity(city);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              bottom: TabBar(
                labelColor: AppColors.darkGreen,
                unselectedLabelColor: AppColors.grey,
                onTap: (index) {
                  AppCubit.get(context).changeTabIndex(index);
                },
                tabs: [
                  const Tab(text: 'Playgrounds'),
                  const Tab(text: 'Trainer'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildPlaygroundsTab(context),
                _buildTrainerTab(context),
              ],
            ),
            backgroundColor: AppColors.white,
          ),
        );
      },
    );
  }

  Widget _buildPlaygroundsTab(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryButton(
                  text: "All",
                  isSelected: AppCubit.get(context).selectedCategory == "All",
                  onTap: () {
                    AppCubit.get(context).changeSelectedCategory("All");
                  },
                ),
                CategoryButton(
                  text: "WorkOut",
                  isSelected: AppCubit.get(context).selectedCategory == "4",
                  onTap: () {
                    AppCubit.get(context).changeSelectedCategory("4");
                  },
                ),
                CategoryButton(
                  text: "Football",
                  isSelected: AppCubit.get(context).selectedCategory == "2",
                  onTap: () {
                    AppCubit.get(context).changeSelectedCategory("2");
                  },
                ),
                CategoryButton(
                  text: "VolleyBall",
                  isSelected: AppCubit.get(context).selectedCategory == "3",
                  onTap: () {
                    AppCubit.get(context).changeSelectedCategory("3");
                  },
                ),
                CategoryButton(
                  text: "BasketBall",
                  isSelected: AppCubit.get(context).selectedCategory == "5",
                  onTap: () {
                    AppCubit.get(context).changeSelectedCategory("5");
                  },
                ),
                CategoryButton(
                  text: "Tennis",
                  isSelected: AppCubit.get(context).selectedCategory == "1",
                  onTap: () {
                    AppCubit.get(context).changeSelectedCategory("1");
                  },
                ),
                // Add more categories as needed
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: AppCubit.get(context).items.length,
            itemBuilder: (context, index) {
              final playground = AppCubit.get(context).items[index];
              final name = playground['Name'];
              final city = playground['City'];
              final imageUrl = playground['Image'];
              // final playgroundId = playground['Id'];
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PlayGroundScreen(
                  //             name, city, imageUrl, playgroundId)));
                },
                child: Container(
                  width: 200.w,
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.green3,
                    boxShadow: [
                      const BoxShadow(
                        color: AppColors.green2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      imageUrl != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
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
                              child: Icon(Icons.image, size: 70),
                            ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: AppColors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            city,
                            style: TextStyle(
                              color: AppColors.black.withOpacity(0.4),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrainerTab(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        if (state is GetTrainersLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetTrainersErrorState) {
          return const Center(child: Text('Failed to load trainers'));
        } else {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: AppCubit.get(context).filteredTrainers.length,
            itemBuilder: (context, index) {
              final trainer = AppCubit.get(context).filteredTrainers[index];
              log(trainer.id);
              return GestureDetector(
                onTap: () {
                  AppCubit.get(context).getTrainerPackagesById(trainer.id
                      .toString()); // Fetch trainer packages using trainer ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Booktrainer(trainer: trainer),
                    ),
                  );
                },
                child: Container(
                  width: 200.w,
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.green3,
                    boxShadow: [
                      const BoxShadow(
                        color: AppColors.green2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      trainer.image != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.network(
                                  trainer.image!,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.image, size: 70),
                            ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            trainer.fullName ?? "",
                            style: TextStyle(
                              color: AppColors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            trainer.city ?? "",
                            style: TextStyle(
                              color: AppColors.black.withOpacity(0.4),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      !AppCubit.get(context)
                              .favoritesTrainersId
                              .contains(trainer.id)
                          ? IconButton(
                              icon: const Icon(
                                Icons.favorite_border_rounded,
                                color: AppColors.darkGreen,
                                size: 30,
                              ),
                              onPressed: () {
                                AppCubit.get(context)
                                    .addTrainerToFavorites(trainer.id)
                                    .then((_) {
                                  if (AppCubit.get(context).state
                                      is AddPlaygroundToFavoritesSuccessState) {
                                    AppCubit.get(context)
                                        .getFavoritesPlaygrounds();
                                  }
                                });
                              },
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.favorite_rounded,
                                color: AppColors.darkGreen,
                                size: 30,
                              ),
                              onPressed: () {
                                AppCubit.get(context)
                                    .deletePlaygroundFromFavorites(trainer.id)
                                    .then((_) {
                                  if (AppCubit.get(context).state
                                      is DeletePlaygroundFromFavoritesSuccessState) {
                                    AppCubit.get(context)
                                        .getFavoritesPlaygrounds();
                                  }
                                });
                              },
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
