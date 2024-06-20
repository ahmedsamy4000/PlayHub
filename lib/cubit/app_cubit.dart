import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/models/ordermodel.dart';
import 'package:playhub/models/playgroundmodel.dart';
import 'package:playhub/screens/HomeScreen/home.dart';
import 'package:toastification/toastification.dart';

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

  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  String selectedCategory = "All";
  String selectedCity = "";

  void changeSearchQuery(String val) {
    searchQuery = val;
    emit(AppChangeSearchQuery());
  }

  void changeSelectedCategory(String val) {
    selectedCategory = val;
    emit(AppChangeSelectedCategory());
  }

  void changeSelectedCity(String city) {
    selectedCity = city;
    emit(AppChangeSelectedCity()); // Emit a new state for city selection
  }

  late var userData;

  Future<void> getCurrentUserData() async {
    emit(GetCurrentUserLoadingState());
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        final snapshot =
            await FirebaseFirestore.instance.collection('Users').get();

        for (var doc in snapshot.docs) {
          if (user.uid == doc.data()['Id']) userData = doc.data();
        }
        log('$userData');
        if (userData != null) emit(GetCurrentUserSuccessState());
      }
    } catch (e) {
      emit(GetCurrentUserErrorState());
    }
  }

  Future updateUserInfo(
      {required String name,
      required String phone,
      required String email}) async {
    emit(UpdateUserInfoLoadingState());
    try {
      await getCurrentUserData();
      late var id;
      var newUser = UserModel(
          id: userData['Id'],
          fullName: name,
          email: email,
          phoneNumber: phone,
          type: userData['Type'] == 'Player'
              ? UserType.player
              : userData['Type'] == 'Trainer'
                  ? UserType.trainer
                  : UserType.playgroundOwner,
          city: userData['City'],
          image: userData['Image'],
          region: userData['Region']);
      final snapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      for (var doc in snapshot.docs) {
        if (userData['Id'] == doc.data()['Id']) id = doc.id;
      }
      if (id != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(id)
            .update(newUser.toJson());
      }
      emit(UpdateUserInfoSuccessState());
    } catch (e) {
      emit(UpdateUserInfoErrorState());
    }
  }

  Future<void> updateUserImage(String image) async {
    await getCurrentUserData();
    late var id;
    var newUser = UserModel(
        id: userData['Id'],
        fullName: userData['Name'],
        email: userData['Email'],
        phoneNumber: userData['PhoneNumber'],
        type: userData['Type'] == 'Player'
            ? UserType.player
            : userData['Type'] == 'Trainer'
                ? UserType.trainer
                : UserType.playgroundOwner,
        city: userData['City'],
        image: image,
        region: userData['Region']);
    final snapshot = await FirebaseFirestore.instance.collection('Users').get();
    for (var doc in snapshot.docs) {
      if (userData['Id'] == doc.data()['Id']) id = doc.id;
    }
    if (id != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .update(newUser.toJson());
    }
  }

  Future pickImageFromGallery() async {
    emit(ChangeProfilePhotoLoadingState());
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage != null) {
        File selectedImage = File(returnedImage.path);
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Reference ref =
              storage.ref().child('profile_images').child('${user.uid}.jpg');
          UploadTask uploadTask = ref.putFile(selectedImage);

          await uploadTask;

          String downloadURL = await ref.getDownloadURL();

          await user.updatePhotoURL(downloadURL);

          await updateUserImage(downloadURL);

          emit(ChangeProfilePhotoSuccessState());
        }
      }
    } catch (e) {
      emit(ChangeProfilePhotoErrorState());
    }
  }

  Future pickImageFromCamera() async {
    emit(ChangeProfilePhotoLoadingState());
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (returnedImage != null) {
        File selectedImage = File(returnedImage.path);
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Reference ref =
              storage.ref().child('profile_images').child('${user.uid}.jpg');
          UploadTask uploadTask = ref.putFile(selectedImage);

          await uploadTask;

          String downloadURL = await ref.getDownloadURL();

          await user.updatePhotoURL(downloadURL);

          await updateUserImage(downloadURL);

          emit(ChangeProfilePhotoSuccessState());
        }
      }
    } catch (e) {
      emit(ChangeProfilePhotoErrorState());
    }
  }

  Future<void> changePassword(BuildContext context,
      {required String currentPassword, required String newPassword}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: currentPassword);

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);

        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 5),
          title: const Text('Password updated successfully'),
          alignment: Alignment.topRight,
          direction: TextDirection.ltr,
          icon: const Icon(Icons.check_circle_outline),
          primaryColor: Colors.green[700],
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x07000000),
              offset: Offset(0, 16),
              spreadRadius: 0,
            )
          ],
          showProgressBar: false,
          closeButtonShowType: CloseButtonShowType.onHover,
          closeOnClick: false,
          pauseOnHover: true,
          dragToClose: true,
        );
        Navigator.pop(context);
      } catch (e) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 5),
          title: const Text('Current password is incorrect'),
          alignment: Alignment.topRight,
          direction: TextDirection.ltr,
          icon: const Icon(Icons.error),
          primaryColor: Colors.red[700],
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x07000000),
              offset: Offset(0, 16),
              spreadRadius: 0,
            )
          ],
          showProgressBar: false,
          closeButtonShowType: CloseButtonShowType.onHover,
          closeOnClick: false,
          pauseOnHover: true,
          dragToClose: true,
        );
      }
    }
  }

  Future<void> logout() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseAuth.instance.signOut();
        emit(UserLogoutSuccessState());
      } catch (e) {
        emit(UserLogoutErrorState());
      }
    }
  }

  Future<void> deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.delete();
        emit(DeleteUserSuccessState());
      } catch (e) {
        emit(DeleteUserErrorState());
      }
    }
  }

  List<Map<String, dynamic>> categoryPlaygrounds = [];
  List<String> playgroundsId = [];
  Future<void> getCategoryPlaygrounds(String categoryId) async {
    emit(GetCategoryPlaygroundsLoadingState());
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('PlayGrounds').get();
           List<Map<String, dynamic>> newCategoryPlaygrounds = [];
           List<String> newPlaygroundsId = [];
      for (var doc in snapshot.docs) {
        if (categoryId == doc.data()['CategoryId']) {
          newCategoryPlaygrounds.add(doc.data());
          newPlaygroundsId.add(doc.id);
        }
        categoryPlaygrounds = newCategoryPlaygrounds;
        playgroundsId = newPlaygroundsId;
        log('$categoryPlaygrounds');
        emit(GetCategoryPlaygroundsSuccessState());
      }
    } catch (e) {
      log('$e');
      emit(GetCategoryPlaygroundsErrorState());
    }
  }

  // Map<String, Map<String, dynamic>> categoryPlaygrounds = {};

  // Future<void> getCategoryPlaygrounds(String categoryId) async {
  //   emit(GetCategoryPlaygroundsLoadingState());
  //   try {
  //     final snapshot =
  //         await FirebaseFirestore.instance.collection('PlayGrounds').get();
  //          Map<String, Map<String, dynamic>> newCategoryPlaygrounds = {};

  //     for (var doc in snapshot.docs) {
  //       if (categoryId == doc.data()['CategoryId']) {
  //         newCategoryPlaygrounds[doc.id] = doc.data();
  //       }
  //       categoryPlaygrounds = newCategoryPlaygrounds;
  //       log('$categoryPlaygrounds');
  //       emit(GetCategoryPlaygroundsSuccessState());
  //     }
  //   } catch (e) {
  //     log('$e');
  //     emit(GetCategoryPlaygroundsErrorState());
  //   }
  // }

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
