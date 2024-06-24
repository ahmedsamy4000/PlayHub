import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:playhub/common/data/local/local_storage.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/rooms/cubits/rooms_states.dart';
import 'package:playhub/features/rooms/data/category_model.dart';
import 'package:playhub/features/rooms/data/playground_model.dart';
import 'package:playhub/features/rooms/data/room_model.dart';


class RoomsCubit extends Cubit<RoomsStates> {
  RoomsCubit() : super(RoomsInitialState());

  void pickDate(DateTime date) {
    String formattedDate = DateFormat('dd MMM yyyy').format(date);
    emit(DateChangeState(formattedDate));
  }

  void pickTime(TimeOfDay time) {
    DateTime now = DateTime.now();
    DateTime selectedDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    String formattedTime = DateFormat('hh:mm a').format(selectedDateTime);
    emit(TimeChangeState(playTime:formattedTime));
  }
  void getPlaygrounds() async {
    try {
      var data = await FirebaseFirestore.instance.collection('PlayGrounds').get();

      List<String> playgrounds = [];
      for (var document in data.docs) {
        Playground playground = Playground.fromJson(document.data());
        playgrounds.add(playground.name);
      }
      emit(GetPlaygroundDataState(playgrounds: playgrounds));
    } catch (e) {
      print('Error retrieving playgrounds: $e');
    }
  }

  String? category;
  void setCategory(String? value){
    category=value;
  }

  String? playersNum;
  void setPlayersNum(String? value){
    playersNum=value;
  }

  String? city;
  void setCity(String? value){
    city=value;
  }

  String? comment;
  void setComment(String? value){
    comment=value;
  }

  bool checkValidation({required String? date,required String? time,required String? playground, required String? period, required String? level}){
    if(category==null||city==null||date==null||time==null||playersNum==null||playground==null||period==null||level==null)
    {
      emit(CreateRoomsErrorState());
      return false;
    }
    return true;
  }
  Future<UserModel?> getUserById({required String id}) async {
    UserModel? user;
    try {
        final snapshot = await FirebaseFirestore.instance.collection('Users').get();
        log('$snapshot');
        for (var doc in snapshot.docs) {
          log('message1');
          if (id == doc.data()['Id']){
            log('${doc.data()}');
            user = UserModel.fromJson(doc.data());
            log('message3');
          }

        }
        return user;
    } catch (e) {
      log('$e');
      return null;
      //emit(GetCurrentUserErrorState());
    }
  }
  void createRoom({required String? playground,required String date,required String time,required String? period,required String? level})async{

    RoomModel room =RoomModel(playground: playground!, category: category!, city: city!, date: date, time: time, period: period!, playersNum: playersNum!, comment: comment,level: level!, authUserId: LocalStorage().userData!.id!,players: []);

    FirebaseFirestore.instance
        .collection('Rooms')
        .add(room.toJson())
        .then((DocumentReference docRef) {
      //log('DocumentSnapshot added with ID: ${docRef.id}');
    }).catchError((error) {
      //log('Error adding document: $error');
    });
  }

  void getAllRooms()async{
    try {
      var data = await FirebaseFirestore.instance.collection('Rooms').get();
      List<RoomModel> rooms = [];
      List<UserModel> roomOwners=[];

      List<String> roomsId=[];
      for (var document in data.docs) {
        RoomModel room = RoomModel.fromJson(document.data());
        rooms.add(room);
        log('${room}');
        UserModel? user=await getUserById(id:room.authUserId);
        log('${user}');
        roomOwners.add(user!);
        roomsId.add(document.id);
      }

      emit(GetRoomsDataState(rooms: rooms,roomOwners:roomOwners,roomsIds:roomsId));
    } catch (e) {
      print('Error retrieving playgrounds: $e');
    }
  }
  List<CategoryModel> categories = [];

  void getAllCategory()async{
    try {
      var data = await FirebaseFirestore.instance.collection('Categories').get();

      for (var document in data.docs) {
        CategoryModel category = CategoryModel.fromJson(document.data());
        categories.add(category);
      }
      emit(GetAllCategoryState());
    } catch (e) {
    }
  }

  List<UserModel> players=[];
  Future<void> getRoomPlayers({required List<dynamic> roomPlayers}) async{
    players=[];
    for(var playerId in roomPlayers){
      UserModel? player=await getUserById(id:playerId);
      players.add(player!);
    }
  }

  Future<void> playerJoinRoom({required String id,required RoomModel room}) async{

    room.players.add(LocalStorage().userData?.id);
    await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(id)
        .update(room.toJson());
  }

  Future<void> playerUnJoinRoom({required String id,required RoomModel room}) async{
    room.players.remove(LocalStorage().userData?.id);
    await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(id)
        .update(room.toJson());
  }

}
