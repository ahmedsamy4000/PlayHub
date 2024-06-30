import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/Layout/MainApp.dart';
import 'package:playhub/common/fade_in_slide.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/authentication/ui/screens/login_screen.dart';
import 'package:playhub/features/authentication/ui/screens/type_screen.dart';
import 'package:playhub/features/playgrounds/ui/screens/add_playground.dart';
import 'package:playhub/features/playgrounds/ui/screens/update_playground.dart';
import 'package:playhub/features/profile/ui/screens/change_password_screen.dart';
import 'package:playhub/features/profile/ui/screens/edit_info_screen.dart';
import 'package:playhub/features/Trainer/widgets/trainer_add_package.dart';
import 'package:playhub/features/profile/ui/widgets/basketball.dart';
import 'package:playhub/features/profile/ui/widgets/football.dart';
import 'package:playhub/features/Trainer/widgets/package_card.dart';
import 'package:playhub/features/profile/ui/widgets/tennis.dart';
import 'package:playhub/features/profile/ui/widgets/volleyball.dart';
import 'package:playhub/features/profile/ui/widgets/workout.dart';
import 'package:playhub/generated/l10n.dart';
import 'package:playhub/screens/playgroundScreen/playgroundscreen.dart';

import '../../../../common/data/local/local_storage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    var userData = LocalStorage().userData;
    if (userData?.type == UserType.trainer) {
      cubit.getTrainerPackages();
    }
    if (userData?.type == UserType.playgroundOwner) {
      cubit.getOwnerPlaygrounds();
    }
    cubit.getOwnerPlaygrounds();
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) => state is DeletePlaygroundLoadingState ||
              state is ChangeProfilePhotoLoadingState ||
              state is UpdateUserInfoLoadingState
          ? const Scaffold(
              backgroundColor: AppColors.greenBackground,
              body: Center(child: CircularProgressIndicator()))
          : DefaultTabController(
              length: 5,
              child: Scaffold(
                backgroundColor: AppColors.greenBackground,
                appBar: AppBar(
                  backgroundColor: AppColors.greenBackground,
                  actions: [
                    IconButton(
                        onPressed: () {
                          showMenu(
                            color: AppColors.white,
                            context: context,
                            position: LocalStorage().language == 'en'
                                ? const RelativeRect.fromLTRB(200, 70, 50, 00)
                                : const RelativeRect.fromLTRB(50, 70, 200, 00),
                            items: [
                              PopupMenuItem(
                                onTap: () {
                                  cubit.changeLanguage('en');
                                },
                                child: Text(
                                  S.of(context).English,
                                  style: const TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  cubit.changeLanguage('ar');
                                },
                                child: Text(
                                  S.of(context).Arabic,
                                  style: const TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        icon: const Icon(Icons.language)),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: PopupMenuButton(
                          color: Colors.white,
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EditInformationScreen()));
                                  },
                                  child: Text(
                                    S.of(context).pop1,
                                    style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChangePasswordScreen()));
                                  },
                                  child: Text(
                                    S.of(context).pop2,
                                    style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    S.of(context).pop3,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(239, 83, 80, 1),
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  onTap: () {
                                    cubit.logout().then((_) async {
                                      if (cubit.state
                                          is UserLogoutSuccessState) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()));
                                        await LocalStorage().saveUserData(null);
                                        cubit.changeScreenIdx(0);
                                        log('${cubit.currentScreenIdx}');
                                      }
                                    });
                                  },
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    S.of(context).pop4,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(239, 83, 80, 1),
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  onTap: () {
                                    cubit.deleteUser();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TypeScreen()));
                                  },
                                ),
                              ]),
                    )
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              userData?.image == null
                                  ? CircleAvatar(
                                      backgroundColor: AppColors.darkGreen,
                                      radius: 50,
                                      child: Text(
                                        userData == null
                                            ? ''
                                            : '${userData.fullName?[0]}',
                                        style: const TextStyle(
                                            fontSize: 40,
                                            color: AppColors.white),
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: AppColors.darkGreen,
                                      backgroundImage:
                                          NetworkImage(userData!.image!),
                                      radius: 50,
                                    ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: AppColors.darkGreen,
                                  radius: 20,
                                  child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 120,
                                            color: AppColors.white,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.photo_library,
                                                    color: Colors.grey,
                                                  ),
                                                  title: Text(
                                                    S.of(context).Gallery,
                                                    style: const TextStyle(
                                                      fontFamily: 'Open Sans',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    cubit
                                                        .pickImageFromGallery()
                                                        .then((_) {
                                                      if (cubit.state
                                                          is ChangeProfilePhotoSuccessState) {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Main()));
                                                        userData?.type ==
                                                                    UserType
                                                                        .player ||
                                                                userData?.type ==
                                                                    UserType
                                                                        .admin
                                                            ? cubit
                                                                .changeScreenIdx(
                                                                    3)
                                                            : cubit
                                                                .changeScreenIdx(
                                                                    2);
                                                      }
                                                    });
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.grey,
                                                  ),
                                                  title: Text(
                                                    S.of(context).Camera,
                                                    style: const TextStyle(
                                                      fontFamily: 'Open Sans',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    cubit
                                                        .pickImageFromCamera()
                                                        .then((_) {
                                                      if (cubit.state
                                                          is ChangeProfilePhotoSuccessState) {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Main()));
                                                        userData?.type ==
                                                                    UserType
                                                                        .player ||
                                                                userData?.type ==
                                                                    UserType
                                                                        .admin
                                                            ? cubit
                                                                .changeScreenIdx(
                                                                    3)
                                                            : cubit
                                                                .changeScreenIdx(
                                                                    2);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData == null ? '' : '${userData.fullName}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.green3,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      userData == null
                                          ? ''
                                          : userData.type == UserType.player
                                              ? S.of(context).Player
                                              : userData.type ==
                                                      UserType.trainer
                                                  ? S.of(context).Trainer
                                                  : S.of(context).Owner,
                                      style: const TextStyle(
                                          color: AppColors.darkGray,
                                          fontSize: 15,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    userData?.city != null &&
                                            userData?.city != ''
                                        ? const SizedBox(
                                            width: 10,
                                          )
                                        : Container(),
                                    userData?.city != null &&
                                            userData?.city != ''
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Container(
                                              color: AppColors.darkGray
                                                  .withOpacity(.4),
                                              width: 1,
                                              height: 20,
                                            ),
                                          )
                                        : Container(),
                                    userData?.city != null &&
                                            userData?.city != ''
                                        ? const SizedBox(
                                            width: 10,
                                          )
                                        : Container(),
                                    userData?.city != null &&
                                            userData?.city != ''
                                        ? Text(
                                            userData!.city!,
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
                    const SizedBox(
                      height: 32,
                    ),
                    userData?.type == UserType.player
                        ? TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            tabs: [
                              Tab(
                                child: Text(
                                  S.of(context).Football,
                                  style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  S.of(context).Volleyball,
                                  style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  S.of(context).Basketball,
                                  style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  S.of(context).Tennis,
                                  style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  S.of(context).Workout,
                                  style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                            labelColor: Colors.black,
                            indicatorColor: AppColors.darkGreen,
                          )
                        : userData?.type == UserType.playgroundOwner
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Your Playgrounds',
                                      style: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  cubit.ownerPlaygrounds.isEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 200),
                                          child: Center(
                                            child: Text(
                                              'You have no playgrounds yet.',
                                              style: TextStyle(
                                                  fontFamily: 'Open Sans',
                                                  fontSize: 16),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              cubit.ownerPlaygrounds.length,
                                          itemBuilder: (context, index) {
                                            final playground =
                                                cubit.ownerPlaygrounds[index];
                                            final name = playground.name;
                                            final city = playground.city;
                                            final imageUrl = playground.image;
                                            final playgroundId = cubit
                                                .ownerPlaygroundsIds[index];

                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlayGroundScreen(
                                                            name,
                                                            city,
                                                            imageUrl,
                                                            playgroundId, playground.location),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8),
                                                child: FadeInSlide(
                                                  duration: 0.5 + (index / 10),
                                                  child: Card(
                                                    color: AppColors.white,
                                                    child: Row(
                                                      children: [
                                                        imageUrl != ''
                                                            ? Image.network(
                                                                imageUrl,
                                                                width: 120,
                                                                height: 100,
                                                                fit: BoxFit
                                                                    .cover)
                                                            : const Icon(
                                                                Icons.image,
                                                                size: 100),
                                                        10.horizontalSpace,
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              name,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${playground.region}, $city",
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                fontSize: 15,
                                                                color: AppColors
                                                                    .grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    cubit
                                                                        .getCategoryById(playground
                                                                            .categoryId)
                                                                        .then(
                                                                            (_) {
                                                                      cubit
                                                                          .getCategories()
                                                                          .then(
                                                                              (_) {
                                                                        if (cubit.state
                                                                            is GetCategoriesSuccessState) {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => UpdatePlaygroundScreen(playground: playground, categories: cubit.categoriesNames, id: playgroundId)));
                                                                        }
                                                                      });
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'UPDATE',
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .darkGreen,
                                                                        fontFamily:
                                                                            'Open Sans',
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                30.horizontalSpace,
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    cubit.deletePlayground(
                                                                        playgroundId);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'DELETE',
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .red,
                                                                        fontFamily:
                                                                            'Open Sans',
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                ],
                              )
                            : Container(),
                    userData?.type == UserType.player
                        ? const Expanded(
                            child: TabBarView(
                              children: [
                                FootballTab(),
                                VolleyballTab(),
                                BasketballTab(),
                                TennisTab(),
                                WorkoutTab(),
                              ],
                            ),
                          )
                        : Container(),
                    userData?.type == UserType.trainer
                        ? PackageWidget(cubit: cubit)
                        : Container(),
                  ],
                ),
                floatingActionButton: userData?.type == UserType.trainer ||
                        userData?.type == UserType.playgroundOwner
                    ? FloatingActionButton(
                        onPressed: () {
                          AppCubit.get(context).searchFunction().then((_) {
                            if (AppCubit.get(context).state
                                is AppChangeSearchFunction) {
                              userData?.type == UserType.trainer
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddPackage(
                                                trainerId: userData!.id!,
                                              )))
                                  : cubit.getCategories().then((_) {
                                      if (cubit.state
                                          is GetCategoriesSuccessState) {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return AddPlaygroundScreen(
                                            categories: cubit.categoriesNames,
                                          );
                                        }));
                                      }
                                    });
                            }
                          });
                        },
                        backgroundColor: AppColors.darkGreen,
                        child: const Icon(
                          Icons.add,
                          color: AppColors.white,
                        ),
                      )
                    : null,
                floatingActionButtonLocation: userData?.type == UserType.trainer
                    ? FloatingActionButtonLocation.endFloat
                    : null,
              ),
            ),
    );
  }
}
