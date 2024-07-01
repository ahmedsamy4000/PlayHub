import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/common/fade_in_slide.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/Trainer/widgets/book_trainer_package.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/authentication/ui/widgets/custom_login_button.dart';

class Booktrainer extends StatelessWidget {
  final UserModel trainer; // Accept trainer data

  const Booktrainer({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    // cubit.getTrainerPackagesById(trainer.id.toString()); // Fetch trainer packages using trainer ID

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text(""),
        ),
        body: Column(
          children: [
            Padding(
              padding: 16.padAll,
              child: Row(
                children: [
                  trainer.image == null
                      ? CircleAvatar(
                          backgroundColor: AppColors.darkGreen,
                          radius: 50,
                          child: Text(
                            trainer.fullName?.substring(0, 1) ?? '',
                            style: const TextStyle(
                                fontSize: 40, color: AppColors.white),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: AppColors.darkGreen,
                          backgroundImage: NetworkImage(trainer.image!),
                          radius: 50,
                        ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer.fullName ?? '',
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.green3,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Text(
                              trainer.type == UserType.player
                                  ? 'Player'
                                  : trainer.type == UserType.trainer
                                      ? 'Trainer'
                                      : 'Owner',
                              style: const TextStyle(
                                  color: AppColors.darkGray,
                                  fontSize: 15,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold),
                            ),
                            trainer.city != null && trainer.city!.isNotEmpty
                                ? const SizedBox(
                                    width: 10,
                                  )
                                : Container(),
                            trainer.city != null && trainer.city!.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Container(
                                      color: AppColors.darkGray.withOpacity(.4),
                                      width: 1,
                                      height: 20,
                                    ),
                                  )
                                : Container(),
                            trainer.city != null && trainer.city!.isNotEmpty
                                ? const SizedBox(
                                    width: 10,
                                  )
                                : Container(),
                            trainer.city != null && trainer.city!.isNotEmpty
                                ? Text(
                                    trainer.city!,
                                    style: const TextStyle(
                                        color: AppColors.darkGray,
                                        fontSize: 15,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.bold),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            state is GetTrainerPackagesLoadingState
                ? const Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : state is GetTrainerPackagesErrorState
                    ? Padding(
                        padding: const EdgeInsets.only(top: 200),
                        child: Center(
                          child: Text(
                            'Failed to load packages.',
                            style: TextStyle(
                                fontFamily: 'Open Sans', fontSize: 16),
                          ),
                        ),
                      )
                    : cubit.packages.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 200),
                            child: Center(
                              child: Text(
                                'No packages available.',
                                style: TextStyle(
                                    fontFamily: 'Open Sans', fontSize: 16),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: cubit.packages.length,
                              itemBuilder: (context, index) {
                                final package = cubit.packages[index];
                                return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: 20.padAll,
                                    width: 200.w,
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.green3,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.green2,
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  package.description,
                                                  style: TextStyle(
                                                    color: AppColors.black
                                                        .withOpacity(0.7),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Text(
                                                  "${package.price}",
                                                  style: TextStyle(
                                                    color: AppColors.black
                                                        .withOpacity(0.4),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  "${package.duration}",
                                                  style: TextStyle(
                                                    color: AppColors.black
                                                        .withOpacity(0.7),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          right: 8,
                                          child: !(cubit.playerPackagesId.contains(cubit.packagesId[index]))? LoginButton(
                                            onTap: () {
                                              log('${cubit.packagesId[index]}');
                                              log('${cubit.playerPackagesId}');
                                              showAnimatedDialog(
                                                context,
                                                package.description,
                                                package.duration.toString(),
                                                package.price.toString(),
                                                trainer.id.toString(),
                                                trainer.fullName.toString(),
                                                index,
                                              );
                                            },
                                            text: "Book",
                                            gradiantColor: AppColors
                                                .loginGradiantColorButton,
                                            tapedGradiantColor: AppColors
                                                .loginGradiantColorButtonTaped,
                                          ) : LoginButton(
                                            onTap: () {
                                            },
                                            text: "Booked",
                                            gradiantColor: AppColors
                                                .loginGradiantColorButton,
                                            tapedGradiantColor: AppColors
                                                .loginGradiantColorButtonTaped,
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
        backgroundColor: AppColors.white,
      ),
    );
  }
}
