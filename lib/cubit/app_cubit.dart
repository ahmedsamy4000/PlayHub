import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/playgrounds/ui/screens/playgrounds_screen.dart';
import 'package:playhub/features/profile/data/trainer_package_model.dart';
import 'package:playhub/features/profile/ui/screens/profile_screen.dart';
import 'package:playhub/features/rooms/ui/screens/rooms_screen.dart';
import 'package:playhub/models/bookingmodel.dart';
import 'package:playhub/models/ordermodel.dart';
import 'package:playhub/models/playgroundmodel.dart';
import 'package:playhub/screens/HomeScreen/home.dart';
import 'package:playhub/screens/Statistics/statistics_screen.dart';
import 'package:toastification/toastification.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentScreenIdx = 0;
  List<Widget> pages = [
    const Home(),
    RoomsScreen(),
    const PlaygroundsScreen(),
    StatisticsScreen(),
    const Home(),
    const ProfileScreen(),
  ];

  void changeScreenIdx(int idx) {
    currentScreenIdx = idx;
    emit(AppChangeBottomNavBarScreen());
  }

  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  String selectedCategory = "All";
  String selectedCity = "All";

  void changeSearchQuery(String val) {
    searchQuery = val;
    searchFunction();
    emit(AppChangeSearchQuery());
  }

  void changeSelectedCategory(String val) {
    selectedCategory = val;
    emit(AppChangeSelectedCategory());
  }

  void changeSelectedCity(String city) {
    selectedCity = city;
    searchFunction();
    emit(AppChangeSelectedCity());
  }

  var items = [];
  List<T> getCommonElements<T>(List<T> list1, List<T> list2) {
    // Convert lists to sets
    Set<T> set1 = list1.toSet();
    Set<T> set2 = list2.toSet();

    // Find the intersection of the two sets
    Set<T> intersection = set1.intersection(set2);

    // Convert the result back to a list
    return intersection.toList();
  }

  Future<void> searchFunction() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('PlayGrounds').get();
    var newItems = [];
    var Names = [];
    for (var doc in snapshot.docs) {
      var itemData = doc.data() as Map<String, dynamic>;
      if (itemData['Name']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          searchQuery.isEmpty) {
        Names.add(itemData);
      }
      if (itemData['City'] == selectedCity || selectedCity == "All") {
        newItems.add(itemData);
      }

      // log("$items");
      // log("$matchesCity");
      // log("$selectedCity");
      // items = matchesCity
    }
    if (Names.length == 0) {
      items = newItems;
    } else if (newItems.length == 0) {
      items = Names;
    } else {
      items = getCommonElements(newItems, Names);
    }

    log("$items");

    emit(AppChangeSearchFunction());
  }

  List<TrainingPackage> packages = [];

  void addPackage(
      String description, double price, int duration, String trainerId) {
    final newPackage = TrainingPackage(
      description: description,
      price: price,
      duration: duration,
      trainerId: trainerId,
    );
    CollectionReference ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Package');
    ref.add(newPackage.toJson());

    emit(PackageAdded(newPackage));
  }

  void getTrainerPackages(String trainerId) {
    emit(GetTrainerPackagesLoadingState());
    FirebaseFirestore.instance
        .collection('packages')
        .where('trainerId', isEqualTo: trainerId)
        .get()
        .then((value) {
      packages =
          value.docs.map((e) => TrainingPackage.fromJson(e.data())).toList();
      emit(GetTrainerPackagesSuccessState());
    }).catchError((error) {
      emit(GetTrainerPackagesErrorState(error.toString()));
    });
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
        print(user.uid);
        for (var doc in snapshot.docs) {
          if (user.uid == doc.data()['Id']) {
            userId = doc.id;
            userData = doc.data();
          }
        }
        log('$userData');
        if (userData != null) emit(GetCurrentUserSuccessState());
      }
    } catch (e) {
      emit(GetCurrentUserErrorState());
    }
  }

  Future<String> getUserDocID() async {
    await getCurrentUserData();
    late var id;
    final snapshot = await FirebaseFirestore.instance.collection('Users').get();
    if (userData != null) {
      for (var doc in snapshot.docs) {
        if (userData['Id'] == doc.data()['Id']) id = doc.id;
      }
    }
    return id;
  }

  Future updateUserInfo(
      {required String name,
      required String phone,
      required String email,
      String? city,
      String? region}) async {
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
          city: city ?? userData['City'],
          image: userData['Image'],
          region: region ?? userData['Region']);
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

        Fluttertoast.showToast(
          msg: 'Password updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.green,
          textColor: AppColors.white,
        );
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Current password is incorrect',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.red,
          textColor: AppColors.white,
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
    getCurrentUserData();
    late var uid;

    if (user != null) {
      try {
        if (userData != null) {
          final snapshot =
              await FirebaseFirestore.instance.collection('Users').get();
          for (var doc in snapshot.docs) {
            if (userData['Id'] == doc.data()['Id']) uid = doc.id;
          }
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .delete();
          await user.delete();
        }
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

  PlaygroundModel? playground;
  Future<void> getPlaygroundById(String id, String date) async {
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
        playground!.orders = customizeOrders(playground!.orders, date);
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

  String? userId;
  Future<void> addNewOrder(
      String? playGroundId, int? time, String? date, bool? booked) async {
    emit(AddNewOrderLoadingState());
    if (userData != null) {
      final snapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      for (var doc in snapshot.docs) {
        if (userData['Id'] == doc.data()['Id']) userId = doc.id;
      }
    }
    Ordermodel newModel = Ordermodel(
        userName: userData["Name"], booked: booked, date: date, time: time);

    BookingModel bookModel = BookingModel(
        categoryId: playground!.categoryId,
        playGroundName: playground!.name,
        userName: userData["Name"],
        booked: booked,
        date: date,
        time: time);
    CollectionReference ref = FirebaseFirestore.instance
        .collection('PlayGrounds')
        .doc(playGroundId)
        .collection('Orders');
    CollectionReference profileRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Booking');
    try {
      await ref.add(newModel.toJson());
      await profileRef.add(bookModel.toJson());
      print(playground!.categoryId);
      print("OrderAdded");
      emit(AddNewOrderSuccessState());
    } catch (e) {
      print(e);
      emit(AddNewOrderErrorState());
    }
  }

  List<Ordermodel> customizeOrders(List<Ordermodel> orders, String date) {
    List<Ordermodel> playgroundOrders = [];
    for (int i = 1; i <= 12; i++) {
      Ordermodel? matchedOrder = orders.firstWhere(
          (order) => order.time == i && order.date == date,
          orElse: () => Ordermodel(
              userName: "__",
              time: i,
              date: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
              booked: false));
      playgroundOrders.add(matchedOrder);
    }
    return playgroundOrders;
  }

  List<BookingModel> bookings = [];
  Future<void> getbookingByCategories(String? categoryId) async {
    emit(GetBookingListLoadingState());
    bookings = [];
    try {
      CollectionReference bookRef = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Booking');

      QuerySnapshot snapshot = await bookRef.get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        log("$data");
        if (data["CategoryId"] == categoryId) {
          bookings.add(BookingModel.fromJson(data));
        }
      }
      print(bookings.length);
      emit(GetBookingListSuccessState());
    } catch (error) {
      print(error);
      emit(GetBookingListErrorState());
    }
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

  Future<void> addPlaygroundToFavorites(String id) async {
    try {
      late var uid;
      getCurrentUserData();
      final fPlayground = await FirebaseFirestore.instance
          .collection('PlayGrounds')
          .doc(id)
          .get();
      final snapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      for (var doc in snapshot.docs) {
        if (userData['Id'] == doc.data()['Id']) uid = doc.id;
      }
      if (fPlayground.exists) {
        Map<String, dynamic> favPlayground = fPlayground.data()!;
        favPlayground.addAll({"Id": id});
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('PFavorites')
            .add(favPlayground);
      }
      // getFavoritesPlaygrounds();
      emit(AddPlaygroundToFavoritesSuccessState());
    } catch (e) {
      log('$e');
      emit(AddPlaygroundToFavoritesErrorState());
    }
  }

  Future<void> deletePlaygroundFromFavorites(String id) async {
    try {
      var uid = await getUserDocID();
      late var pid;
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('PFavorites')
          .get();
      for (var doc in snapshot.docs) {
        if (id == doc.data()['Id']) pid = doc.id;
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('PFavorites')
          .doc(pid)
          .delete();
      getFavoritesPlaygrounds();
      emit(DeletePlaygroundFromFavoritesSuccessState());
    } catch (e) {
      log('$e');
      emit(DeletePlaygroundFromFavoritesErrorState());
    }
  }

  List<Map<String, dynamic>> favoritesPlaygrounds = [];
  List<String> favoritesId = [];

  Future<void> getFavoritesPlaygrounds() async {
    favoritesPlaygrounds = [];
    favoritesId = [];
    emit(GetFavoritesPlaygroundsLoadingState());
    try {
      var uid = await getUserDocID();
      List<String> ids = [];
      var playgrounds = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('PFavorites')
          .get();
      for (var doc in playgrounds.docs) {
        ids.add(doc.data()['Id']);
      }
      favoritesPlaygrounds = playgrounds.docs.map((doc) => doc.data()).toList();
      favoritesId = ids;
      log('Favorites: $favoritesId');
      emit(GetFavoritesPlaygroundsSuccessState());
    } catch (e) {
      log('$e');
      emit(GetFavoritesPlaygroundsErrorState());
    }
  }

  List<String> categoriesNames = [];

  Future<void> getCategories() async {
    categoriesNames = [];
    List<String> names = [];
    final snapshot =
        await FirebaseFirestore.instance.collection('Categories').get();
    for (var doc in snapshot.docs) {
      names.add(doc.data()['Name']);
    }
    categoriesNames = names;
    emit(GetCategoriesSuccessState());
  }

  String? playgroundImage;
  Future pickPlaygroundImageFromGallery() async {
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

          playgroundImage = await ref.getDownloadURL();
          log('$playgroundImage');

          emit(ChangeProfilePhotoSuccessState());
        }
      }
    } catch (e) {
      emit(ChangeProfilePhotoErrorState());
    }
  }

  Future<void> addNewPlayground(
      {required name,
      required category,
      required city,
      required region,
      required image}) async {
    String c = city;
    final snapshot =
        await FirebaseFirestore.instance.collection('Categories').get();
    await getCurrentUserData();
    var id;
    for (var doc in snapshot.docs) {
      if (category == doc.data()['Name']) {
        id = doc.data()['Id'];
        log('${doc.data()['Id']}');
      }
    }
    if (userData != null) {
      await FirebaseFirestore.instance.collection('PlayGrounds').add({
        'CategoryId': id,
        'City': city,
        'Image': image,
        'Name': name,
        'Owner_id': userData['Id'],
        'Region': region,
      });
    }
  }

  List<Map<String, int>> playgroundStatistics = [];
  late int sum = 0;

  Future<void> Pola(String month) async {
    sum = 0;
    playgroundStatistics = [];
    try {
      List<Map<String, int>> filtered = [];
      final snapshot =
          await FirebaseFirestore.instance.collection('PlayGrounds').get();
      for (var doc in snapshot.docs) {
        final orders = await FirebaseFirestore.instance
            .collection('PlayGrounds')
            .doc(doc.id)
            .collection('Orders')
            .get();
        int count = 0;
        for (var order in orders.docs) {
          if (order.data()['Date'][3] + order.data()['Date'][4] == month)
            count++;
        }
        if (count > 0) {
          sum += count;
          filtered.add({doc.data()['Name']: count});
        }
      }
      filtered.sort((a, b) => b.values.first.compareTo(a.values.first));

      if (filtered.length >= 5) {
        playgroundStatistics = filtered.sublist(0, 5);
      } else {
        playgroundStatistics = filtered;
      }
      log('Polaaaaaaa: $playgroundStatistics');
      emit(GetStatisticsSuccessState());
    } catch (e) {
      log('$e');
      emit(GetStatisticsErrorState());
    }
  }

  String? month;
  void changeMonth(String? value) {
    month = value;
    if (month != null) Pola(month!);
    emit(ChangeMonthSuccessState());
  }
}
