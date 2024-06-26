import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/rooms/cubits/rooms_states.dart';
import 'package:playhub/features/rooms/ui/screens/add_room_screen.dart';
import '../../../../common/data/local/local_storage.dart';
import '../../cubits/rooms_cubit.dart';
import '../../data/room_model.dart';
import '../widgets/custom_list_room_item.dart';

class RoomsScreen extends StatelessWidget {
  RoomsScreen({super.key});
  List<RoomModel> rooms = [];
  List<String> roomsIds = [];
  List<UserModel> roomOwners = [];
  List<RoomModel> currentUserRooms = [];
  List<String> currentUserRoomIds = [];
  List<UserModel> currentUserRoomOwners = [];
  List<RoomModel> userJoinedRooms = [];
  List<String> userJoinedRoomsIds = [];
  List<UserModel> userJoinedRoomOwners = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit()
        ..getAllRooms()
        ..getAllCategory(),
      child: BlocBuilder<RoomsCubit, RoomsStates>(
        builder: (context, state) {
          if (state is GetRoomsDataState) {
            rooms = state.rooms;
            roomOwners = state.roomOwners;
            roomsIds = state.roomsIds;
            currentUserRooms = [];
            currentUserRoomIds = [];
            currentUserRoomOwners = [];
            userJoinedRooms = [];
            userJoinedRoomsIds = [];
            userJoinedRoomOwners = [];
            for (int i = 0; i < rooms.length; i++) {
              if (rooms[i].authUserId == LocalStorage().userData?.id) {
                currentUserRooms.add(rooms[i]);
                currentUserRoomIds.add(roomsIds[i]);
                currentUserRoomOwners.add(roomOwners[i]);
              }
              if (rooms[i].players.contains(LocalStorage().userData?.id)) {
                userJoinedRooms.add(rooms[i]);
                userJoinedRoomsIds.add(roomsIds[i]);
                userJoinedRoomOwners.add(roomOwners[i]);
              }
            }
          }
          return DefaultTabController(
            initialIndex: 0,
            length: 3,
            child: Scaffold(
              backgroundColor: AppColors.greenBackground,
              appBar: AppBar(
                backgroundColor: AppColors.greenBackground,
                title:  Text(
                    "Rooms",
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRoomScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.add_circle),
                  ),
                ],
              ),
              body: Column(
                children: [
                  TabBar(
                    tabs: <Widget>[
                      Tab(
                        child: Text("All",
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                          ),
                        ),
                      ),
                      Tab(
                        child: Text("Created by me",
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                          ),),
                      ),
                      Tab(
                        child: Text("Joined",
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                          ),),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        ListView.builder(
                          itemCount: rooms.length,
                          itemBuilder: (cont, index) {
                            return ListTile(
                              title: ListRoomItem(
                                room: rooms[index],
                                roomOwner: roomOwners[index],
                                roomId: roomsIds[index],
                              ),
                            );
                          },
                        ),
                        ListView.builder(
                          itemCount: currentUserRooms.length,
                          itemBuilder: (cont, index) {
                            return ListTile(
                              title: ListRoomItem(
                                room: currentUserRooms[index],
                                roomOwner: currentUserRoomOwners[index],
                                roomId: currentUserRoomIds[index],
                              ),
                            );
                          },

                        ),
                        ListView.builder(
                          itemCount: userJoinedRooms.length,
                          itemBuilder: (cont, index) {
                            return ListTile(
                              title: ListRoomItem(
                                room: userJoinedRooms[index],
                                roomOwner: userJoinedRoomOwners[index],
                                roomId: userJoinedRoomsIds[index],
                              ),
                            );
                          },

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void showCustomModalBottomSheet(BuildContext context,List<String> cities) {
  showModalBottomSheet(
      context: context,
      //isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return  Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cities.length,
              itemBuilder: (con,index){
                return InkWell(child: Text(cities[index]));
              }
        ),
        );
        },
      );
}