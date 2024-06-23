import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/rooms/data/room_model.dart';

import '../../../../core/app_colors.dart';
import '../widgets/user_component.dart';

class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({super.key, required this.room, required this.roomOwner, required this.roomPlayers});
  final RoomModel room;
  final UserModel roomOwner;
  final List<UserModel> roomPlayers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          UserComponent(user: roomOwner),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${room.category}",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              Text("${room.playground}@${room.city}",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              room.comment!=null?
              Text("${room.comment}",
                style: TextStyle(
                    fontSize: 20
                ),
              )
                  :SizedBox.shrink(),

              Text("${room.level} Level",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              Text("${room.date}@${room.time}",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              Text("${room.period}",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              Text("Players:",
                style: TextStyle(
                    fontSize: 20
                ),
              ),

            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: roomPlayers.length,
              itemBuilder: (context, index) {
                return UserComponent(user: roomPlayers[index]);
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}


