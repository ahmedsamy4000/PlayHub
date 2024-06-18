import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/features/profile/cubits/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = getUserData();
    var cubit = BlocProvider.of<ProfileCubit>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PopupMenuButton(
                color: Colors.white,
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.darkGreen,
                        radius: 50,
                        child: Text(
                          'D',
                          style:
                              TextStyle(fontSize: 40, color: AppColors.white),
                        ),
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
                      const Text(
                        'Doha Ahmed',
                        style: TextStyle(
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
                            const Text(
                              'Player',
                              style: TextStyle(
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
                            const Text(
                              'Cairo',
                              style: TextStyle(
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
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    log('User ID: ${user?.uid}');

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      log('User Data: $data');
      return data;
    }
    return null;
  }
}
