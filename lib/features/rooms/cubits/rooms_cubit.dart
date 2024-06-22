import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:playhub/features/rooms/cubits/rooms_states.dart';
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
  late var userData;
  Future<void> getCurrentUserData() async {
    //emit(GetCurrentUserLoadingState());
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        final snapshot =
        await FirebaseFirestore.instance.collection('Users').get();

        for (var doc in snapshot.docs) {
          if (user.uid == doc.data()['Id']) userData = doc.data();
        }

      }
    } catch (e) {
      //emit(GetCurrentUserErrorState());
    }
  }
  void createRoom({required String? playground,required String date,required String time,required String? period,required String? level})async{
    await getCurrentUserData();
    RoomModel room =RoomModel(playground: playground!, category: category!, city: city!, date: date, time: time, period: period!, playersNum: playersNum!, comment: comment,level: level!, authUserId: userData["Id"]);

    FirebaseFirestore.instance
        .collection('Rooms')
        .add(room.toJson())
        .then((DocumentReference docRef) {
      //log('DocumentSnapshot added with ID: ${docRef.id}');
    }).catchError((error) {
      //log('Error adding document: $error');
    });

  }
}