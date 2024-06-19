import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/screens/HomeScreen/home.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentScreenIdx = 0;
  List<Widget> pages = [
    Home(),
  ];

  void changeScreenIdx(int idx){
    currentScreenIdx = idx;
    emit(AppChangeBottomNavBarScreen());
  }

  File? selectedImage;

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      var userData;

      for (var doc in snapshot.docs) {
        if (user.uid == doc.data()['Id']) userData =  doc.data();
      }
      log('$userData');
      return userData;
    }
    return null;
  }

  Future pickImageFromGallery() async {
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage != null) {
        selectedImage = File(returnedImage.path);
        emit(ChangeProfilePhotoSuccessState());
      }
    } catch (e) {
      emit(ChangeProfilePhotoFailedState());
    }
  }

  Future pickImageFromCamera() async {
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (returnedImage != null) {
        selectedImage = File(returnedImage.path);
        emit(ChangeProfilePhotoSuccessState());
      }
    } catch (e) {
      emit(ChangeProfilePhotoFailedState());
    }
  }

  // String? img;
  // Future<void> getPlayGrounds() async {
  //   QuerySnapshot snap =
  //       await FirebaseFirestore.instance.collection('PlayGrounds').get();
  //   DocumentSnapshot docsnap = snap.docs.first;
  //   img = docsnap.get('Image');
  // }
}
