import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/authentication/ui/widgets/custom_login_button.dart';
import 'package:playhub/features/rooms/cubits/rooms_cubit.dart';
import 'package:playhub/features/rooms/data/room_model.dart';
import 'package:playhub/features/rooms/ui/screens/rooms_screen.dart';

import '../../../../core/app_colors.dart';
import '../widgets/user_component.dart';

class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({super.key, required this.room, required this.roomOwner, required this.roomId});
  final RoomModel room;
  final UserModel roomOwner;
  final String roomId;
  @override
  Widget build(BuildContext context) {
    var cubit=context.read<RoomsCubit>();
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
              itemCount: cubit.players.length,
              itemBuilder: (context, index) {
                return UserComponent(user: cubit.players[index]);
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
          LoginButton(
              onTap: (){
                cubit.playerJoinRoom(id: roomId, room: room).then((_){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoomsScreen()));
                });
              },
              text: "Join",
              gradiantColor: AppColors.loginGradiantColorButton,
              tapedGradiantColor: AppColors.loginGradiantColorButtonTaped
          )
        ],
      ),
    );
  }
}


