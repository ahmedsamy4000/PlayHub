import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/rooms/cubits/rooms_states.dart';
import 'package:playhub/features/rooms/ui/screens/add_room_screen.dart';
import '../../cubits/rooms_cubit.dart';
import '../../data/room_model.dart';
import '../widgets/custom_list_room_item.dart';

class RoomsScreen extends StatelessWidget {
  RoomsScreen({super.key});
  List<RoomModel> rooms=[];
  List<UserModel> roomOwners=[];
  List<List<UserModel>> roomsPlayers=[];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit()..getAllRooms(),
      child: BlocBuilder<RoomsCubit,RoomsStates>(
          builder: (context,state) {
            if(state is GetRoomsDataState){
              rooms=state.rooms;
              roomOwners=state.roomOwners;
              roomsPlayers=state.roomsPlayers;
            }
            return DefaultTabController(
              initialIndex: 0,
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Rooms"),
                  actions: [
                    IconButton(onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddRoomScreen()));
                    }, icon: Icon(Icons.add_circle))
                  ],
                  bottom: const TabBar(
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
                ),
                body: TabBarView(
                  children: <Widget>[
                    ListView.separated(
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: ListRoomItem(room:rooms[index],roomOwner:roomOwners[index],roomsPlayers: roomsPlayers[index],),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),

                    Center(
                      child: Text("It's rainy here"),
                    ),
                    Center(
                      child: Text("It's sunny here"),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}


