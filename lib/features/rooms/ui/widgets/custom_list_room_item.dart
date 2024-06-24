import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/common/data/local/local_storage.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/rooms/data/room_model.dart';
import 'package:playhub/features/rooms/ui/screens/room_details_screen.dart';

import '../../../../core/app_colors.dart';
import '../../cubits/rooms_cubit.dart';

class ListRoomItem extends StatelessWidget {
  const ListRoomItem({
    super.key, required this.room, required this.roomOwner, required this.roomId,
  });
  final RoomModel room;
  final UserModel roomOwner;
  final String roomId;
  @override
  Widget build(BuildContext context) {
    var cubit=context.read<RoomsCubit>();
    String currentUserType;
    return InkWell(
      onTap: (){
        cubit.getRoomPlayers(roomPlayers: room.players).then((_){
          if(roomOwner.id==LocalStorage().userData?.id){
            currentUserType="Owner";
          }else if(room.players.contains(LocalStorage().userData?.id)){
            currentUserType="Player";
          }else{
            currentUserType="Stranger";
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (con) => BlocProvider.value(
                value: context.read<RoomsCubit>(),
                  child: RoomDetailsScreen(room: room,roomOwner: roomOwner,roomId:roomId,currentUserType:currentUserType))));
        });
        },
      child: Container(
        margin: 10.padVertical,
        padding: 10.padAll,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10.0,
              offset: const Offset(3, 5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              offset: const Offset(-1, -1),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                roomOwner.image == null
                    ? CircleAvatar(
                  backgroundColor: AppColors.darkGreen,
                  radius: 35.r,
                  child: Text(
                    roomOwner.fullName == null
                        ? ''
                        : '${roomOwner.fullName![0]}',
                    style: const TextStyle(
                        fontSize: 30,
                        color: AppColors.white),
                  ),
                )
                    : CircleAvatar(
                  backgroundColor: AppColors.darkGreen,
                  backgroundImage:
                  NetworkImage(roomOwner.image!),
                  radius: 35.r,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(roomOwner.fullName??""),
                      Text(room.playground),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children:  [
                          Text(room.date),
                          Text(room.time),
                        ],
                      ),
                      room.comment!=null?
                       Text(room.comment!):SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${room.level} Level"),
                Text("${room.period}"),
                Text("${room.players.length+1}/${room.playersNum}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}