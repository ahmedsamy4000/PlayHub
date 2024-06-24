import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/rooms/cubits/rooms_states.dart';
import 'package:playhub/features/rooms/ui/screens/add_room_screen.dart';
import '../../../../common/data/local/local_storage.dart';
import '../../../../screens/SearchScreen/CategoryButton.dart';
import '../../cubits/rooms_cubit.dart';
import '../../data/room_model.dart';
import '../widgets/custom_list_room_item.dart';
 // Import the CategoryButton widget

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
      create: (context) => RoomsCubit()..getAllRooms(),
      child: BlocBuilder<RoomsCubit, RoomsStates>(
        builder: (context, state) {
          if (state is GetRoomsDataState) {
            rooms = state.rooms;
            roomOwners = state.roomOwners;
            roomsIds = state.roomsIds;
            currentUserRooms=[];
            currentUserRoomIds=[];
            currentUserRoomOwners=[];
            userJoinedRooms=[];
            userJoinedRoomsIds=[];
            userJoinedRoomOwners=[];            for (int i = 0; i < rooms.length; i++) {
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
              appBar: AppBar(
                title: const Text("Rooms"),
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
                  )
                ],
              ),
              body: Column(
                children: [
                  Row(
                    children: [
                      CategoryButton(
                        text: "All",
                        isSelected: true,
                        onTap: () {
                          // Implement the onTap functionality
                        },
                      ),
                      CategoryButton(
                        text: "Category one",
                        isSelected: false,
                        onTap: () {
                          // Implement the onTap functionality
                        },
                      ),
                      CategoryButton(
                        text: "Category two",
                        isSelected: false,
                        onTap: () {
                          // Implement the onTap functionality
                        },
                      ),

                    ],
                  ),
                  TabBar(
                    tabs: <Widget>[
                      Tab(
                        child: Text("All"),
                      ),
                      Tab(
                        child: Text("Created by me"),
                      ),
                      Tab(
                        child: Text("Joined"),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        ListView.separated(
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
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        ),
                        ListView.separated(
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
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        ),
                        ListView.separated(
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
                          separatorBuilder: (context, index) {
                            return Divider();
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
