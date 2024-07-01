import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/common/fade_in_slide.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/Trainer/ui/BookTrainer.dart';
import 'package:playhub/screens/playgroundScreen/playgroundscreen.dart';

class FavoritesTrainers extends StatelessWidget {
  const FavoritesTrainers({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) => state is GetFavoritesTrainersLoadingState
            ? const Center(child: CircularProgressIndicator())
            : state is GetFavoritesTrainersSuccessState
                ? cubit.favoritesTrainers.isEmpty
                    ? const Center(
                        child: Text('No Favorites Trainers Yet.'),
                      )
                    : ListView.builder(
                        itemCount: cubit.favoritesTrainers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              cubit.getTrainerPackagesById(cubit
                                  .favoritesTrainers[index]
                                  .id!); 
                                  cubit.getPlayerBookedPackage();// Fetch trainer packages using trainer ID
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Booktrainer(
                                      trainer: cubit.favoritesTrainers[index]),
                                ),
                              );
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
                                      cubit.favoritesTrainers[index].image ==
                                              null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 8),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    AppColors.darkGreen,
                                                radius: 30,
                                                child: Text(
                                                  '${cubit.favoritesTrainers[index].fullName?[0]}',
                                                  style: const TextStyle(
                                                      fontSize: 40,
                                                      color: AppColors.white),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 8),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    AppColors.darkGreen,
                                                backgroundImage: NetworkImage(
                                                    cubit
                                                        .favoritesTrainers[
                                                            index]
                                                        .image!),
                                                radius: 30,
                                              ),
                                            ),
                                      10.horizontalSpace,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cubit.favoritesTrainers[index]
                                                    .fullName ??
                                                '',
                                            style: const TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            cubit.favoritesTrainers[index]
                                                    .city ??
                                                '',
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
                                              .deleteTrainerFromFavorites(cubit
                                                  .favoritesTrainers[index].id!)
                                              .then((_) {
                                            if (cubit.state
                                                is DeleteTrainerFromFavoritesSuccessState) {
                                              cubit.getFavoritesTrainers();
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
                        })
                : Container());
  }
}
