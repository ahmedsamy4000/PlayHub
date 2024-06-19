import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/models/ordermodel.dart';
import 'package:playhub/models/playgroundmodel.dart';
import 'package:playhub/screens/HomeScreen/home.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentScreenIdx = 0;
  List<Widget> pages = [
    Home(),
  ];

  void changeScreenIdx(int idx) {
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
        if (user.uid == doc.data()['Id']) userData = doc.data();
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

  PlaygroundModel? playground;
  Future<void> getPlaygroundById(String id) async {
    emit(GetPlaygroundDataLoadingState());
    try {
      DocumentSnapshot playgroundDoc = await FirebaseFirestore.instance
          .collection('PlayGrounds')
          .doc(id)
          .get();
      if (playgroundDoc.exists) {
        QuerySnapshot ordersSnapshot =
            await playgroundDoc.reference.collection('Orders').get();
        playground = PlaygroundModel.fromJson(
            playgroundDoc.data() as Map<String, dynamic>,
            playgroundDoc.id,
            ordersSnapshot.docs.toList());
        playground!.orders = customizeOrders(playground!.orders);
        // playground!.orders.forEach((element) {
        //   print("time is ${element.time} and result is ${element.booked}");
        // });
        emit(GetPlaygroundDataSuccessState());
      }
    } catch (error) {
      print(error);
      emit(GetPlaygroundDataErrorState());
    }
  }

  List<Ordermodel> customizeOrders(List<Ordermodel> orders) {
    List<Ordermodel> playgroundOrders = [];
    for (int i = 1; i <= 12; i++) {
      Ordermodel? matchedOrder = orders.firstWhere((order) => order.time == i,
          orElse: () => Ordermodel(
              userName: "__", time: i, date: "19-2-2024", booked: false));
      playgroundOrders.add(matchedOrder);
    }
    return playgroundOrders;
  }

  List<DateTime> daysPerWeek = [];
  void fillWeek() {
    for (int i = 0; i < 7; i++) {
      daysPerWeek.add(DateTime.now().add(Duration(days: i)));
    }
    daysPerWeek.forEach((element) {
      print(element.toString());
    });
    emit(GetPlaygroundDataErrorState());
  }
  // String? img;
  // Future<void> getPlayGrounds() async {
  //   QuerySnapshot snap =
  //       await FirebaseFirestore.instance.collection('PlayGrounds').get();
  //   DocumentSnapshot docsnap = snap.docs.first;
  //   img = docsnap.get('Image');
  // }
}
