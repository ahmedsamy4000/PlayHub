import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/features/profile/ui/screens/edit_info_screen.dart';
import 'package:playhub/features/profile/ui/widgets/basketball.dart';
import 'package:playhub/features/profile/ui/widgets/football.dart';
import 'package:playhub/features/profile/ui/widgets/tennis.dart';
import 'package:playhub/features/profile/ui/widgets/volleyball.dart';
import 'package:playhub/features/profile/ui/widgets/workout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    var user = cubit.getCurrentUserData();
    return FutureBuilder(
      future: user,
      builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>?> snapshot) =>
          DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PopupMenuButton(
                    color: Colors.white,
                    itemBuilder: (context) => [
                           PopupMenuItem(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditInformationScreen()));
                            },
                            child: const Text(
                              'Edit Information',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            child: Text(
                              'Delete Account',
                              style: TextStyle(
                                color: Color.fromRGBO(239, 83, 80, 1),
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                color: Color.fromRGBO(239, 83, 80, 1),
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
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
                        snapshot.data?['Image'] == null
                            ? CircleAvatar(
                                backgroundColor: AppColors.darkGreen,
                                radius: 50,
                                child: Text(
                                  snapshot.data == null
                                      ? ''
                                      : '${snapshot.data?['Name'][0]}',
                                  style: const TextStyle(
                                      fontSize: 40, color: AppColors.white),
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snapshot.data?['Image']),
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
                                            title: const Text(
                                              'Photo Library',
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onTap: () {
                                              cubit.pickImageFromGallery();
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey,
                                            ),
                                            title: const Text(
                                              'Camera',
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onTap: () {
                                              cubit.pickImageFromCamera();
                                              Navigator.pop(context);
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
                          snapshot.data == null
                              ? ''
                              : '${snapshot.data?['Name']}',
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
                                snapshot.data == null
                                    ? 'Player'
                                    : '${snapshot.data?['Type']}',
                                style: const TextStyle(
                                    color: AppColors.darkGray,
                                    fontSize: 15,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Container(
                                  color: AppColors.darkGray.withOpacity(.4),
                                  width: 1,
                                  height: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                snapshot.data == null
                                    ? 'Cairo'
                                    : '${snapshot.data?['City'] ?? 'Cairo'}',
                                style: const TextStyle(
                                    color: AppColors.darkGray,
                                    fontSize: 15,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold),
                              ),
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
              const TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(
                    child: Text(
                      'Football',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Volleyball',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Basketball',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Tennis',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Workout',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
                labelColor: Colors.black,
                indicatorColor: AppColors.darkGreen,
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    FootballTab(),
                    VolleyballTab(),
                    BasketballTab(),
                    TennisTab(),
                    WorkoutTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}