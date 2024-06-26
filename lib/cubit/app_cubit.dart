import 'dart:async';
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
import 'package:playhub/common/data/local/local_storage.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/profile/data/trainer_package_model.dart';
import 'package:playhub/features/profile/ui/screens/profile_screen.dart';
import 'package:playhub/features/reservations/booking_screen.dart';
import 'package:playhub/features/rooms/data/playground_model.dart';
import 'package:playhub/features/rooms/ui/screens/rooms_screen.dart';
import 'package:playhub/models/bookingmodel.dart';
import 'package:playhub/models/ordermodel.dart';
import 'package:playhub/models/playgroundmodel.dart';
import 'package:playhub/screens/HomeScreen/home.dart';
import 'package:playhub/screens/Statistics/statistics_screen.dart';
import 'package:playhub/screens/feedbacks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentScreenIdx = 0;
  List<Widget> pages = [
    const Home(),
    if (LocalStorage().userData?.type == UserType.player) RoomsScreen(),
    if (LocalStorage().userData?.type == UserType.admin) StatisticsScreen(),
    if (LocalStorage().userData?.type == UserType.admin)
      const FeedbacksScreen(),
    if (LocalStorage().userData?.type == UserType.player ||
        LocalStorage().userData?.type == UserType.trainer ||
        LocalStorage().userData?.type == UserType.playgroundOwner)
      const BookingScreen(),
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
  List trainers=[];
  List filteredTrainers=[];
  List items=[];
  int currentSearchTabIndex = 0;

  Future<void> changeSearchQuery(String val) async {
    searchQuery = val;
    if (currentSearchTabIndex == 0) {
      await searchFunction();
    } else {
      await trainerSearchFunction();
    }
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
    var names = [];
    for (var doc in snapshot.docs) {
      var itemData = doc.data();
      if (itemData['Name']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          searchQuery.isEmpty) {
        names.add(itemData);
      }
      if (itemData['City'] == selectedCity || selectedCity == "All") {
        newItems.add(itemData);
      }

      // log("$items");
      // log("$matchesCity");
      // log("$selectedCity");
      // items = matchesCity
    }
    if (names.isEmpty) {
      items = newItems;
    } else if (newItems.isEmpty) {
      items = names;
    } else {
      items = getCommonElements(newItems, names);
    }

    log("$items");

    emit(AppChangeSearchFunction());
  }

  Future<void> trainerSearchFunction() async {
    await getTrainers();
    var newItems = [];
    var names = [];
    log("meraaaaaaaaaaaaaaaa");
    log(searchQuery);
    if (trainers != null) {
      for (var itemData in trainers) {
        if (itemData.fullName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            searchQuery.isEmpty) {
          names.add(itemData);
          log("full:${itemData.fullName}");
          if (itemData.city == selectedCity || selectedCity == "All") {
            newItems.add(itemData);
            log("filter:${itemData.fullName}");
          }
        }

      }
      log("meraaaaaaaaaaaaaaaa");

      log("${newItems}");
      if (names.isEmpty) {
        filteredTrainers = newItems;
      } else if (newItems.isEmpty) {
        filteredTrainers = names;
      } else {
        filteredTrainers = getCommonElements(newItems, names);
      }

    }
    log("filter:${filteredTrainers[0].fullName}");
    log("//////////////////////////////");
    log('$trainers');

    emit(AppChangeSearchFunction());
  }

  void changeTabIndex(int index) async {
    currentSearchTabIndex = index;

    if (currentSearchTabIndex == 0) {
      await searchFunction();
    } else {
      await trainerSearchFunction();
    }
  }

  List<TrainingPackage> packages = [];
  List<String> packagesId = [];

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
        .doc(LocalStorage().currentId)
        .collection('Package');
    ref.add(newPackage.toJson());
    getTrainerPackages();
    emit(PackageAdded(newPackage));
  }

  void getTrainerPackages() async {
    emit(GetTrainerPackagesLoadingState());
    List<TrainingPackage> trainerPackages = [];
    List<String> newPackagesId = [];

    // var trainerId = LocalStorage().userData?.id;

    if (LocalStorage().currentId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(LocalStorage().currentId)
          .collection('Package')
          .get();
      trainerPackages
          .addAll(snapshot.docs.map((e) => TrainingPackage.fromJson(e.data())));
      newPackagesId.addAll(snapshot.docs.map((e) => e.id));
      packages = trainerPackages;
      packagesId = newPackagesId;
      log("الحمار المتهور ضحي${packages}");

      emit(GetTrainerPackagesSuccessState());
    } else {
      emit(GetTrainerPackagesErrorState(
          'Trainer ID not found in local storage'));
    }
  }

  Future<void> updatePackage({
    required String packageId,
    required String description,
    required double price,
    required int duration,
  }) async {
    emit(UpdatePackageLoadingState());
    try {
      var updatedPackage = TrainingPackage(
        description: description,
        price: price,
        duration: duration,
        trainerId: LocalStorage().userData!.id!,
      );

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(LocalStorage().currentId)
          .collection('Package')
          .doc(packageId)
          .update(updatedPackage.toJson());

      getTrainerPackages();
      emit(UpdatePackageSuccessState(updatedPackage));
    } catch (e) {
      log('$e');
      emit(UpdatePackageErrorState());
    }
  }

  Future<void> deletePackage(String packageId) async {
    emit(DeletePackageLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(LocalStorage().currentId)
          .collection('Package')
          .doc(packageId)
          .delete();

      getTrainerPackages();
      emit(DeletePackageSuccessState());
    } catch (e) {
      log('$e');
      emit(DeletePackageErrorState());
    }
  }

  UserModel? userData;
  Future<void> getCurrentUserData() async {
    emit(GetCurrentUserLoadingState());
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        final snapshot =
            await FirebaseFirestore.instance.collection('Users').get();

        for (var doc in snapshot.docs) {
          if (user.uid == doc.data()['Id']) {
            userData = UserModel.fromJson(doc.data());
          }
        }
        emit(GetCurrentUserSuccessState());
      }
    } catch (e) {
      emit(GetCurrentUserErrorState());
    }
  }

  Future<void> getTrainers() async {
    emit(GetTrainersLoadingState());
    try {
      List newTrainers = [];
      final snapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      for (var doc in snapshot.docs) {
        if (doc.data()["Type"] == "Trainer") {
          newTrainers.add(UserModel.fromJson(doc.data()));
        }
      }
      trainers = newTrainers;
      filteredTrainers= newTrainers;

      log("-------------------------------------");
      log('$trainers');
      emit(GetTrainersSuccessState());
    } catch (e) {
      emit(GetTrainersErrorState());
    }
  }

  Future updateUserInfo(
      {required String name,
      required String phone,
      required String email,
      String? city,
      String? region}) async {
    emit(UpdateUserInfoLoadingState());
    try {
      var newUser = UserModel(
          id: LocalStorage().userData?.id,
          fullName: name,
          email: email,
          phoneNumber: phone,
          type: LocalStorage().userData?.type,
          city: city ?? LocalStorage().userData?.city,
          image: LocalStorage().userData?.image,
          region: region ?? LocalStorage().userData?.region);
      userData = newUser;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(LocalStorage().currentId)
          .update(newUser.toJson());
      await LocalStorage().saveUserData(newUser);
      emit(UpdateUserInfoSuccessState());
    } catch (e) {
      emit(UpdateUserInfoErrorState());
    }
  }

  Future<void> updateUserImage(String image) async {
    var userData = LocalStorage().userData;
    var newUser = UserModel(
        id: userData?.id,
        fullName: userData?.fullName,
        email: userData?.email,
        phoneNumber: userData?.phoneNumber,
        type: userData?.type,
        city: userData?.city,
        image: image,
        region: userData?.region);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(LocalStorage().currentId)
        .update(newUser.toJson());
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
          var userData = LocalStorage().userData;
          var newUser = UserModel(
              id: userData?.id,
              fullName: userData?.fullName,
              email: userData?.email,
              phoneNumber: userData?.phoneNumber,
              type: userData?.type,
              city: userData?.city,
              image: downloadURL,
              region: userData?.region);
          await LocalStorage().saveUserData(newUser);
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
          var userData = LocalStorage().userData;
          var newUser = UserModel(
              id: userData?.id,
              fullName: userData?.fullName,
              email: userData?.email,
              phoneNumber: userData?.phoneNumber,
              type: userData?.type,
              city: userData?.city,
              image: downloadURL,
              region: userData?.region);
          LocalStorage().saveUserData(newUser);

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
        await LocalStorage().saveUserData(null);
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
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(LocalStorage().currentId)
            .delete();
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

  Future<void> addNewOrder(
      String? playGroundId, int? time, String? date, bool? booked) async {
    emit(AddNewOrderLoadingState());
    var userData = LocalStorage().userData;
    Ordermodel newModel = Ordermodel(
        userName: userData?.fullName, booked: booked, date: date, time: time);

    BookingModel bookModel = BookingModel(
        categoryId: playground!.categoryId,
        playGroundName: playground!.name,
        userName: userData?.fullName,
        booked: booked,
        date: date,
        time: time);
    CollectionReference ref = FirebaseFirestore.instance
        .collection('PlayGrounds')
        .doc(playGroundId)
        .collection('Orders');
    CollectionReference profileRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(LocalStorage().currentId)
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
          .doc(LocalStorage().currentId)
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
      final fPlayground = await FirebaseFirestore.instance
          .collection('PlayGrounds')
          .doc(id)
          .get();
      if (fPlayground.exists) {
        Map<String, dynamic> favPlayground = fPlayground.data()!;
        favPlayground.addAll({"Id": id});
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(LocalStorage().currentId)
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
      late var pid;
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(LocalStorage().currentId)
          .collection('PFavorites')
          .get();
      for (var doc in snapshot.docs) {
        if (id == doc.data()['Id']) pid = doc.id;
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(LocalStorage().currentId)
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
    emit(GetFavoritesPlaygroundsLoadingState());
    try {
      List<String> ids = [];
      var playgrounds = await FirebaseFirestore.instance
          .collection('Users')
          .doc(LocalStorage().currentId)
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
    playgroundImage = null;
    emit(PickPlaygroundImageLoadingState());
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage != null) {
        File selectedImage = File(returnedImage.path);
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String uniqueID = DateTime.now().millisecondsSinceEpoch.toString();
          Reference ref = storage.ref().child('playground_images/$uniqueID');
          UploadTask uploadTask = ref.putFile(selectedImage);

          await uploadTask;

          playgroundImage = await ref.getDownloadURL();

          emit(PickPlaygroundImageSuccessState());
        }
      }
    } catch (e) {
      emit(PickPlaygroundImageErrorState());
    }
  }

  removeSelectedPlaygroundImage() {
    playgroundImage = null;
    emit(RemoveSelectedPlaygroundImageSuccessState());
  }

  Future<void> addNewPlayground(
      {required name,
      required category,
      required city,
      required region,
      required image}) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Categories').get();
      var id;
      for (var doc in snapshot.docs) {
        if (category == doc.data()['Name']) {
          id = doc.data()['Id'];
          log('${doc.data()['Id']}');
        }
      }
      var newPlayground = Playground(
          categoryId: id,
          city: city,
          image: image,
          name: name,
          ownerId: LocalStorage().userData!.id!,
          region: region);
      await FirebaseFirestore.instance
          .collection('PlayGrounds')
          .add(newPlayground.toJson());
      emit(AddNewPlaygroundSuccessState());
    } catch (e) {
      emit(AddNewPlaygroundErrorState());
    }
  }

  String? categoryName;
  Future<void> getCategoryById(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Categories').get();
    for (var doc in snapshot.docs) {
      if (doc.data()['Id'] == id) categoryName = doc.data()['Name'];
    }
  }

  Future<void> updatePlayground(
      {required pid,
      required name,
      required category,
      required city,
      required region,
      required image}) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Categories').get();
      var id;
      for (var doc in snapshot.docs) {
        if (category == doc.data()['Name']) {
          id = doc.data()['Id'];
          log('${doc.data()['Id']}');
        }
      }
      var newPlayground = Playground(
          categoryId: id,
          city: city,
          image: image,
          name: name,
          ownerId: LocalStorage().userData!.id!,
          region: region);
      await FirebaseFirestore.instance
          .collection('PlayGrounds')
          .doc(pid)
          .update(newPlayground.toJson());
      emit(UpdatePlaygroundSuccessState());
    } catch (e) {
      log('$e');
      emit(UpdatePlaygroundErrorState());
    }
  }

  Future<void> deletePlayground(String id) async {
    emit(DeletePlaygroundLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('PlayGrounds')
          .doc(id)
          .delete();
      getOwnerPlaygrounds();
      emit(DeletePlaygroundSuccessState());
    } catch (e) {
      emit(DeletePlaygroundErrorState());
    }
  }

  List<Map<String, dynamic>> playgroundReservations = [];
  Future<void> getPlaygroundReservations(String id) async {
    List<Map<String, dynamic>> reservations = [];
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('PlayGrounds')
          .doc(id)
          .collection('Orders')
          .get();
      reservations.addAll(snapshot.docs.map((d) => d.data()));
      playgroundReservations = reservations;
      log('$playgroundReservations');
      emit(GetPlaygroundReservationsSuccessState());
    } catch (e) {
      emit(GetPlaygroundReservationsErrorState());
    }
  }

  List<Playground> ownerPlaygrounds = [];
  List<String> ownerPlaygroundsIds = [];
  Future<void> getOwnerPlaygrounds() async {
    emit(GetOwnerPlaygroundsLoadingState());
    try {
      List<Playground> playgrounds = [];
      List<String> ids = [];
      final snapshot =
          await FirebaseFirestore.instance.collection('PlayGrounds').get();
      for (var doc in snapshot.docs) {
        if (doc.data()['Owner_Id'] == LocalStorage().userData?.id) {
          playgrounds.add(Playground.fromJson(doc.data()));
          ids.add(doc.id);
        }
      }
      ownerPlaygrounds = playgrounds;
      ownerPlaygroundsIds = ids;
      emit(GetOwnerPlaygroundsSuccessState());
    } catch (e) {
      emit(GetOwnerPlaygroundsErrorState());
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

  Future<void> addFeedback(String userName, String feedback) async {
    emit(AddFeedBackLoadingState());
    CollectionReference feedbackRef =
        FirebaseFirestore.instance.collection('Feedbacks');
    try {
      await feedbackRef.add({
        "UserName": userName,
        "Feedback": feedback,
        "UserEmail": LocalStorage().userData?.email
      });
      emit(AddFeedBackSuccessState());
    } catch (error) {
      print(error);
      emit(AddFeedBackErrorState());
    }
  }

  List<Map<String, dynamic>> feedbacks = [];
  Future<void> getFeedbacks() async {
    List<Map<String, dynamic>> feedback = [];
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("Feedbacks").get();
      feedback.addAll(snapshot.docs.map((doc) => doc.data()));
      feedbacks = feedback;
      log('$feedbacks');
      emit(GetFeedbacksSuccessState());
    } catch (e) {
      emit(GetFeedbacksErrorState());
    }
  }
}
